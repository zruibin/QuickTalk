#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# queryStarUser.py
#
# Created by ruibin.chow on 2017/12/18.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""
查询用户的关注用户
"""

from service.quickTalk.star import star
from module.database import DB
from module.log.Log import Loger
from config import *
from common.code import *
from common.tools import getValueFromRequestByKey, parsePageIndex, limit, fullPathForMediasFile, userAvatarURL


@star.route('/queryStarUser', methods=["GET", "POST"])
def queryStarUser():
    userUUID = getValueFromRequestByKey("user_uuid")
    index = getValueFromRequestByKey("index")
    index = parsePageIndex(index)
    size = getValueFromRequestByKey("size")

    if userUUID == None:
        return RESPONSE_JSON(CODE_ERROR_MISS_PARAM)

    return __getUserStarFromStorage(index, size, userUUID)


def __getUserStarFromStorage(index, size, userUUID):
    limitSQL = limit(index)
    if size is not None: limitSQL = limit(index, int(size))
        
    querySQL = """
            SELECT user_uuid, type, other_user_uuid FROM t_quickTalk_user_user WHERE user_uuid='%s' ORDER BY time DESC %s
        """ % (userUUID, limitSQL)

    # print querySQL 

    dbManager = DB.DBManager.shareInstanced()
    try: 
        dataList = dbManager.executeSingleQuery(querySQL)
        dataList = __packageUserData(dataList)
        return RESPONSE_JSON(CODE_SUCCESS, data=dataList)
    except Exception as e:
        Loger.error(e, __file__)
        return RESPONSE_JSON(CODE_ERROR_SERVICE)


def __packageUserData(dataList):
    if len(dataList) == 0:
        return dataList

    uuidList = []
    for data in dataList:
        uuidList.append(data["other_user_uuid"])

    inString = "'" + "','".join(uuidList) + "'"
    querySQL = """
        SELECT uuid, t_quickTalk_user.id, nickname, avatar, phone, email, detail,   
            gender, qq, weibo, wechat, area, time
        FROM t_quickTalk_user WHERE uuid IN (%s) 
            ORDER BY INSTR('%s', uuid);
    """ % (inString, ",".join(uuidList))

    # print querySQL

    dbManager = DB.DBManager.shareInstanced()
    try: 
        dataList = dbManager.executeSingleQuery(querySQL)
        for data in dataList:
            userUUID = data["uuid"]
            data["time"] = str(data["time"])
            data["avatar"] = userAvatarURL(userUUID, data["avatar"])
        return dataList
    except Exception as e:
        Loger.error(e, __file__)
        raise e


if __name__ == '__main__':
    pass
