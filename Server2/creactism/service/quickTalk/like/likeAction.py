#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# likeAction.py
#
# Created by ruibin.chow on 2017/12/05.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""
点赞与取消点赞
"""

from . import like
from module.database import DB
from module.log.Log import Loger
from config import *
from common.code import *
from common.auth import vertifyTokenHandle
from common.tools import getValueFromRequestByKey, generateUUID, generateCurrentTime
from dispatch.notification import dispatchNotificationLikeForUserPost


@like.route('/like', methods=["GET", "POST"])
@vertifyTokenHandle
def likeAction():
    typeStr = getValueFromRequestByKey("type")
    userUUID = getValueFromRequestByKey("user_uuid")
    contentUUID = getValueFromRequestByKey("content_uuid")
    action = getValueFromRequestByKey("action")

    if typeStr not in (Config.LIKE_ACTION_AGREE, Config.LIKE_ACTION_DISAGREE):
        return RESPONSE_JSON(CODE_ERROR_PARAM)

    if typeStr not in (Config.TYPE_MESSAGE_LIKE_TOPIC, Config.TYPE_MESSAGE_LIKE_TOPIC_COMMENT, Config.TYPE_MESSAGE_LIKE_USERPOST, Config.TYPE_MESSAGE_LIKE_USERPOST_COMMENT):
        return RESPONSE_JSON(CODE_ERROR_PARAM)

    if typeStr != Config.TYPE_MESSAGE_LIKE_USERPOST:
        return RESPONSE_JSON(CODE_ERROR_PARAM)

    if userUUID == None or contentUUID == None:
        return RESPONSE_JSON(CODE_ERROR_MISS_PARAM)

    if action == Config.LIKE_ACTION_AGREE:
        return __likeUserPostMethod(typeStr, userUUID, contentUUID)
    else:
        return __disLikeUserPostMethod(typeStr, userUUID, contentUUID)


def __likeUserPostMethod(typeStr, userUUID, contentUUID):
    if __queryWhetherLike(contentUUID, typeStr, userUUID):
        return RESPONSE_JSON(CODE_ERROR_ALREADY_LIKE) 
    reciveUserUUID = __queryUserPostUserUUID(contentUUID)
    if reciveUserUUID == None:
        return RESPONSE_JSON(CODE_ERROR_CONTENT_IS_NULL) 
    
    sqlList = []
    argsList = []
    time = generateCurrentTime()
    insertSQL = """
        INSERT INTO t_quickTalk_like (type, user_uuid, content_uuid, time) VALUES (%s, %s, %s, %s)
    """
    sqlList.append(insertSQL)
    argsList.append([typeStr, userUUID, contentUUID, time])

    if reciveUserUUID != userUUID:
        messageSQL = """
        INSERT INTO t_quickTalk_message (user_uuid, type, content_uuid, time, 
            generated_user_uuid, status, content) VALUES (%s, %s, %s, %s, %s, %s, %s);
        """
        sqlList.append(messageSQL)
        argsList.append([reciveUserUUID, Config.TYPE_MESSAGE_LIKE_USERPOST, contentUUID, time, userUUID, str(Config.TYPE_MESSAGE_UNREAD), ""])
    
    dbManager = DB.DBManager.shareInstanced()
    try: 
        result = dbManager.executeTransactionMutltiDmlWithArgsList(sqlList, argsList)
        # 远程通知
        dispatchNotificationLikeForUserPost.delay(userUUID, reciveUserUUID)
    except Exception as e:
        Loger.error(e, __file__)
        return RESPONSE_JSON(CODE_ERROR_SERVICE)
    return RESPONSE_JSON(CODE_SUCCESS)
    

def __disLikeUserPostMethod(typeStr, userUUID, contentUUID):
    reciveUserUUID = __queryUserPostUserUUID(contentUUID)
    if reciveUserUUID == None:
        return RESPONSE_JSON(CODE_ERROR_CONTENT_IS_NULL) 
    sqlList = []
    argsList = []

    deleteSQL = """
        DELETE FROM t_quickTalk_like WHERE type=%s AND user_uuid=%s AND content_uuid=%s;"""
    sqlList.append(deleteSQL)
    argsList.append([typeStr, userUUID, contentUUID])

    deleteMessageSQL = """
        DELETE FROM t_quickTalk_message WHERE content_uuid=%s AND type=%s AND user_uuid=%s;
    """
    sqlList.append(deleteMessageSQL)
    argsList.append([contentUUID, Config.TYPE_MESSAGE_LIKE_USERPOST, reciveUserUUID])

    dbManager = DB.DBManager.shareInstanced()
    try: 
        result = dbManager.executeTransactionMutltiDmlWithArgsList(sqlList, argsList)
    except Exception as e:
        Loger.error(e, __file__)
        return RESPONSE_JSON(CODE_ERROR_SERVICE)
    return RESPONSE_JSON(CODE_SUCCESS)


def __queryWhetherLike(likeUUID, typeStr, userUUID):
    querySQL = """SELECT user_uuid FROM t_quickTalk_like WHERE content_uuid='%s' AND type=%s AND user_uuid='%s'; """ % (likeUUID, typeStr, userUUID)
    dbManager = DB.DBManager.shareInstanced()
    try:
        resultList = dbManager.executeSingleQuery(querySQL)
        if len(resultList) > 0: return True
    except Exception as e:
        Loger.error(e, __file__)
        return False


def __queryUserPostUserUUID(userPostUUID):
    querySQL = """SELECT user_uuid FROM t_quickTalk_userPost WHERE uuid='%s';""" % (userPostUUID)
    dbManager = DB.DBManager.shareInstanced()
    try:
        resultList = dbManager.executeSingleQuery(querySQL)
        if len(resultList) > 0: 
            return resultList[0]["user_uuid"]
        else:
            return None
    except Exception as e:
        Loger.error(e, __file__)
        return None


if __name__ == '__main__':
    pass
