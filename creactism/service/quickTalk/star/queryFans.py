#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# queryFans.py
#
# Created by ruibin.chow on 2017/12/18.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""
查看粉丝
"""

from service.quickTalk.star import star
from module.database import DB
from module.log.Log import Loger
from config import *
from common.code import *
from common.tools import getValueFromRequestByKey, parsePageIndex, limit, fullPathForMediasFile, userAvatarURL
from service.quickTalk.star.queryStarUserRelation import queryStarUserRelation
from common.auth import vertifyTokenHandle


@star.route('/queryFans', methods=["GET", "POST"])
@vertifyTokenHandle
def queryFans():
    userUUID = getValueFromRequestByKey("user_uuid")
    relationUserUUID = getValueFromRequestByKey("relation_user_uuid")
    index = getValueFromRequestByKey("index")
    index = parsePageIndex(index)
    size = getValueFromRequestByKey("size")
    
    if userUUID == None:
        return RESPONSE_JSON(CODE_ERROR_MISS_PARAM)

    return __getFansFromStorage(index, size, userUUID, relationUserUUID)


def __getFansFromStorage(index, size, userUUID, relationUserUUID):
    limitSQL = limit(index)
    if size is not None: limitSQL = limit(index, int(size))
        
    querySQL = """
            SELECT user_uuid, type, other_user_uuid FROM t_quickTalk_user_user WHERE other_user_uuid='%s' ORDER BY time DESC %s
        """ % (userUUID, limitSQL)

    # print querySQL 

    dbManager = DB.DBManager.shareInstanced()
    try: 
        dataList = dbManager.executeSingleQuery(querySQL)
        dataList = __packageUserData(dataList, userUUID, relationUserUUID)
        return RESPONSE_JSON(CODE_SUCCESS, data=dataList)
    except Exception as e:
        Loger.error(e, __file__)
        return RESPONSE_JSON(CODE_ERROR_SERVICE)


def __packageUserData(dataList, userUUID, relationUserUUID):
    if len(dataList) == 0:
        return dataList

    uuidList = []
    for data in dataList:
        uuidList.append(data["user_uuid"])

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
        
        fansUUIDList = []
        for data in dataList:
            fansUUIDList.append(data["uuid"])
        dataDict = queryStarUserRelation(relationUserUUID, fansUUIDList)
        # print dataDict
        
        for data in dataList:
            uuid = data["uuid"]
            fansUUIDList.append(uuid)
            data["time"] = str(data["time"])
            data["avatar"] = userAvatarURL(uuid, data["avatar"])
            if dataDict.has_key(uuid):
                data["relation"] = 1
            else:
                data["relation"] = 0
        return dataList
    except Exception as e:
        Loger.error(e, __file__)
        raise e


    


if __name__ == '__main__':
    pass
