#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# topic.py
#
# Created by ruibin.chow on 2017/11/08.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""
单个话题
"""

from . import news
from module.database import DB
from module.log.Log import Loger
from config import *
from common.code import *
from common.tools import getValueFromRequestByKey, parsePageIndex, limit


@news.route('/topic', methods=["GET", "POST"])
def topic():
    topicUUID = getValueFromRequestByKey("topic_uuid")
    if topicUUID == None:
        return RESPONSE_JSON(CODE_ERROR_MISS_PARAM) 

    return __getTopicFromStorage(topicUUID)


def __getTopicFromStorage(topicUUID):
    
    querySQL = """
        SELECT id, uuid, title, detail, href, time FROM t_quickTalk_topic WHERE  uuid='%s';
    """ % topicUUID

    dbManager = DB.DBManager.shareInstanced()
    try: 
        dataList = dbManager.executeSingleQuery(querySQL)
        for data in dataList:
            data["time"] = str(data["time"])
        return RESPONSE_JSON(CODE_SUCCESS, dataList)
    except Exception as e:
        Loger.error(e, __file__)
        return RESPONSE_JSON(CODE_ERROR_SERVICE)
    


if __name__ == '__main__':
    pass
