#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# userAction.py
#
# Created by ruibin.chow on 2017/12/18.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""
关注与取消关注用户
"""

from service.quickTalk.star import star
from module.database import DB
from module.log.Log import Loger
from config import *
from common.code import *
from common.tools import getValueFromRequestByKey, generateUUID, generateCurrentTime


@star.route('/userAction', methods=["GET", "POST"])
def userAction():
    typeStr = getValueFromRequestByKey("type")
    userUUID = getValueFromRequestByKey("user_uuid")
    contentUUID = getValueFromRequestByKey("content_uuid")
    action = getValueFromRequestByKey("action")

    if action not in (Config.STAR_ACTION_FOR_STAR, Config.STAR_ACTION_FOR_UNSTAR):
        return RESPONSE_JSON(CODE_ERROR_PARAM)

    if typeStr != Config.TYPE_STAR_FOR_USER_RELATION:
        return RESPONSE_JSON(CODE_ERROR_PARAM)

    if userUUID == None or contentUUID == None:
        return RESPONSE_JSON(CODE_ERROR_MISS_PARAM)

    if action == Config.STAR_ACTION_FOR_STAR:
        return __starUserMethod(typeStr, userUUID, contentUUID)
    else:
        return __unStarUserMethod(typeStr, userUUID, contentUUID)


def __starUserMethod(typeStr, userUUID, contentUUID):
    if __queryWhetherStar(contentUUID, typeStr, userUUID):
        return RESPONSE_JSON(CODE_ERROR_ALREADY_STAR) 
    
    sqlList = []
    argsList = []
    time = generateCurrentTime()
    insertSQL = """
        INSERT INTO t_quickTalk_user_user (user_uuid, type, other_user_uuid, time) VALUES (%s, %s, %s, %s)
    """
    sqlList.append(insertSQL)
    argsList.append([userUUID, typeStr, contentUUID, time])

    messageSQL = """
        INSERT INTO t_quickTalk_message (user_uuid, type, content_uuid, time, 
            generated_user_uuid, status, content) VALUES (%s, %s, %s, %s, %s, %s, %s);
    """
    sqlList.append(messageSQL)
    argsList.append([contentUUID, Config.TYPE_MESSAGE_ADD_NEW_FRIEND, contentUUID, time, userUUID, str(Config.TYPE_MESSAGE_UNREAD), ""])
    
    dbManager = DB.DBManager.shareInstanced()
    try: 
        result = dbManager.executeTransactionMutltiDmlWithArgsList(sqlList, argsList)
    except Exception as e:
        Loger.error(e, __file__)
        return RESPONSE_JSON(CODE_ERROR_SERVICE)
    return RESPONSE_JSON(CODE_SUCCESS)
    

def __unStarUserMethod(typeStr, userUUID, contentUUID):
    sqlList = []
    argsList = []

    deleteSQL = """
        DELETE FROM t_quickTalk_user_user WHERE type=%s AND user_uuid=%s AND other_user_uuid=%s;"""
    sqlList.append(deleteSQL)
    argsList.append([typeStr, userUUID, contentUUID])

    deleteMessageSQL = """
        DELETE FROM t_quickTalk_message WHERE generated_user_uuid=%s AND type=%s AND user_uuid=%s;
    """
    sqlList.append(deleteMessageSQL)
    argsList.append([userUUID, Config.TYPE_MESSAGE_ADD_NEW_FRIEND, contentUUID])

    dbManager = DB.DBManager.shareInstanced()
    try: 
        result = dbManager.executeTransactionMutltiDmlWithArgsList(sqlList, argsList)
    except Exception as e:
        Loger.error(e, __file__)
        return RESPONSE_JSON(CODE_ERROR_SERVICE)
    return RESPONSE_JSON(CODE_SUCCESS)


def __queryWhetherStar(starUUID, typeStr, userUUID):
    querySQL = """SELECT user_uuid FROM t_quickTalk_user_user WHERE other_user_uuid='%s' AND type=%s AND user_uuid='%s'; """ % (starUUID, typeStr, userUUID)
    dbManager = DB.DBManager.shareInstanced()
    try:
        resultList = dbManager.executeSingleQuery(querySQL)
        if len(resultList) > 0: return True
    except Exception as e:
        Loger.error(e, __file__)
        return False




if __name__ == '__main__':
    pass
