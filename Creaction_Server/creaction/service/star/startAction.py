#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# startAction.py
#
# Created by ruibin.chow on 2017/08/15.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""
项目与人的关注跟取消关注
"""

from service.star import star
from module.database import DB
from module.log.Log import Loger
from config import *
from common.code import *
from common.auth import vertifyTokenHandle
from common.tools import getValueFromRequestByKey, fullPathForMediasFile, generateCurrentTime
from common.commonMethods import verifyUserIsExists
import common.notification as notification
# from dispatch.tasks import dispatchNotificationUserForContent


@star.route('/star_action', methods=["GET", "POST"])
@vertifyTokenHandle
def startAction():
    userUUID = getValueFromRequestByKey("user_uuid")
    action = getValueFromRequestByKey("action")
    otherUUID = getValueFromRequestByKey("other_uuid")
    typeStr = getValueFromRequestByKey("type")
    nickname = getValueFromRequestByKey("nickname")

    if action == None or typeStr == None or otherUUID == None:
        return RESPONSE_JSON(CODE_ERROR_MISS_PARAM)

    if typeStr == Config.TYPE_FOR_START_PROJECT: # 关注或取消关注项目
        return __startOrUnStartProject(userUUID, otherUUID, action)
    elif typeStr == Config.TYPE_FOR_START_USER: # 关注或取消关注用户
        if nickname == None: return RESPONSE_JSON(CODE_ERROR_MISS_PARAM)
        return __startOrUnStartUser(userUUID, otherUUID, action, nickname)
    else:
        return RESPONSE_JSON(CODE_ERROR_PARAM)


def __startOrUnStartProject(userUUID, otherUUID, action):
    time = generateCurrentTime()
    querySQL = """
        SELECT user_uuid FROM t_project_user WHERE project_uuid='%s' AND user_uuid='%s' AND type=%s; """ % (otherUUID, userUUID, Config.TYPE_FOR_PROJECT_FOLLOWER)
    insertSQL = """
        INSERT INTO t_project_user (project_uuid, type, user_uuid, time) 
        VALUES ('%s', %s, '%s', '%s'); """ % (otherUUID, Config.TYPE_FOR_USER_CONTACT, 
        userUUID, time)

    deleteSQL = """
        DELETE FROM t_project_user WHERE project_uuid='%s' AND user_uuid='%s' AND type=%s; """ % (otherUUID, userUUID, Config.TYPE_FOR_PROJECT_FOLLOWER)

    dbManager = DB.DBManager.shareInstanced()
    try:
        if action == Config.TYPE_FOR_START_ACTION_STARTING:
            rows = dbManager.executeSingleQuery(querySQL)
            if len(rows) > 0: raise Exception()
            dbManager.executeTransactionDml(insertSQL)
        if action == Config.TYPE_FOR_START_ACTION_UNSTART:
            dbManager.executeTransactionDml(deleteSQL)
    except Exception as e:
        Loger.error(e, __file__)
        return RESPONSE_JSON(CODE_ERROR_SERVICE)
    else:
        return RESPONSE_JSON(CODE_SUCCESS) 


def __startOrUnStartUser(userUUID, otherUUID, action, nickname): 
    time = generateCurrentTime()
    dbManager = DB.DBManager.shareInstanced()
    try:
        if action == Config.TYPE_FOR_START_ACTION_STARTING:
            querySQL = """
                    SELECT user_uuid FROM t_user_user WHERE user_uuid='%s' AND other_user_uuid='%s' AND type=%s; """ % (userUUID, otherUUID, Config.TYPE_FOR_USER_FOLLOWING)
            # 插入关注关系
            content = nickname + "关注了你"
            insertRelationSQL = """
                INSERT INTO t_user_user (user_uuid, type, other_user_uuid) VALUES ('%s', %s, '%s'); """ % (userUUID, Config.TYPE_FOR_USER_FOLLOWING, otherUUID)
            # 插入关注消息
            insertMessageSQL = """INSERT INTO t_message_start (user_uuid, type, content_uuid, owner_user_uuid, status, content, time) 
            VALUES ('%s', %s, '%s', '%s', %d, '%s', '%s'); """ % (otherUUID, Config.TYPE_FOR_START_USER, userUUID, userUUID, 
            Config.TYPE_FOR_MESSAGE_UNREAD, content, time)

            rows = dbManager.executeSingleQuery(querySQL)
            if len(rows) > 0: raise Exception()
            dbManager.executeTransactionMutltiDml([insertRelationSQL, insertMessageSQL])
            # 发送通知
            notification.notificationUserForContent(otherUUID, content)
            # dispatchNotificationUserForContent.delay(otherUUID, content)

        if action == Config.TYPE_FOR_START_ACTION_UNSTART:
            # 删除关系
            deleteSQL = """
                DELETE FROM t_user_user WHERE user_uuid='%s' AND other_user_uuid='%s' AND type=%s; """ % (userUUID, otherUUID, Config.TYPE_FOR_USER_FOLLOWING)
            # 删除关注消息(无论已读或读)
            deleteMessageSQL = """DELETE FROM t_message_start WHERE user_uuid='%s' AND type=%s AND content_uuid='%s' AND owner_user_uuid='%s';""" % (otherUUID, Config.TYPE_FOR_START_USER, userUUID, userUUID)
            dbManager.executeTransactionMutltiDml([deleteSQL, deleteMessageSQL])
    except Exception as e:
        Loger.error(e, __file__)
        return RESPONSE_JSON(CODE_ERROR_SERVICE)
    else:
        return RESPONSE_JSON(CODE_SUCCESS) 


if __name__ == '__main__':
    pass
