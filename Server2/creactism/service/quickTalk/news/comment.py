#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# comment.py
#
# Created by ruibin.chow on 2017/10/11.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""
评论
"""

from . import news
from module.database import DB
from module.log.Log import Loger
from config import *
from common.code import *
from common.tools import getValueFromRequestByKey, generateUUID, generateCurrentTime
from common.auth import vertifyTokenHandle


@news.route('/comment', methods=["GET", "POST"])
@vertifyTokenHandle
def comment():
    topicUUID = getValueFromRequestByKey("topic_uuid")
    userUUID = getValueFromRequestByKey("user_uuid")
    content = getValueFromRequestByKey("content")

    if topicUUID == None or  content == None or userUUID == None:
        return RESPONSE_JSON(CODE_ERROR_MISS_PARAM)

    return __insertCommentIntoStorage(topicUUID, content, userUUID)
    

def __insertCommentIntoStorage(topicUUID, content, userUUID):
    uuid = generateUUID()
    time = generateCurrentTime()

    insertSQL = """
        INSERT INTO t_quickTalk_topic_comment(uuid, user_uuid, topic_uuid, content, time, `like`) VALUES (%s, %s, %s, %s, %s, 0)
    """
    args = [uuid, userUUID, topicUUID, content, time]
            
    dbManager = DB.DBManager.shareInstanced()
    try: 
        dbManager.executeTransactionDmlWithArgs(insertSQL, args)
        return RESPONSE_JSON(CODE_SUCCESS)
    except Exception as e:
        Loger.error(e, __file__)
        return RESPONSE_JSON(CODE_ERROR_SERVICE)


if __name__ == '__main__':
    pass
