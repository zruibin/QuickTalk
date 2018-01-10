#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# userPostCommentList.py
#
# Created by ruibin.chow on 2017/12/04.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""
userPost评论列表
"""

from . import userPost
from module.database import DB
from module.log.Log import Loger
from config import *
from common.code import *
from common.tools import getValueFromRequestByKey, parsePageIndex, limit, fullPathForMediasFile, userAvatarURL


@userPost.route('/userPostCommentList', methods=["GET", "POST"])
def userPostCommentList():
    userPostUUID = getValueFromRequestByKey("userPost_uuid")
    index = getValueFromRequestByKey("index")
    index = parsePageIndex(index)
    size = getValueFromRequestByKey("size")

    if userPostUUID == None:
        return RESPONSE_JSON(CODE_ERROR_MISS_PARAM)
        
    return __getUserPostFromStorage(index, size, userPostUUID)


def __getUserPostFromStorage(index, size, userPostUUID):
    limitSQL = limit(index)
    if size is not None: limitSQL = limit(index, int(size))
        
    querySQL = """
        SELECT id, uuid, content, time, user_uuid AS userUUID, 
        (SELECT nickname FROM t_quickTalk_user WHERE t_quickTalk_user.uuid=t_quickTalk_userPost_comment.user_uuid) AS nickname,
        (SELECT avatar FROM t_quickTalk_user WHERE t_quickTalk_user.uuid=t_quickTalk_userPost_comment.user_uuid) AS avatar,
        isReply, reply_uuid
        FROM t_quickTalk_userPost_comment WHERE userPost_uuid='%s'  ORDER BY time DESC %s
    """ % (userPostUUID, limitSQL)

    # print querySQL 

    dbManager = DB.DBManager.shareInstanced()
    try: 
        dataList = dbManager.executeSingleQuery(querySQL)
        for data in dataList:
            userUUID = data["userUUID"]
            data["time"] = str(data["time"])
            data["avatar"] = userAvatarURL(userUUID, data["avatar"])

        dataList = __packageReplyContent(dataList)
        return RESPONSE_JSON(CODE_SUCCESS, dataList)
    except Exception as e:
        Loger.error(e, __file__)
        return RESPONSE_JSON(CODE_ERROR_SERVICE)
    

def __packageReplyContent(dataList):
    inList = []
    for data in dataList:
        isReply = str(data["isReply"])
        if isReply == Config.TYPE_FOR_COMMENT_REPLY:
            inList.append(data["reply_uuid"])

    if len(inList) == 0:
        return dataList

    inString = "'" + "','".join(inList) + "'"
    querySQL = """
        SELECT uuid, content, user_uuid AS replyUserUUID,
	        (SELECT nickname FROM t_quickTalk_user WHERE t_quickTalk_user.uuid=t_quickTalk_userPost_comment.user_uuid) AS replyNickname
     FROM t_quickTalk_userPost_comment WHERE uuid IN (%s)
    """ % inString

    dbManager = DB.DBManager.shareInstanced()
    try: 
        replyDataList = dbManager.executeSingleQuery(querySQL)
        dataList = __packageAction(dataList, replyDataList)
    except Exception as e:
        Loger.error(e, __file__)
        raise e
    return dataList
    

def __packageAction(dataList, replyDataList):
    # print replyDataList
    for data in dataList:
        isReply = str(data["isReply"])
        if isReply == Config.TYPE_FOR_COMMENT_REPLY:
            replyUUID = data["reply_uuid"]
            for replyData in replyDataList:
                if replyUUID == replyData["uuid"]:
                    data["replyContent"] = replyData["content"]
                    data["replyUserUUID"] = replyData["replyUserUUID"]
                    data["replyNickname"] = replyData["replyNickname"]
    return dataList


if __name__ == '__main__':
    pass
