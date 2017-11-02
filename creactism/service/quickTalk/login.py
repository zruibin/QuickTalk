#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# login.py
#
# Created by ruibin.chow on 2017/10/12.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""
登录
"""

from service.quickTalk import quickTalk
from module.database import DB
from module.log.Log import Loger
from config import *
from common.code import *
from common.tools import getValueFromRequestByKey, generateUUID, generateCurrentTime, fullPathForMediasFile, userAvatarURL



@quickTalk.route('/login', methods=["GET", "POST"])
def loginWithAvatar():
    openId = getValueFromRequestByKey("openId")
    avatar = getValueFromRequestByKey("avatar")
    typeStr = getValueFromRequestByKey("type")
    nickname = getValueFromRequestByKey("nickname")

    if openId == None or typeStr == None:
        return RESPONSE_JSON(CODE_ERROR_MISS_PARAM)

    return __loginAction(openId, typeStr, avatar, nickname)


def __loginAction(openId, typeStr, avatar, nickname):
    typeData = __typeData(typeStr)

    querySQL = """
        SELECT id, uuid, avatar, nickname FROM t_quickTalk_user WHERE %s='%s'; 
    """ % (typeData, openId)

    dbManager = DB.DBManager.shareInstanced()
    try: 
        result = dbManager.executeSingleQuery(querySQL)
        if len(result) > 0:
            data = result[0]
            uuid = data["uuid"]
            avatar = data["avatar"]
            data["avatar"] = userAvatarURL(uuid, avatar)
            return RESPONSE_JSON(CODE_SUCCESS, data)
        else:
            return __registerUser(openId, typeStr, avatar, nickname)
    except Exception as e:
        Loger.error(e, __file__)
        return RESPONSE_JSON(CODE_ERROR_SERVICE)


def __registerUser(openId, typeStr, avatar, nickname):
    uuid = generateUUID()
    time = generateCurrentTime()

    typeData = __typeData(typeStr)

    insertSQL = """
        INSERT INTO t_quickTalk_user (uuid, nickname, avatar, time, %s) VALUES ('%s','%s', '%s', '%s', '%s')
    """ % (typeData, uuid, nickname, avatar, time, openId)

    dbManager = DB.DBManager.shareInstanced()
    try:
        result = dbManager.executeTransactionDml(insertSQL)
        if result:
            data = {}
            data["uuid"] = uuid
            data["avatar"] = userAvatarURL(uuid, avatar)
            data["nickname"] = nickname
            return RESPONSE_JSON(CODE_SUCCESS, data)
        else:
            return RESPONSE_JSON(CODE_ERROR_SERVICE)
    except Exception as e:
        Loger.error(e, __file__)
        return RESPONSE_JSON(CODE_ERROR_SERVICE)


def __typeData(typeStr):
    typeDict = {
        Config.TYPE_FOR_AUTH_WECHAT : "wechat",
        Config.TYPE_FOR_AUTH_QQ : "qq",
        Config.TYPE_FOR_AUTH_WEIBO : "weibo",
    }
    return typeDict[typeStr]


if __name__ == '__main__':
    pass
