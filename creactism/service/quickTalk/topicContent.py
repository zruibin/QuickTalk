#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# topicContent.py
#
# Created by ruibin.chow on 2017/11/09.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""
单个话题内容
"""

from service.quickTalk import quickTalk
from module.database import DB
from module.log.Log import Loger
from config import *
from common.code import *
from common.tools import getValueFromRequestByKey, parsePageIndex, limit


@quickTalk.route('/topicContent', methods=["GET", "POST"])
def topicContent():
    topicUUID = getValueFromRequestByKey("topic_uuid")
    if topicUUID == None:
        return RESPONSE_JSON(CODE_ERROR_MISS_PARAM) 

    return __getTopicContentFromStorage(topicUUID)


def __getTopicContentFromStorage(topicUUID):
    
    querySQL = """
        SELECT content FROM t_quickTalk_topic_content WHERE  uuid='%s';
    """ % topicUUID

    dbManager = DB.DBManager.shareInstanced()
    try: 
        dataList = dbManager.executeSingleQuery(querySQL)
        dic = {}
        if len(dataList) > 0:
            dic = {"content": dataList[0]["content"]}
        return RESPONSE_JSON(CODE_SUCCESS, dic)
    except Exception as e:
        Loger.error(e, __file__)
        return RESPONSE_JSON(CODE_ERROR_SERVICE)
    


if __name__ == '__main__':
    pass
