#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# submitJournal.py
#
# Created by ruibin.chow on 2017/08/21.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""
提交项目日志
"""

from service.project import project
from module.database import DB
from module.log.Log import Loger
from config import *
from common.code import *
from common.auth import vertifyTokenHandle
from common.tools import getValueFromRequestByKey, generateUUID, generateCurrentTime
from common.commonMethods import verifyIsProjectAuthor, verifyProjectMember, MemberQueryException
from common.file import FileTypeException, uploadPicture
import shutil, os.path
import common.notification as notification
# from dispatch.tasks import dispatchNotificationUserForContent


@project.route('/submit_journal', methods=["GET", "POST"])
@vertifyTokenHandle
def submitJournal():
    userUUID = getValueFromRequestByKey("user_uuid")
    projectUUID = getValueFromRequestByKey("project_uuid")
    content = getValueFromRequestByKey("content")

    if verifyIsProjectAuthor(userUUID, projectUUID) == False:
        if verifyProjectMember(userUUID, projectUUID) == False:
            return RESPONSE_JSON(CODE_ERROR_QUERY_PROJECT_MEMBER)
    
    journalUUID = generateUUID()

    mediasDict = __uploadMedias(journalUUID, projectUUID)
    if type(mediasDict) != dict:
        return mediasDict
    else:
        # 存储图片没问题操作后续更新数据库
        response = __submitJournalToStorage(journalUUID, userUUID, projectUUID, content, mediasDict)
        return response


def __uploadMedias(journalUUID, projectUUID):
    saveNameDict = {}
    journalUUIDDirector = projectUUID + "/" + journalUUID + "/"
    try:
        saveNameDict = uploadPicture(Config.UPLOAD_FILE_FOR_PROJECT, journalUUIDDirector)
    except FileTypeException as e:
        Loger.error(e, __file__)
        return RESPONSE_JSON(CODE_ERROR_IMAGE_UNSUPPORTED_TYPE)
    except FileTypeException as e:
        Loger.error(e, __file__)
        return RESPONSE_JSON(CODE_ERROR_IMAGE_TOO_LARGE)
    except Exception as e:
        Loger.error(e, __file__)
        return RESPONSE_JSON(CODE_ERROR_IMAGE_SERVICE_ERROR)
    else:
        return saveNameDict


def __submitJournalToStorage(journalUUID, userUUID, projectUUID, content, mediasDict={}):
    sqlList = []
    argsList = []
    time = generateCurrentTime()

    path = __journalMediasPath(projectUUID, journalUUID)
    if len(mediasDict) > Config.UPLOAD_FILE_FOR_JOURNAL_MEDIAS_COUNT: 
        if os.path.exists(path): shutil.rmtree(path)
        Loger.error(MESSAGE[CODE_ERROR_IMAGE_NUMBER_TOO_MANY], __file__)
        return RESPONSE_JSON(CODE_ERROR_IMAGE_NUMBER_TOO_MANY)

    # 项目多媒体内容
    mediasCount = len(mediasDict)
    if mediasCount > 0:
        insertMediasSQL, insertMediasArgs = __insertMediasSQLString(journalUUID, projectUUID, mediasDict, time)
        sqlList.append(insertMediasSQL)
        argsList.append(insertMediasArgs)

    # 插入日志
    insertJournalSQL = """
        INSERT INTO t_project_journal (uuid, project_uuid, user_uuid, content, `like`,medias_count, time)
        VALUES (%s, %s, %s, %s, 0, %s, %s);"""
    insertJournalArgs = [journalUUID, projectUUID, userUUID, content, str(mediasCount), time]
    sqlList.append(insertJournalSQL)
    argsList.append(insertJournalArgs)

    # 通知成员项目更新了
    memberList = __queryProjectMembers(projectUUID, userUUID)
    if type(memberList) != list:
        if os.path.exists(path): shutil.rmtree(path)
        Loger.error(MESSAGE[CODE_ERROR_QUERY_PROJECT_MEMBER], __file__)
        return RESPONSE_JSON(CODE_ERROR_QUERY_PROJECT_MEMBER)
    else:
        if len(memberList) > 0:
            insertProjectMessageSQL, insertProjectMessageArgs = __insertProjectMessageSQLString(memberList, projectUUID, userUUID, time)
            sqlList.append(insertProjectMessageSQL)
            argsList.append(insertProjectMessageArgs)

    # print sqlList

    dbManager = DB.DBManager.shareInstanced()
    try:
        dbManager.executeTransactionMutltiDmlWithArgsList(sqlList, argsList)
    except Exception as e:
        Loger.error(e, __file__)
        if os.path.exists(path): shutil.rmtree(path)
        return RESPONSE_JSON(CODE_ERROR_SERVICE)
    else:
        __notificationMember(memberList)
        return RESPONSE_JSON(CODE_SUCCESS)


def __queryProjectMembers(projectUUID, userUUID):
    memberList = None
    queryProjectMemberSQL = """
        SELECT user_uuid FROM t_project_user WHERE project_uuid=%s AND type=%s 
        UNION
        SELECT author_uuid AS user_uuid FROM t_project WHERE uuid=%s;
    """
    queryProjectMemberArgs = [projectUUID, Config.TYPE_FOR_PROJECT_MEMBER, projectUUID]

    dbManager = DB.DBManager.shareInstanced()
    try:
        tempList = dbManager.executeSingleQueryWithArgs(queryProjectMemberSQL, queryProjectMemberArgs, False)
        memberList = [data[0] for data in tempList]
        if userUUID in memberList: memberList.remove(userUUID)
    except Exception as e:
        Loger.error(e, __file__)
        return MemberQueryException()
    else:
        return memberList
    

def __insertMediasSQLString(journalUUID, projectUUID, mediasDict, time):
    insertMediasArgs = []
    insertMediasSQL = """INSERT INTO t_project_journal_media (journal_uuid, project_uuid, sorting, type, media_name, time) VALUES """
    values = ""
    typeInt = Config.TYPE_FOR_PROJECT_MEDIAS_PICTURE
    for key, value in mediasDict.items():
        values += """(%s, %s, %s, %s, %s, %s),"""
        insertMediasArgs.append(journalUUID)
        insertMediasArgs.append(projectUUID)
        insertMediasArgs.append(key)
        insertMediasArgs.append(str(typeInt))
        insertMediasArgs.append(value)
        insertMediasArgs.append(time)
    insertMediasSQL += values[:-1] + ";"
    return insertMediasSQL, insertMediasArgs


def __insertProjectMessageSQLString(memberList, projectUUID, userUUID, time):
    insertProjectMessageArgs = []
    insertProjectMessageSQL = """INSERT INTO t_message_project (user_uuid, type, content_uuid, owner_user_uuid, status, content, action, time) VALUES """
    values = ""
    typeString = Config.TYPE_FOR_MESSAGE_IN_PROJECT_UPDATE_JOURNAL
    for member in memberList:
        values += """(%s, %s, %s, %s, 0, %s, 0, %s),"""
        insertProjectMessageArgs.append(member)
        insertProjectMessageArgs.append(str(typeString))
        insertProjectMessageArgs.append(projectUUID)
        insertProjectMessageArgs.append(userUUID)
        insertProjectMessageArgs.append('提交了日志')
        insertProjectMessageArgs.append(time)
    insertProjectMessageSQL += values[:-1] + ";"
    return insertProjectMessageSQL, insertProjectMessageArgs


def __journalMediasPath(projectUUID, journalUUID):
    path = Config.FULL_UPLOAD_FOLDER + Config.UPLOAD_FILE_FOR_PROJECT + "/" + projectUUID + "/" + journalUUID + "/"
    return path
    

def __notificationMember(memberList):
    for memeber in memberList:
        content = "提交了日志"
        notification.notificationUserForContent(memeber, content)
        # dispatchNotificationUserForContent.delay(memeber, content)
    


if __name__ == '__main__':
    pass
