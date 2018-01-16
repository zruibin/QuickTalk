#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# addUserPost.py
#
# Created by ruibin.chow on 2017/12/04.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""
新增userPost
"""

from . import userPost
from module.database import DB
from module.log.Log import Loger
from config import *
from common.code import *
from common.tools import getValueFromRequestByKey, generateUUID, generateCurrentTime
from dispatch.notification import dispatchNotificationNewShare
from common.auth import vertifyTokenHandle
import json


@userPost.route('/addUserPost', methods=["POST"])
@vertifyTokenHandle
def addUserPost():
    title = getValueFromRequestByKey("title")
    content = getValueFromRequestByKey("content")
    txt = getValueFromRequestByKey("txt")
    userUUID = getValueFromRequestByKey("user_uuid")
    tagsString = getValueFromRequestByKey("tagsString")

    if title == None or content == None or userUUID == None:
        return RESPONSE_JSON(CODE_ERROR_MISS_PARAM)

    return __storageUserPost(title, content, userUUID, txt, tagsString)
    

def __storageUserPost(title, content, userUUID, txt, tagsString):
    uuid = generateUUID()
    time = generateCurrentTime()
    sqlList = []
    argsList = []

    insertSQL = "INSERT INTO t_quickTalk_userPost (uuid, user_uuid, title, txt, content, time) VALUES (%s, %s, %s, %s, %s, %s)"
    args = [uuid, userUUID, title, txt, content, time]
    sqlList.append(insertSQL)
    argsList.append(args)

    if txt != None and len(txt) != 0:
        commentUUID = generateUUID()
        insertFirstCommentSQL = "INSERT INTO t_quickTalk_userPost_comment (uuid, user_uuid, userPost_uuid, content, isReply, reply_uuid, time) VALUES (%s, %s, %s, %s, %s, %s, %s)"
        firstCommentArgs = [commentUUID, userUUID, uuid, txt, Config.TYPE_FOR_COMMENT_DEFAULT, "", time]
        sqlList.append(insertFirstCommentSQL)
        argsList.append(firstCommentArgs)

    try:
        tagList = json.loads(tagsString)
        sqlList, argsList = generateUserPostTagsSQL(uuid, tagList, sqlList, argsList)
    except Exception, e:
        Loger.error(e, __file__)
        
    dbManager = DB.DBManager.shareInstanced()
    try: 
        dbManager.executeTransactionMutltiDmlWithArgsList(sqlList, argsList)
        # 远程通知
        dispatchNotificationNewShare.delay(userUUID)
    except Exception as e:
        Loger.error(e, __file__)
        return RESPONSE_JSON(CODE_ERROR_SERVICE)
    return RESPONSE_JSON(CODE_SUCCESS)
    

def generateUserPostTagsSQL(userPostUUID, tagList, sqlList, argsList):
    """"生成标签sql"""
    deleteSQL = """
            DELETE FROM t_tag_userPost WHERE userPost_uuid=%s
        """
    sqlList.append(deleteSQL)
    argsList.append([userPostUUID])
    if len(tagList) > 0:
        insertSQL = "INSERT INTO t_tag_userPost(userPost_uuid, sorting, tag) VALUES "
        values = []
        for index in range(len(tagList)):
            # print index, tagList[index]
            insertSQL += "(%s, %s, %s), "
            values.append(userPostUUID)
            values.append(index)
            values.append(tagList[index])
        insertSQL = insertSQL[:-2] + ";"
        # DLog(insertSQL, False)
        sqlList.append(insertSQL)
        argsList.append(values)
    return sqlList, argsList




if __name__ == '__main__':
    pass
