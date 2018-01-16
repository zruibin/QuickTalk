#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# deleteUserPost.py
#
# Created by ruibin.chow on 2017/12/04.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""
删除userPost
"""

from . import userPost
from module.database import DB
from module.log.Log import Loger
from config import *
from common.code import *
from common.tools import getValueFromRequestByKey
from common.auth import vertifyTokenHandle


@userPost.route('/deleteUserPost', methods=["POST"])
@vertifyTokenHandle
def deleteUserPost():
    userPostUUID = getValueFromRequestByKey("userPost_uuid")
    userUUID = getValueFromRequestByKey("user_uuid")

    if userPostUUID == None or userUUID == None:
        return RESPONSE_JSON(CODE_ERROR_MISS_PARAM)

    return __deleteUserPostInStorage(userPostUUID, userUUID)
    

def __deleteUserPostInStorage(userPostUUID, userUUID):
    
    if __queryUserPostOwner(userPostUUID, userUUID) == False:
        return RESPONSE_JSON(CODE_ERROR_INVALID_USER)

    deleteSQL = """DELETE FROM t_quickTalk_userPost WHERE uuid='%s' AND user_uuid='%s'; """ % (userPostUUID, userUUID)
    deleteCommentSQL = """DELETE FROM t_quickTalk_userPost_comment WHERE userPost_uuid='%s' """ % (userPostUUID)
    deleteTagsSQL = """DELETE FROM t_tag_userPost WHERE userPost_uuid='%s' """ % (userPostUUID)

    dbManager = DB.DBManager.shareInstanced()
    try: 
        commentUUIDList = __queryAllUserPostComment(userPostUUID)
        dbManager.executeTransactionMutltiDml([deleteSQL, deleteCommentSQL, deleteTagsSQL])
        __deleteAllAboutUserPost(userPostUUID, commentUUIDList)
    except Exception as e:
        Loger.error(e, __file__)
        return RESPONSE_JSON(CODE_ERROR_SERVICE)
    return RESPONSE_JSON(CODE_SUCCESS)
    

def __queryUserPostOwner(userPostUUID, userUUID):
    querySQL = """
        SELECT uuid FROM t_quickTalk_userPost WHERE uuid='%s' AND user_uuid='%s'; """ % (userPostUUID, userUUID)
    dbManager = DB.DBManager.shareInstanced()
    try: 
        result = dbManager.executeTransactionQuery(querySQL)
        if len(result) > 0:
            return True
        else:
            return False
    except Exception as e:
        Loger.error(e, __file__)
        return False


def __queryAllUserPostComment(userPostUUID):
    querySQL = """SELECT uuid FROM t_quickTalk_userPost_comment WHERE userPost_uuid='%s' """ % userPostUUID
    commentUUIDList = []
    dbManager = DB.DBManager.shareInstanced()
    try: 
        dataList = dbManager.executeTransactionQuery(querySQL)
        for data in dataList:
            commentUUIDList.append(data["uuid"])
    except Exception as e:
        Loger.error(e, __file__)
    return commentUUIDList


def __deleteAllAboutUserPost(userPostUUID, commentUUIDList):
    deleteStarSQL = """DELETE FROM t_quickTalk_like WHERE content_uuid='%s' 
        AND type='%s'; """ % (userPostUUID, Config.TYPE_MESSAGE_LIKE_USERPOST)
    deleteCollectionSQL = """DELETE FROM t_quickTalk_collection 
        WHERE content_uuid='%s' AND type='%s'; """ % (userPostUUID, Config.TYPE_FOR_COLLECTION_USERPOST)
    deleteMessageSQL = """DELETE FROM t_quickTalk_message 
        WHERE content_uuid='%s' AND type='%s'; """ % (userPostUUID, Config.TYPE_MESSAGE_LIKE_USERPOST)

    inString = "'" + "','".join(commentUUIDList) + "'"
    deleteCommentMessageSQL = """DELETE FROM t_quickTalk_message 
        WHERE content_uuid IN (%s) AND type='%s'; """ % (inString, Config.TYPE_MESSAGE_USERPOST_COMMENT)
    
    dbManager = DB.DBManager.shareInstanced()
    try: 
        dbManager.executeTransactionMutltiDml([deleteStarSQL, deleteCollectionSQL, deleteMessageSQL, deleteCommentMessageSQL])
    except Exception as e:
        Loger.error(e, __file__)

    
    


if __name__ == '__main__':
    pass
