#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# messageCount.py
#
# Created by ruibin.chow on 2017/12/19.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""
获得消息数量
"""

from service.quickTalk.message import message
from module.database import DB
from module.log.Log import Loger
from config import *
from common.code import *
from common.tools import getValueFromRequestByKey, parsePageIndex, limit, fullPathForMediasFile, userAvatarURL
from common.auth import vertifyTokenHandle


@message.route('/count', methods=["GET", "POST"])
@vertifyTokenHandle
def messageCount():
    userUUID = getValueFromRequestByKey("user_uuid")
    typeStr = getValueFromRequestByKey("type")

    # if typeStr not in (Config.TYPE_MESSAGE_LIKE_USERPOST, Config.TYPE_MESSAGE_USERPOST_COMMENT, Config.TYPE_MESSAGE_ADD_NEW_FRIEND):
    #     return RESPONSE_JSON(CODE_ERROR_PARAM)

    if typeStr == Config.TYPE_MESSAGE_LIKE_USERPOST:
        return __getCountFromStorage(userUUID, typeStr)
    elif typeStr == Config.TYPE_MESSAGE_USERPOST_COMMENT:
        return __getCountFromStorage(userUUID, typeStr)
    elif typeStr == Config.TYPE_MESSAGE_ADD_NEW_FRIEND:
        return __getCountFromStorage(userUUID, typeStr)
    else:
        return __getCountFromStorage(userUUID, None)


def __getCountFromStorage(userUUID, typeStr):
    querySQL = """
        SELECT COUNT(generated_user_uuid) AS count, %s AS type
        FROM t_quickTalk_message
        WHERE user_uuid='%s' AND type=%s AND status=%d;
    """ % (typeStr, userUUID, typeStr, 
            Config.TYPE_MESSAGE_UNREAD)
    if typeStr == None:
        querySQL = """
            SELECT COUNT(generated_user_uuid) AS count, -1 AS type
            FROM t_quickTalk_message
            WHERE user_uuid='%s' AND status=%d;
        """ % (userUUID, Config.TYPE_MESSAGE_UNREAD)
    # print querySQL

    dbManager = DB.DBManager.shareInstanced()
    try: 
        dataList = dbManager.executeSingleQuery(querySQL)
        data = {}
        if len(dataList) > 0:
            data = dataList[0]
        return RESPONSE_JSON(CODE_SUCCESS, data=data)
    except Exception as e:
        Loger.error(e, __file__)
        return RESPONSE_JSON(CODE_ERROR_SERVICE)
    


if __name__ == '__main__':
    pass
