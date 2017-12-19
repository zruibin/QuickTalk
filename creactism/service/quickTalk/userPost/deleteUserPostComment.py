#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# deleteUserPostComment.py
#
# Created by ruibin.chow on 2017/12/04.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""
删除userPost评论
"""

from service.quickTalk.userPost import userPost
from module.database import DB
from module.log.Log import Loger
from config import *
from common.code import *
from common.tools import getValueFromRequestByKey


@userPost.route('/deleteUserPostComment', methods=["POST"])
def deleteUserPostComment():
    userPostUUID = getValueFromRequestByKey("userPost_uuid")
    userUUID = getValueFromRequestByKey("user_uuid")
    commentUUID = getValueFromRequestByKey("comment_uuid")

    isReply = getValueFromRequestByKey("isReply")
    replyUUID = getValueFromRequestByKey("reply_uuid")

    if userPostUUID == None or commentUUID == None or userUUID == None:
        return RESPONSE_JSON(CODE_ERROR_MISS_PARAM)

    if isReply == Config.TYPE_FOR_COMMENT_REPLY:
        if replyUUID == None:
            return RESPONSE_JSON(CODE_ERROR_MISS_PARAM)
    else:
        isReply= Config.TYPE_FOR_COMMENT_DEFAULT

    return __deleteUserPostCommentInStorage(userPostUUID, commentUUID, userUUID, isReply, replyUUID)
    

def __deleteUserPostCommentInStorage(userPostUUID, commentUUID, userUUID, isReply, replyUUID=""):
    typeStr = Config.TYPE_MESSAGE_USERPOST_COMMENT
    reciveUserUUID = ""
    if isReply == Config.TYPE_FOR_COMMENT_REPLY:
        typeStr = Config.TYPE_MESSAGE_USERPOST_REPLY_COMMENT
        reciveUserUUID = __queryUserPostCommentUserUUID(replyUUID)
    else:
        reciveUserUUID = __queryUserPostUserUUID(userPostUUID)

    sqlList = []
    argsList = []
    deleteSQL = """DELETE FROM t_quickTalk_userPost_comment WHERE uuid=%s AND user_uuid=%s AND userPost_uuid=%s; """
    sqlList.append(deleteSQL)
    argsList.append([commentUUID, userUUID, userPostUUID])
        
    deleteMessageSQL = """
        DELETE FROM t_quickTalk_message WHERE content_uuid=%s AND type=%s AND user_uuid=%s;
    """
    sqlList.append(deleteMessageSQL)
    argsList.append([commentUUID, typeStr, reciveUserUUID])

    dbManager = DB.DBManager.shareInstanced()
    try: 
        dbManager.executeTransactionMutltiDmlWithArgsList(sqlList, argsList)
        __deleteAllAboutUserPostComment(commentUUID)
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


def __deleteAllAboutUserPostComment(commentUUID):
    deleteMessageSQL = """DELETE FROM t_quickTalk_message 
        WHERE content_uuid='%s' AND type='%s'; """ % (commentUUID, Config.TYPE_MESSAGE_USERPOST_COMMENT)
    
    dbManager = DB.DBManager.shareInstanced()
    try: 
        dbManager.executeTransactionMutltiDml([deleteMessageSQL])
    except Exception as e:
        Loger.error(e, __file__)

    


if __name__ == '__main__':
    pass