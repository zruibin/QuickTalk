#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# queryLike.py
#
# Created by ruibin.chow on 2017/08/23.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""
查看是否点赞了

TYPE_FOR_LIKE_IN_PROJECT = "1" # 项目
TYPE_FOR_LIKE_IN_COMMENT = "2" # 评论
TYPE_FOR_LIKE_IN_JOURNAL = "3" # 日志
"""

from service.like import like
from module.database import DB
from module.log.Log import Loger
from config import *
from common.code import *
from common.auth import vertifyTokenHandle
from common.tools import getValueFromRequestByKey
import json


@like.route('/query_like', methods=["GET", "POST"])
@vertifyTokenHandle
def queryLike():
    userUUID = getValueFromRequestByKey("user_uuid")
    typeStr = getValueFromRequestByKey("type")
    likeUUIDListStr = getValueFromRequestByKey("like_uuid_list")

    if likeUUIDListStr == None or typeStr == None: 
        return RESPONSE_JSON(CODE_ERROR_SERVICE)

    likeUUIDList = None
    try:
        likeUUIDList = json.loads(likeUUIDListStr)
    except Exception as e:
        Loger.error(e, __file__)
        return RESPONSE_JSON(CODE_ERROR_ILLEGAL_CREATE_PROJECT_JSON_CONTENT)

    return __queryLikeInStorage(userUUID, typeStr, likeUUIDList)

def __queryLikeInStorage(userUUID, typeStr, likeUUIDList):
    inString = "'" + "','".join(likeUUIDList) + "'"
    # print inString

    querySQL = """
        SELECT content_uuid FROM t_like WHERE user_uuid='%s' AND type=%s AND content_uuid IN (%s)
    """ % (userUUID, typeStr, inString)

    dbManager = DB.DBManager.shareInstanced()
    try:
        resultList = dbManager.executeSingleQuery(querySQL, False)
        packageDict = __packageData(likeUUIDList, resultList)
        return RESPONSE_JSON(CODE_SUCCESS, packageDict) 
    except Exception as e:
        Loger.error(e, __file__)
        return RESPONSE_JSON(CODE_ERROR_SERVICE)
    

def __packageData(likeUUIDList, resultList):
    tempList = []
    for data in resultList:
        tempList.append(data[0])
    
    dataDict = {}
    for uuid in likeUUIDList:
        if uuid in tempList:
            dataDict[uuid] = 1
        else:
            dataDict[uuid] = 0
    return dataDict



if __name__ == '__main__':
    pass
