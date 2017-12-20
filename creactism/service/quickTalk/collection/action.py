#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# action.py
#
# Created by ruibin.chow on 2017/12/15.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""
收藏与取消收藏
"""

from service.quickTalk.collection import collection
from module.database import DB
from module.log.Log import Loger
from config import *
from common.code import *
from common.auth import vertifyTokenHandle
from common.tools import getValueFromRequestByKey, md5hex, generateCurrentTime


@collection.route('/action', methods=["POST", "GET"])
# @vertifyTokenHandle
def action():
    userUUID = getValueFromRequestByKey("user_uuid")
    typeStr = getValueFromRequestByKey("type")
    contentUUID = getValueFromRequestByKey("content_uuid")
    action = getValueFromRequestByKey("action")
    
    if userUUID == None or typeStr == None or contentUUID == None:
        return RESPONSE_JSON(CODE_ERROR_MISS_PARAM)

    if action not in (Config.COLLECTION_ACTION_ON, Config.COLLECTION_ACTION_OFF):
        return RESPONSE_JSON(CODE_ERROR_PARAM)

    if action == Config.COLLECTION_ACTION_ON:
        return __onAction(userUUID, contentUUID, typeStr)
    else:
        return __offAction(userUUID, contentUUID, typeStr)


def __onAction(userUUID, contentUUID, typeStr):
    if __queryWhetherCollection(contentUUID, typeStr, userUUID):
        return RESPONSE_JSON(CODE_ERROR_ALREADY_COLLECTION) 
    time = generateCurrentTime()
    insertSQL = """
        INSERT INTO t_quickTalk_collection (user_uuid, type, content_uuid, time) VALUES (%s, %s, %s, %s);
    """
    dbManager = DB.DBManager.shareInstanced()
    try: 
        action = dbManager.executeTransactionDmlWithArgs(insertSQL, [userUUID, typeStr, contentUUID, time])
        if action:
            return RESPONSE_JSON(CODE_SUCCESS)
        else:
            return RESPONSE_JSON(CODE_ERROR_SERVICE)
    except Exception as e:
        Loger.error(e, __file__)
        return RESPONSE_JSON(CODE_ERROR_SERVICE)


def __offAction(userUUID, contentUUID, typeStr):
    deleteSQL = """
        DELETE FROM t_quickTalk_collection WHERE user_uuid=%s 
        AND type=%s AND content_uuid=%s;
    """
    dbManager = DB.DBManager.shareInstanced()
    try: 
        action = dbManager.executeTransactionDmlWithArgs(deleteSQL, [userUUID, typeStr, contentUUID])
        if action:
            return RESPONSE_JSON(CODE_SUCCESS)
        else:
            return RESPONSE_JSON(CODE_ERROR_SERVICE)
    except Exception as e:
        Loger.error(e, __file__)
        return RESPONSE_JSON(CODE_ERROR_SERVICE)


def __queryWhetherCollection(collectionUUID, typeStr, userUUID):
    querySQL = """SELECT user_uuid FROM t_quickTalk_collection WHERE content_uuid='%s' AND type=%s AND user_uuid='%s'; """ % (collectionUUID, typeStr, userUUID)
    dbManager = DB.DBManager.shareInstanced()
    try:
        resultList = dbManager.executeSingleQuery(querySQL)
        if len(resultList) > 0: return True
    except Exception as e:
        Loger.error(e, __file__)
        return False
    



if __name__ == '__main__':
    pass
