#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# updateReadCount.py
#
# Created by ruibin.chow on 2017/12/04.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""
更新阅读数
"""

from . import quickTalk
from module.database import DB
from module.log.Log import Loger
from config import *
from common.code import *
from common.tools import getValueFromRequestByKey, generateUUID, generateCurrentTime


@quickTalk.route('/updateReadCount', methods=["GET", "POST"])
def updateReadCount():
    topicUUID = getValueFromRequestByKey("topic_uuid")

    if topicUUID == None:
        return RESPONSE_JSON(CODE_ERROR_MISS_PARAM)

    return __updateActionInStorage(topicUUID)
    

def __updateActionInStorage(topicUUID):
    updateSQL = """
        UPDATE t_quickTalk_topic SET `read_count`=`read_count`+1 WHERE uuid='%s';
    """ % topicUUID
            
    dbManager = DB.DBManager.shareInstanced()
    try: 
        dbManager.executeTransactionDml(updateSQL)
        return RESPONSE_JSON(CODE_SUCCESS)
    except Exception as e:
        Loger.error(e, __file__)
        return RESPONSE_JSON(CODE_ERROR_SERVICE)

