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

from service.quickTalk import quickTalk
from module.database import DB
from module.log.Log import Loger
from config import *
from common.code import *
from common.tools import getValueFromRequestByKey, generateUUID, generateCurrentTime
import json


@quickTalk.route('/submitTopic', methods=["GET", "POST"])
def submitTopic():
    jsondata = getValueFromRequestByKey("jsondata")
     
    jsonList = None
    try:
        jsonList = json.loads(jsondata)
    except Exception as e:
        Loger.error(e, __file__)
        return RESPONSE_JSON(CODE_ERROR_ILLEGAL_DATA_CONTENT)

    return __storageTopic(jsonList)
    

def __storageTopic(jsonList):
    sqlList = []
    argsList = []
    for data in jsonList:
        uuid = generateUUID()
        time = generateCurrentTime()
        insertSQL = "INSERT INTO t_quickTalk_topic (uuid, title, detail, href, time) VALUES (%s, %s, %s, %s, %s)"
        args = [uuid, data["title"], data["detail"], data["href"], time]
        sqlList.append(insertSQL)
        argsList.append(args)
        
    dbManager = DB.DBManager.shareInstanced()
    try: 
        result = dbManager.executeTransactionMutltiDmlWithArgsList(sqlList, argsList)
    except Exception as e:
            Loger.error(e, __file__)
            return RESPONSE_JSON(CODE_ERROR_SERVICE)
    return RESPONSE_JSON(CODE_SUCCESS)
    


if __name__ == '__main__':
    pass
