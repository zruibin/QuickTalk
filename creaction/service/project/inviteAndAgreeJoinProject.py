#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# inviteAndAgreeJoinProject.py
#
# Created by ruibin.chow on 2017/08/21.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""
成员邀请(包含作者)与成员同意加入
"""

from service.project import project
from module.database import DB
from module.log.Log import Loger
from config import *
from common.code import *
from common.auth import vertifyTokenHandle
from common.tools import getValueFromRequestByKey, generateUUID
from common.commonMethods import queryProjectString, MemberQueryException
import common.notification as notification
# from dispatch.tasks import dispatchNotificationUserForContent


@project.route('/project_invite_and_agree', methods=["GET", "POST"])
@vertifyTokenHandle
def inviteAndAgreeJoinIntoProject():
    userUUID = getValueFromRequestByKey("user_uuid")
    projectUUID = getValueFromRequestByKey("project_uuid")
    memberUUID = getValueFromRequestByKey("member_uuid") 
    typeStr = int(getValueFromRequestByKey("type"))

    if typeStr == Config.TYPE_FOR_MESSAGE_IN_PROJECT_FOR_INVITE:
        return invitePeopleIntoProject(userUUID, projectUUID, memberUUID)
    elif typeStr == Config.TYPE_FOR_MESSAGE_IN_PROJECT_INVITE_AGREE:
        return agreeIntoProject(userUUID, projectUUID)
    else:
        return RESPONSE_JSON(CODE_ERROR_MISS_PARAM)
        

def invitePeopleIntoProject(userUUID, projectUUID, memberUUID):
    if userUUID == None or projectUUID==None or memberUUID==None:
        return RESPONSE_JSON(CODE_ERROR_MISS_PARAM) 

    insertMessageSQL = """
        INSERT INTO t_message_project (user_uuid, type, content_uuid, owner_user_uuid,
            status, action) VALUES ('%s', %d, '%s', '%s', %d, %d);
    """ % (memberUUID,  Config.TYPE_FOR_MESSAGE_IN_PROJECT_FOR_INVITE, projectUUID,
            userUUID, Config.TYPE_FOR_MESSAGE_UNREAD, Config.TYPE_FOR_MESSAGE_ACTION_OFF)

    dbManager = DB.DBManager.shareInstanced()
    try:
        dbManager.executeTransactionDml(insertMessageSQL)
    except Exception as e:
        Loger.error(e, __file__)
        return RESPONSE_JSON(CODE_ERROR_SERVICE)
    else:
        __notificationMember(memberUUID)
        return RESPONSE_JSON(CODE_SUCCESS)

    return RESPONSE_JSON(CODE_SUCCESS)
    

def agreeIntoProject(userUUID, projectUUID):
    if userUUID == None or projectUUID==None:
        return RESPONSE_JSON(CODE_ERROR_MISS_PARAM) 
    
    sqlList = []

    # 成为项目成员同时关注该项目
    insertProjectUserSQL = """
        INSERT INTO t_project_user (project_uuid, type, user_uuid) 
        VALUES ('{projectUUID}', {memberType}, '{userUUID}'), 
            ('{projectUUID}', {followType}, '{userUUID}');
    """.format(projectUUID=projectUUID, userUUID=userUUID, 
                memberType=Config.TYPE_FOR_PROJECT_MEMBER, 
                followType=Config.TYPE_FOR_PROJECT_FOLLOWER)
    sqlList.append(insertProjectUserSQL)

    # 消息中action状态改为已执行即on 
    updateMessageSQL = """
        UPDATE t_message_project SET action=%d 
        WHERE user_uuid='%s' AND content_uuid='%s' AND type=%d;
    """ % (Config.TYPE_FOR_MESSAGE_ACTION_ON, userUUID, projectUUID, 
                Config.TYPE_FOR_MESSAGE_IN_PROJECT_FOR_INVITE)
    sqlList.append(updateMessageSQL)

    dbManager = DB.DBManager.shareInstanced()
    try:
        # 加入项目时查看跟作者是否已经交换联系方式了，没有就双双交换
        exchangeContactSQL = exchangeContactSQLMethod(userUUID, projectUUID)
        if exchangeContactSQL != None: sqlList.append(exchangeContactSQL)

        dbManager.executeTransactionMutltiDml(sqlList)
    except Exception as e:
        Loger.error(e, __file__)
        return RESPONSE_JSON(CODE_ERROR_SERVICE)
    else:
        return RESPONSE_JSON(CODE_SUCCESS)


def __notificationMember(userUUID):
    content = "邀请你加入项目"
    notification.notificationUserForContent(userUUID, content)
    # dispatchNotificationUserForContent.delay(userUUID)


def exchangeContactSQLMethod(userUUID, projectUUID):
    queryAuthorSQL = """SELECT author_uuid FROM t_project WHERE uuid='%s';""" % projectUUID
    dbManager = DB.DBManager.shareInstanced()
    try:
        result = dbManager.executeTransactionQuery(queryAuthorSQL)
        authorUUID = result[0]["author_uuid"]

        queryContactSQL = """
            SELECT user_uuid FROM t_user_user WHERE
            user_uuid='{authorUUID}' AND other_user_uuid='{userUUID}' AND type={typeStr} GROUP BY user_uuid
        """.format(authorUUID=authorUUID, typeStr=Config.TYPE_FOR_USER_CONTACT, 
                        userUUID=userUUID)
        result = dbManager.executeTransactionQuery(queryContactSQL)
        if len(result) == 0:
            insertContactSQL = """INSERT INTO t_user_user (user_uuid, type, other_user_uuid) 
                VALUES ('{userUUID}', {typeInt}, '{authorUUID}'), ('{authorUUID}', {typeInt},
                '{userUUID}'); """.format(userUUID=userUUID, 
                typeInt=Config.TYPE_FOR_USER_CONTACT, authorUUID=authorUUID)
            return insertContactSQL
        else:
            return None
    except Exception as e:
        Loger.error(e, __file__)
        raise e



if __name__ == '__main__':
    pass
