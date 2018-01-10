#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# topicList.py
#
# Created by ruibin.chow on 2017/08/23.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""
话题列表
"""

from . import quickTalk
from module.database import DB
from module.log.Log import Loger
from config import *
from common.code import *
from common.tools import getValueFromRequestByKey, parsePageIndex, limit


@quickTalk.route('/topicList', methods=["GET", "POST"])
def topicList():
    index = getValueFromRequestByKey("index")
    index = parsePageIndex(index)
    size = getValueFromRequestByKey("size")

    return __getTopicFromStorage(index, size)


def __getTopicFromStorage(index, size):
    limitSQL = limit(index)
    if size is not None: limitSQL = limit(index, int(size))
        
    querySQL = """
        SELECT id, uuid, title, detail, href, read_count AS readCount, time FROM t_quickTalk_topic ORDER BY time DESC %s
    """ % limitSQL

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
