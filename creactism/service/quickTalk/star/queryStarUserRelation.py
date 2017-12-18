#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# queryStarUserRelation.py
#
# Created by ruibin.chow on 2017/12/18.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""
查询相互关注系统
"""

from service.quickTalk.star import star
from module.database import DB
from module.log.Log import Loger
from config import *
from common.code import *
from common.tools import getValueFromRequestByKey
import json


@star.route('/queryStarUserRelation', methods=["GET", "POST"])
def queryStarUserRelationRequest():
    userUUID = getValueFromRequestByKey("user_uuid")
    uuidList = getValueFromRequestByKey("uuidList")

    if userUUID == None or uuidList == None:
        return RESPONSE_JSON(CODE_ERROR_MISS_PARAM)
    
    try:
        uuidList = json.loads(uuidList)
    except Exception as e:
        Loger.error(e, __file__)
        return RESPONSE_JSON(CODE_ERROR_ILLEGAL_DATA_CONTENT)

    try:
        dataDict = queryStarUserRelation(userUUID, uuidList)
        return RESPONSE_JSON(CODE_SUCCESS, data=dataDict)
    except Exception as e:
        Loger.error(e, __file__)
        return RESPONSE_JSON(CODE_ERROR_SERVICE)


def queryStarUserRelation(userUUID, uuidList):
    # print userUUID, uuidList
    dataDict = {}
    if len(uuidList) == 0:
        return dataDict

    inString = "'" + "','".join(uuidList) + "'"
    querySQL = """
        SELECT user_uuid, type, other_user_uuid
        FROM t_quickTalk_user_user WHERE user_uuid='%s' AND other_user_uuid IN (%s) 
    """ % (userUUID, inString)

    # print querySQL

    dbManager = DB.DBManager.shareInstanced()
    try: 
        dataList = dbManager.executeSingleQuery(querySQL)
        dataDict = __packageDataDict(dataList)
        return dataDict
    except Exception as e:
        Loger.error(e, __file__)
        raise e
    

def __packageDataDict(dataList):
    dataDict = {}
    if len(dataList) == 0:
        return dataDict
    for data in dataList:
        dataDict[data["other_user_uuid"]] = data["user_uuid"]
    return dataDict
        

if __name__ == '__main__':
    pass
