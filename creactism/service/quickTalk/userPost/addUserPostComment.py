#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# addUserPostComment.py
#
# Created by ruibin.chow on 2017/12/04.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""
新增userPost评论
"""

from service.quickTalk.userPost import userPost
from module.database import DB
from module.log.Log import Loger
from config import *
from common.code import *
from common.tools import getValueFromRequestByKey, generateUUID, generateCurrentTime


@userPost.route('/addUserPostComment', methods=["POST"])
def addUserPostComment():
    userPostUUID = getValueFromRequestByKey("userPost_uuid")
    userUUID = getValueFromRequestByKey("user_uuid")
    content = getValueFromRequestByKey("content")

    isReply = getValueFromRequestByKey("isReply")
    replyUUID = getValueFromRequestByKey("reply_uuid")

    if userPostUUID == None or content == None or userUUID == None:
        return RESPONSE_JSON(CODE_ERROR_MISS_PARAM)

    if isReply == Config.TYPE_FOR_COMMENT_REPLY:
        if replyUUID == None:
            return RESPONSE_JSON(CODE_ERROR_MISS_PARAM)

    return __storageUserPostComment(userPostUUID, content, userUUID, isReply, replyUUID)
    

def __storageUserPostComment(userPostUUID, content, userUUID, isReply= Config.TYPE_FOR_COMMENT_DEFAULT, replyUUID=""):
    uuid = generateUUID()
    time = generateCurrentTime()
    insertSQL = "INSERT INTO t_quickTalk_userPost_comment (uuid, user_uuid, userPost_uuid, content, isReply, reply_uuid, time) VALUES (%s, %s, %s, %s, %s, %s, %s)"
    args = [uuid, userUUID, userPostUUID, content, isReply, replyUUID, time]
        
    dbManager = DB.DBManager.shareInstanced()
    try: 
        result = dbManager.executeTransactionDmlWithArgs(insertSQL, args)
    except Exception as e:
        Loger.error(e, __file__)
        return RESPONSE_JSON(CODE_ERROR_SERVICE)
    return RESPONSE_JSON(CODE_SUCCESS)
    


if __name__ == '__main__':
    pass
