#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# modifyProject.py
#
# Created by ruibin.chow on 2017/08/18.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""
修改项目(标题不可更改)
"""
from service.project import project
from flask import Flask, Response, request
from module.database import DB
from module.log.Log import Loger
from config import *
from common.code import *
from common.auth import vertifyTokenHandle
from common.tools import getValueFromRequestByKey, generateUUID
from common.file import FileTypeException, uploadPicture
import json, os
import common.notification as notification
# from dispatch.tasks import dispatchNotificationUserForContent


@project.route('/modify_project', methods=["GET", "POST"])
@vertifyTokenHandle
def modifyProject():
    userUUID = getValueFromRequestByKey("user_uuid")
    projectUUID = getValueFromRequestByKey("project_uuid")
    dataJson = getValueFromRequestByKey("dataJson")

    if userUUID == None or projectUUID == None or dataJson == None:
        return RESPONSE_JSON(CODE_ERROR_MISS_PARAM)
    
    dataJsonDict = None
    mediasDict = None
    try:
        dataJsonDict = json.loads(dataJson)
        memberList = __queryProjectMembers(projectUUID)
    except MemberQueryException as mbe:
        Loger.error(mbe, __file__)
        return RESPONSE_JSON(CODE_ERROR_QUERY_PROJECT_MEMBER)
    except Exception as e:
        Loger.error(e, __file__)
        return RESPONSE_JSON(CODE_ERROR_ILLEGAL_CREATE_PROJECT_JSON_CONTENT)

    mediasDict = __uploadMedias(projectUUID)
    if type(mediasDict) != dict:
        return mediasDict

    # 存储图片没问题操作后续更新数据库
    response = __updateProjectStorage(userUUID, projectUUID, dataJsonDict, mediasDict, memberList)
    return response
    

def __uploadMedias(projectUUID):
    saveNameDict = None
    try:
        saveNameDict = uploadPicture(Config.UPLOAD_FILE_FOR_PROJECT, projectUUID)
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


def __updateProjectStorage(userUUID, projectUUID, dataJsonDict, mediasDict, memberList):
    path = Config.FULL_UPLOAD_FOLDER + Config.UPLOAD_FILE_FOR_PROJECT + "/" + projectUUID + "/"
    if len(mediasDict) > 9:
        __removeFileOnError(path, mediasDict.values())
        Loger.error(MESSAGE[CODE_ERROR_IMAGE_NUMBER_TOO_MANY], __file__)
        return RESPONSE_JSON(CODE_ERROR_IMAGE_NUMBER_TOO_MANY)
    
    oldMediasQuerySQL = """ SELECT media_name FROM t_project_media WHERE project_uuid='%s';""" % projectUUID
    sqlList = __packageSQL(userUUID, projectUUID, dataJsonDict, mediasDict, memberList)

    fileList = []
    dbManager = DB.DBManager.shareInstanced()
    try:
        oldMediasList = dbManager.executeSingleQuery(oldMediasQuerySQL, False)
        fileList = [data[0] for data in oldMediasList]
        dbManager.executeTransactionMutltiDml(sqlList)
    except Exception as e:
        Loger.error(e, __file__)
        __removeFileOnError(path, mediasDict.values())
        return RESPONSE_JSON(CODE_ERROR_SERVICE)
    else:
        __removeFileOnError(path, fileList)
        __notificationMessageToMember(projectUUID, userUUID, memberList)
        return RESPONSE_JSON(CODE_SUCCESS)


def __removeFileOnError(path, fileList):
    for fileName in fileList:
        fullPath = path + fileName
        os.remove(fullPath)


def __packageSQL(userUUID, projectUUID, dataJsonDict, mediasDict, memberList):
    sqlList = []

    # 项目多媒体内容(先删除后插入新的)
    deleteMdiasSQL = """DELETE FROM t_project_media WHERE project_uuid='%s';""" % projectUUID
    sqlList.append(deleteMdiasSQL)
    medias_count = len(mediasDict)
    if medias_count > 0:
        insertMediasSQL = """INSERT INTO t_project_media (project_uuid, sorting, type, media_name) VALUES """
        values = ""
        typeInt = Config.TYPE_FOR_PROJECT_MEDIAS_PICTURE
        for key, value in mediasDict.items():
            values += """('%s', %s, %d, '%s'),""" % (projectUUID, key, typeInt, value)
        insertMediasSQL += values[:-1] + ";"
        sqlList.append(insertMediasSQL)
    
    # 项目计划列表(先删除后插入新的)
    deletePlanSQL = """DELETE FROM t_project_plan WHERE project_uuid='%s';""" % projectUUID
    sqlList.append(deletePlanSQL)
    have_plan = 0
    planList = dataJsonDict["planList"]
    planListLen = len(planList)
    if planListLen > 0 :
        have_plan = 1
        insertPlanSQL = """INSERT INTO t_project_plan (project_uuid, sorting, content, start_time, finish_time, medias_count) VALUES """
        values = ""
        for x in range(planListLen):
            data = planList[x]
            content = data["content"]
            startTime = data["startTime"]
            finishTime = data["finishTime"]
            values += """('%s', %d, '%s', '%s', '%s', 0),""" % (projectUUID, x, content, startTime, finishTime)
        insertPlanSQL += values[:-1] + ";"
        sqlList.append(insertPlanSQL)

    # 项目标签列表(先删除后插入新的)
    deleteTagsSQL = """DELETE FROM t_tag_project WHERE project_uuid='%s';""" % projectUUID
    sqlList.append(deleteTagsSQL)
    tagList = dataJsonDict["tagList"]
    tagListLen = len(tagList)
    if tagListLen > 0 :
        insertTagSQL = """INSERT INTO t_tag_project (project_uuid, sorting, type, content) VALUES """
        values = ""
        for i in range(tagListLen):
            values += """('%s', %d, %d, '%s'),""" % (projectUUID, i, i, tagList[i])
        insertTagSQL += values[:-1] + ";"
        sqlList.append(insertTagSQL)

    # 更新主项目
    updateProjectSQL = """UPDATE t_project SET detail='{detail}', result='{result}', have_plan={have_plan}, medias_count={medias_count} WHERE uuid='{uuid}'; """.format(uuid=projectUUID, 
        detail=dataJsonDict["detail"], result=dataJsonDict["result"], 
        author_uuid=dataJsonDict["user_uuid"], have_plan=have_plan, 
        medias_count=medias_count)
    sqlList.append(updateProjectSQL)

    # 通知成员项目更新了
    insertProjectMessageSQL = """INSERT INTO t_message_project (user_uuid, type, content_uuid, owner_user_uuid, status, content, action) VALUES """
    values = ""
    typeString = Config.TYPE_FOR_MESSAGE_IN_PROJECT_UPDATE_PROJECT
    for member in memberList:
        values += """('%s', %d, '%s', '%s', 0, '%s', 0),""" % (member, typeString, projectUUID, userUUID, '更新了项目')
    insertProjectMessageSQL += values[:-1] + ";"
    sqlList.append(insertProjectMessageSQL)

    return sqlList
    

def __queryProjectMembers(projectUUID):
    memberList = None
    queryProjectMemberSQL = """SELECT user_uuid FROM t_project_user WHERE project_uuid='%s' AND type=%s""" % (projectUUID, Config.TYPE_FOR_PROJECT_MEMBER)

    dbManager = DB.DBManager.shareInstanced()
    try:
        tempList = dbManager.executeSingleQuery(queryProjectMemberSQL, False)
        memberList = [data[0] for data in tempList]

    except Exception as e:
        Loger.error(e, __file__)
        raise MemberQueryException()
    else:
        return memberList


def __notificationMessageToMember(projectUUID, userUUID, memberList):
    for memeber in memberList:
        content = "更新了项目"
        notification.notificationUserForContent(memeber, content)
        # dispatchNotificationUserForContent.delay(memeber, content)


class MemberQueryException(Exception):  
    def __init__(self, err='Member Query Exception!'):  
        Exception.__init__(self,err)  


if __name__ == '__main__':
    pass
