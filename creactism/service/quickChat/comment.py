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

from service.quickChat import quickChat
from module.database import DB
from module.log.Log import Loger
from config import *
from common.code import *
from common.tools import getValueFromRequestByKey, generateUUID, generateCurrentTime


@quickChat.route('/comment', methods=["GET", "POST"])
def comment():
    topicUUID = getValueFromRequestByKey("topic_uuid")
    content = getValueFromRequestByKey("content")

    if topicUUID == None or  content == None:
        return RESPONSE_JSON(CODE_ERROR_MISS_PARAM)

    return __insertCommentIntoStorage(topicUUID, content)
    

def __insertCommentIntoStorage(topicUUID, content):
    uuid = generateUUID()
    time = generateCurrentTime()

    insertSQL = """
        INSERT INTO t_quickChat_topic_comment(uuid, user_uuid, topic_uuid, content, time, `like`) VALUES (%s, '', %s, %s, %s, 0)
    """
    args = [uuid, topicUUID, content, time]
            
    dbManager = DB.DBManager.shareInstanced()
    try: 
        dbManager.executeTransactionDmlWithArgs(insertSQL, args)
        return RESPONSE_JSON(CODE_SUCCESS)
    except Exception as e:
        Loger.error(e, __file__)
        return RESPONSE_JSON(CODE_ERROR_SERVICE)


if __name__ == '__main__':
    pass
