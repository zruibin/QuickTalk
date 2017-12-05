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

from service.quickTalk.like import like
from module.database import DB
from module.log.Log import Loger
from config import *
from common.code import *
from common.tools import getValueFromRequestByKey, generateUUID, generateCurrentTime


@like.route('/like', methods=["GET", "POST"])
def likeAction():
    typeStr = getValueFromRequestByKey("type")
    userUUID = getValueFromRequestByKey("user_uuid")
    contentUUID = getValueFromRequestByKey("content_uuid")
    action = getValueFromRequestByKey("action")

    if action not in (Config.LIKE_ACTION_AGREE, Config.LIKE_ACTION_DISAGREE):
        return RESPONSE_JSON(CODE_ERROR_PARAM)

    if action not in (Config.TYPE_LIKE_TOPIC, Config.TYPE_LIKE_TOPIC_COMMENT, Config.TYPE_LIKE_USERPOST, Config.TYPE_LIKE_USERPOST_COMMENT):
        return RESPONSE_JSON(CODE_ERROR_PARAM)

    if userUUID == None or contentUUID == None:
        return RESPONSE_JSON(CODE_ERROR_MISS_PARAM)

    if action == Config.LIKE_ACTION_AGREE:
        return __likeMethod(typeStr, userUUID, contentUUID)
    else:
        return __disLikeMethod(typeStr, userUUID, contentUUID)


def __likeMethod(typeStr, userUUID, contentUUID):
    time = generateCurrentTime()
    insertSQL = """
        INSERT INTO t_quickTalk_like (type, user_uuid, content_uuid, time) VALUES (%s, %s, %s, %s)
    """
    args = [typeStr, userUUID, contentUUID, time]
    
    dbManager = DB.DBManager.shareInstanced()
    try: 
        result = dbManager.executeTransactionDmlWithArgs(insertSQL, args)
    except Exception as e:
        Loger.error(e, __file__)
        return RESPONSE_JSON(CODE_ERROR_SERVICE)
    return RESPONSE_JSON(CODE_SUCCESS)
    

def __disLikeMethod(typeStr, userUUID, contentUUID):
    deleteSQL = """
        DELETE FROM t_quickTalk_like WHERE type='%s' AND user_uuid='%s' AND content_uuid='%s';
    """ % (typeStr, userUUID, contentUUID)

    dbManager = DB.DBManager.shareInstanced()
    try: 
        result = dbManager.executeTransactionDml(deleteSQL)
    except Exception as e:
        Loger.error(e, __file__)
        return RESPONSE_JSON(CODE_ERROR_SERVICE)
    return RESPONSE_JSON(CODE_SUCCESS)



if __name__ == '__main__':
    pass
