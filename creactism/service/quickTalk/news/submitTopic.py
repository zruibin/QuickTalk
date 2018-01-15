#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# submitTopic.py
#
# Created by ruibin.chow on 2017/10/11.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""

"""

from . import news
from module.database import DB
from module.log.Log import Loger
from config import *
from common.code import *
from common.tools import getValueFromRequestByKey, generateUUID, generateCurrentTime
import json


@news.route('/submitTopic', methods=["GET", "POST"])
def submitTopic():

    title = getValueFromRequestByKey("title")
    detail = getValueFromRequestByKey("detail")
    href = getValueFromRequestByKey("href")
    content = getValueFromRequestByKey("content")

    if title == None or detail == None or href == None or content == None:
        return RESPONSE_JSON(CODE_ERROR_MISS_PARAM)

    return __storageTopic(title, detail, href, content)
    

def __storageTopic(title="", detail="", href="", content=""):
    sqlList = []
    argsList = []

    uuid = generateUUID()
    time = generateCurrentTime()
    insertSQL = "INSERT INTO t_quickTalk_topic (uuid, title, detail, href, time) VALUES (%s, %s, %s, %s, %s)"
    args = [uuid, title, detail, href, time]
    sqlList.append(insertSQL)
    argsList.append(args)
    insertContentSQL = """INSERT INTO t_quickTalk_topic_content (uuid, content) VALUES (%s, %s)"""
    contentArgs = [uuid, content]
    sqlList.append(insertContentSQL)
    argsList.append(contentArgs)
        
        
    dbManager = DB.DBManager.shareInstanced()
    try: 
        result = dbManager.executeTransactionMutltiDmlWithArgsList(sqlList, argsList)
    except Exception as e:
            Loger.error(e, __file__)
            return RESPONSE_JSON(CODE_ERROR_SERVICE)
    return RESPONSE_JSON(CODE_SUCCESS)
    


if __name__ == '__main__':
    pass
