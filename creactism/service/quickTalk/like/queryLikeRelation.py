#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# queryLikeRelation.py
#
# Created by ruibin.chow on 2017/12/20.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""
查询是否点赞系统
"""

from . import like
from module.database import DB
from module.log.Log import Loger
from config import *
from common.code import *
from common.tools import getValueFromRequestByKey
import json
from common.auth import vertifyTokenHandle


@like.route('/queryLikeRelation', methods=["GET", "POST"])
@vertifyTokenHandle
def queryLikeRelationRequest():
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
        dataList = queryLikeRelation(userUUID, uuidList)
        return RESPONSE_JSON(CODE_SUCCESS, data=dataList)
    except Exception as e:
        Loger.error(e, __file__)
        return RESPONSE_JSON(CODE_ERROR_SERVICE)


def queryLikeRelation(userUUID, uuidList):
    # print userUUID, uuidList
    dataList = []
    if len(uuidList) == 0 or userUUID == None:
        return dataList

    inString = "'" + "','".join(uuidList) + "'"
    querySQL = """
        SELECT user_uuid, type, content_uuid
        FROM t_quickTalk_like WHERE user_uuid='%s' AND content_uuid IN (%s) 
    """ % (userUUID, inString)

    # print querySQL

    dbManager = DB.DBManager.shareInstanced()
    try: 
        dataList = dbManager.executeSingleQuery(querySQL)
        dataList = __packageDataList(dataList)
        return dataList
    except Exception as e:
        Loger.error(e, __file__)
        raise e
    

def __packageDataList(dataList):
    array = []
    if len(dataList) == 0:
        return array
    for data in dataList:
        array.append(data["content_uuid"])
    return array
        

if __name__ == '__main__':
    pass
