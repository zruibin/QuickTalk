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
    else:
        isReply= Config.TYPE_FOR_COMMENT_DEFAULT

    return __storageUserPostComment(userPostUUID, content, userUUID, isReply, replyUUID)
    

def __storageUserPostComment(userPostUUID, content, userUUID, isReply, replyUUID=""):
    # print isReply
    reciveUserUUID = ""
    typeStr = Config.TYPE_MESSAGE_USERPOST_COMMENT
    if isReply == Config.TYPE_FOR_COMMENT_REPLY:
        reciveUserUUID = __queryUserPostCommentUserUUID(replyUUID)
        typeStr = Config.TYPE_MESSAGE_USERPOST_REPLY_COMMENT
    else:
        reciveUserUUID = __queryUserPostUserUUID(userPostUUID)
    
    if reciveUserUUID == None:
        return RESPONSE_JSON(CODE_ERROR_CONTENT_IS_NULL) 

    sqlList = []
    argsList = []
    uuid = generateUUID()
    time = generateCurrentTime()
    insertSQL = "INSERT INTO t_quickTalk_userPost_comment (uuid, user_uuid, userPost_uuid, content, isReply, reply_uuid, time) VALUES (%s, %s, %s, %s, %s, %s, %s)"
    sqlList.append(insertSQL)
    argsList.append([uuid, userUUID, userPostUUID, content, isReply, replyUUID, time])

    messageSQL = """
        INSERT INTO t_quickTalk_message (user_uuid, type, content_uuid, time, 
            generated_user_uuid, status, content) VALUES (%s, %s, %s, %s, %s, %s, %s);
    """
    sqlList.append(messageSQL)
    argsList.append([reciveUserUUID, typeStr, uuid, time, userUUID, str(Config.TYPE_MESSAGE_UNREAD), ""])
        
    dbManager = DB.DBManager.shareInstanced()
    try: 
        result = dbManager.executeTransactionMutltiDmlWithArgsList(sqlList, argsList)
    except Exception as e:
        Loger.error(e, __file__)
        return RESPONSE_JSON(CODE_ERROR_SERVICE)
    return RESPONSE_JSON(CODE_SUCCESS)
    

def __queryUserPostUserUUID(userPostUUID):
    querySQL = """SELECT user_uuid FROM t_quickTalk_userPost WHERE uuid='%s';""" % (userPostUUID)
    dbManager = DB.DBManager.shareInstanced()
    try:
        resultList = dbManager.executeSingleQuery(querySQL)
        if len(resultList) > 0: 
            return resultList[0]["user_uuid"]
        else:
            return None
    except Exception as e:
        Loger.error(e, __file__)
        raise e


def __queryUserPostCommentUserUUID(uuid):
    querySQL = """SELECT user_uuid FROM t_quickTalk_userPost_comment WHERE uuid='%s';""" % (uuid)
    dbManager = DB.DBManager.shareInstanced()
    try:
        resultList = dbManager.executeSingleQuery(querySQL)
        if len(resultList) > 0: 
            return resultList[0]["user_uuid"]
        else:
            return None
    except Exception as e:
        Loger.error(e, __file__)
        raise e


if __name__ == '__main__':
    pass
