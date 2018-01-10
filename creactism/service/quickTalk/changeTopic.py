#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# changeTopic.py
#
# Created by ruibin.chow on 2017/11/09.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""
修改话题
"""

from . import quickTalk
from module.database import DB
from module.log.Log import Loger
from config import *
from common.code import *
from common.tools import getValueFromRequestByKey, generateUUID, generateCurrentTime
import json


@quickTalk.route('/changeTopic', methods=["POST"])
def changeTopic():
    uuid = getValueFromRequestByKey("uuid")
    title = getValueFromRequestByKey("title")
    detail = getValueFromRequestByKey("detail")
    href = getValueFromRequestByKey("href")
    content = getValueFromRequestByKey("content")

    if uuid == None:
        return RESPONSE_JSON(CODE_ERROR_MISS_PARAM)

    return __changeTopicInStorage(uuid, title, detail, href, content)
    

def __changeTopicInStorage(uuid, title="", detail="", href="", content=""):
    sqlList = []
    argsList = []
    updateTopicSQL = """
        UPDATE t_quickTalk_topic SET title=%s, detail=%s, href=%s WHERE uuid=%s;
    """
    sqlList.append(updateTopicSQL)
    argsList.append([title, detail, href, uuid])
    updateContentSQL = """
        REPLACE INTO t_quickTalk_topic_content(uuid, content) values (%s, %s);
    """
    sqlList.append(updateContentSQL)
    argsList.append([uuid, content])
        
    dbManager = DB.DBManager.shareInstanced()
    try: 
        result = dbManager.executeTransactionMutltiDmlWithArgsList(sqlList, argsList)
    except Exception as e:
            Loger.error(e, __file__)
            return RESPONSE_JSON(CODE_ERROR_SERVICE)
    return RESPONSE_JSON(CODE_SUCCESS)
    



if __name__ == '__main__':
    pass
