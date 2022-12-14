#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# applyJoinAndAgree.py
#
# Created by ruibin.chow on 2017/08/22.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""
申请加入项目与作者同意加入
"""


from service.project import project
from module.database import DB
from module.log.Log import Loger
from config import *
from common.code import *
from common.auth import vertifyTokenHandle
from common.tools import getValueFromRequestByKey, generateUUID, generateCurrentTime
from common.commonMethods import queryProjectString, MemberQueryException
import common.notification as notification
# from dispatch.tasks import dispatchNotificationUserForContent


@project.route('/apply_join_and_agree', methods=["GET", "POST"])
@vertifyTokenHandle
def applyJoinAndAgree():
    userUUID = getValueFromRequestByKey("user_uuid")
    projectUUID = getValueFromRequestByKey("project_uuid")
    typeStr = int(getValueFromRequestByKey("type"))
    authorUUID = getValueFromRequestByKey("author_uuid")

    if userUUID == None or projectUUID==None or authorUUID==None:
        return RESPONSE_JSON(CODE_ERROR_MISS_PARAM) 

    if typeStr == Config.TYPE_FOR_MESSAGE_IN_PROJECT_TO_APPLY:
        return __applyJoinProject(userUUID, projectUUID, authorUUID)
    elif typeStr == Config.TYPE_FOR_MESSAGE_IN_PROJECT_APPLY_AGREE:
        return __agreeJoinIntoProject(userUUID, projectUUID, authorUUID)
    else:
        return RESPONSE_JSON(CODE_ERROR_MISS_PARAM)


def __applyJoinProject(userUUID, projectUUID, authorUUID):
    time = generateCurrentTime()
    insertMessageSQL = """
        INSERT INTO t_message_project (user_uuid, type, content_uuid, owner_user_uuid,
            status, action, time) VALUES ('%s', %d, '%s', '%s', %d, %d, '%s');
    """ % (authorUUID,  Config.TYPE_FOR_MESSAGE_IN_PROJECT_TO_APPLY, projectUUID,
            userUUID, Config.TYPE_FOR_MESSAGE_UNREAD, Config.TYPE_FOR_MESSAGE_ACTION_OFF, 
            time)

    dbManager = DB.DBManager.shareInstanced()
    try:
        dbManager.executeTransactionDml(insertMessageSQL)
    except Exception as e:
        Loger.error(e, __file__)
        return RESPONSE_JSON(CODE_ERROR_SERVICE)
    else:
        __notificationMember(authorUUID, "申请加入项目")
        return RESPONSE_JSON(CODE_SUCCESS)


def __agreeJoinIntoProject(userUUID, projectUUID, authorUUID):
    sqlList = []
    time = generateCurrentTime()
    # 成为项目成员同时关注该项目
    insertProjectUserSQL = """
        INSERT INTO t_project_user (project_uuid, type, user_uuid, time) 
        VALUES ('{projectUUID}', {memberType}, '{userUUID}', '{time}'), 
            ('{projectUUID}', {followType}, '{userUUID}', '{time}');
    """.format(projectUUID=projectUUID, userUUID=userUUID, 
                memberType=Config.TYPE_FOR_PROJECT_MEMBER, 
                followType=Config.TYPE_FOR_PROJECT_FOLLOWER, time=time)
    sqlList.append(insertProjectUserSQL)

    # 消息中action状态改为已执行即on 
    updateMessageSQL = """
        UPDATE t_message_project SET action=%d 
        WHERE user_uuid='%s' AND content_uuid='%s' AND type=%d AND owner_user_uuid='%s';
    """ % (Config.TYPE_FOR_MESSAGE_ACTION_ON, authorUUID, projectUUID, 
                Config.TYPE_FOR_MESSAGE_IN_PROJECT_TO_APPLY, userUUID)
    sqlList.append(updateMessageSQL)

    # 作者向申请者发送通知表示通过
    insertMessageSQL = """
        INSERT INTO t_message_project (user_uuid, type, content_uuid, owner_user_uuid,
            status, action, time) VALUES ('%s', %d, '%s', '%s', %d, %d, '%s');
    """ % (userUUID,  Config.TYPE_FOR_MESSAGE_IN_PROJECT_APPLY_AGREE, projectUUID,
            authorUUID, Config.TYPE_FOR_MESSAGE_UNREAD, Config.TYPE_FOR_MESSAGE_ACTION_OFF, 
            time)
    sqlList.append(insertMessageSQL)

    dbManager = DB.DBManager.shareInstanced()
    try:
        # 加入项目时查看作者是否与其已经交换联系方式了，没有就双双交换
        exchangeContactSQL = __exchangeContactSQLMethod(userUUID, projectUUID, authorUUID, time)
        if exchangeContactSQL != None: sqlList.append(exchangeContactSQL)

        dbManager.executeTransactionMutltiDml(sqlList)
    except Exception as e:
        Loger.error(e, __file__)
        return RESPONSE_JSON(CODE_ERROR_SERVICE)
    else:
        __notificationMember(userUUID, "同意加入项目")
        return RESPONSE_JSON(CODE_SUCCESS)


def __exchangeContactSQLMethod(userUUID, projectUUID, authorUUID, time):
    queryContactSQL = """
            SELECT user_uuid FROM t_user_user WHERE
            user_uuid='{authorUUID}' AND other_user_uuid='{userUUID}' AND type={typeStr} GROUP BY user_uuid
        """.format(authorUUID=authorUUID, typeStr=Config.TYPE_FOR_USER_CONTACT, 
                        userUUID=userUUID)

    dbManager = DB.DBManager.shareInstanced()
    try:
        result = dbManager.executeTransactionQuery(queryContactSQL)
        if len(result) == 0:
            insertContactSQL = """
                INSERT INTO t_user_user (user_uuid, type, other_user_uuid, time) 
                VALUES ('{userUUID}', {typeInt}, '{authorUUID}', '{time}'), 
                            ('{authorUUID}', {typeInt}, '{userUUID}', '{time}'); 
                """.format(userUUID=userUUID, typeInt=Config.TYPE_FOR_USER_CONTACT, authorUUID=authorUUID, time=time)
            return insertContactSQL
        else:
            return None
    except Exception as e:
        Loger.error(e, __file__)
        raise e


def __notificationMember(userUUID, content):
    notification.notificationUserForContent(userUUID, content)
    # dispatchNotificationUserForContent.delay(userUUID)


if __name__ == '__main__':
    pass
