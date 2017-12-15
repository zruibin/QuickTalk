#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# userList.py
#
# Created by ruibin.chow on 2017/12/15.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""
所有用户
"""

from service.quickTalk.account import account
from module.database import DB
from module.log.Log import Loger
from config import *
from common.code import *
from common.tools import getValueFromRequestByKey, parsePageIndex, limit, fullPathForMediasFile, userAvatarURL


@account.route('/userList', methods=["POST", "GET"])
def userList():
    manage = getValueFromRequestByKey("manage")
    index = getValueFromRequestByKey("index")
    index = parsePageIndex(index)
    size = getValueFromRequestByKey("size")

    if manage == None or manage != "manage":
        return RESPONSE_JSON(CODE_ERROR_PARAM)

    return __getUserListFromStorage(index, size)


def __getUserListFromStorage(index, size):
    limitSQL = limit(index)
    if size is not None: limitSQL = limit(index, int(size))
        
    querySQL = """
        SELECT id, uuid, nickname, phone, email, avatar, wechat, weibo, qq, time,
        gender, area, detail
        FROM t_quickTalk_user ORDER BY time DESC %s
    """ % limitSQL

    print querySQL 

    dbManager = DB.DBManager.shareInstanced()
    try: 
        dataList = dbManager.executeSingleQuery(querySQL)
        for data in dataList:
            userUUID = data["uuid"]
            data["time"] = str(data["time"])
            data["avatar"] = userAvatarURL(userUUID, data["avatar"])
        return RESPONSE_JSON(CODE_SUCCESS, dataList)
    except Exception as e:
        Loger.error(e, __file__)
        return RESPONSE_JSON(CODE_ERROR_SERVICE)


if __name__ == '__main__':
    pass
