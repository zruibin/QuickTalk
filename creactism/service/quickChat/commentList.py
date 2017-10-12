#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# commentList.py
#
# Created by ruibin.chow on 2017/10/11.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""
评论列表
"""

from service.quickChat import quickChat
from module.database import DB
from module.log.Log import Loger
from config import *
from common.code import *
from common.tools import getValueFromRequestByKey, parsePageIndex, limit


@quickChat.route('/commentList', methods=["GET", "POST"])
def commentList():
    topicUUID = getValueFromRequestByKey("topic_uuid")
    index = getValueFromRequestByKey("index")
    index = parsePageIndex(index)

    if topicUUID == None:
        return RESPONSE_JSON(CODE_ERROR_MISS_PARAM) 

    return __getCommentListFromStorage(topicUUID, index)


def __getCommentListFromStorage(topicUUID, index):
    limitSQL = limit(index)
    querySQL = """
        SELECT id, uuid, user_uuid AS userUUID, topic_uuid AS topicUUID, 
        content, time, `like` FROM t_quickChat_topic_comment WHERE topic_uuid='%s' ORDER BY time %s
    """ % (topicUUID, limitSQL)
    print querySQL

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
