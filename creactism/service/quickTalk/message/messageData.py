#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# messageData.py
#
# Created by ruibin.chow on 2017/12/19.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""
获得消息数据
"""

from service.quickTalk.message import message
from module.database import DB
from module.log.Log import Loger
from config import *
from common.code import *
from common.tools import getValueFromRequestByKey, parsePageIndex, limit, fullPathForMediasFile, userAvatarURL
from common.auth import vertifyTokenHandle


@message.route('/message', methods=["GET", "POST"])
@vertifyTokenHandle
def messageData():
    userUUID = getValueFromRequestByKey("user_uuid")
    typeStr = getValueFromRequestByKey("type")
    index = getValueFromRequestByKey("index")
    index = parsePageIndex(index)
    size = getValueFromRequestByKey("size")
    update = getValueFromRequestByKey("update") # 非必要，默认自动设置请求的未读变为已读

    limitSQL = limit(index)
    if size is not None: limitSQL = limit(index, int(size))
    
    if typeStr not in (Config.TYPE_MESSAGE_LIKE_USERPOST, Config.TYPE_MESSAGE_USERPOST_COMMENT, Config.TYPE_MESSAGE_USERPOST_REPLY_COMMENT, Config.TYPE_MESSAGE_ADD_NEW_FRIEND):
        return RESPONSE_JSON(CODE_ERROR_PARAM)

    if typeStr == Config.TYPE_MESSAGE_LIKE_USERPOST:
        return __getLikeUserPostDataFromStorage(userUUID, limitSQL, update)
    elif typeStr == Config.TYPE_MESSAGE_ADD_NEW_FRIEND:
        return __getNewFriendDataFromStorage(userUUID, limitSQL, update)
    else:
        return __getUserPostCommentDataFromStorage(userUUID, limitSQL, update)



def __getLikeUserPostDataFromStorage(userUUID, limitSQL, update):
    querySQL = """
        SELECT t_quickTalk_message.id, t_quickTalk_message.time,
            content_uuid, generated_user_uuid, %s AS type,
            t_quickTalk_user.id AS userID, t_quickTalk_user.uuid AS userUUID, 
            t_quickTalk_user.nickname, t_quickTalk_user.avatar,
            t_quickTalk_userPost.uuid AS userPostUUID, t_quickTalk_userPost.title, 
            t_quickTalk_userPost.content
        FROM t_quickTalk_message INNER JOIN t_quickTalk_user 
            INNER JOIN t_quickTalk_userPost
        ON t_quickTalk_message.user_uuid='%s' AND t_quickTalk_message.type=%s
        AND t_quickTalk_message.status=%d
        AND t_quickTalk_user.uuid=t_quickTalk_message.generated_user_uuid
        AND t_quickTalk_userPost.uuid=t_quickTalk_message.content_uuid
        ORDER BY t_quickTalk_message.time DESC %s
    """ % (Config.TYPE_MESSAGE_LIKE_USERPOST, userUUID,
             Config.TYPE_MESSAGE_LIKE_USERPOST, 
             Config.TYPE_MESSAGE_UNREAD, limitSQL)
    # print querySQL

    dbManager = DB.DBManager.shareInstanced()
    dataList = []
    messageIdList = []
    try: 
        dataList = dbManager.executeSingleQuery(querySQL)
        for data in dataList:
            messageIdList.append(str(data["id"]))
            userUUID = data["userUUID"]
            data["time"] = str(data["time"])
            data["avatar"] = userAvatarURL(userUUID, data["avatar"])
    except Exception as e:
        Loger.error(e, __file__)
        return RESPONSE_JSON(CODE_ERROR_SERVICE)
    else:
        __updateMessageData(messageIdList, update)
        return RESPONSE_JSON(CODE_SUCCESS, data=dataList)


def __getNewFriendDataFromStorage(userUUID, limitSQL, update):
    querySQL = """
        SELECT t_quickTalk_message.id, t_quickTalk_message.time,
            content_uuid, generated_user_uuid, %s AS type,
            t_quickTalk_user.id AS userID, t_quickTalk_user.uuid AS userUUID, 
            t_quickTalk_user.nickname, t_quickTalk_user.avatar
        FROM t_quickTalk_message INNER JOIN t_quickTalk_user 
        ON t_quickTalk_message.user_uuid='%s' AND t_quickTalk_message.type=%s
        AND t_quickTalk_message.status=%d
        AND t_quickTalk_user.uuid=t_quickTalk_message.generated_user_uuid
        ORDER BY t_quickTalk_message.time DESC %s
    """ % (Config.TYPE_MESSAGE_ADD_NEW_FRIEND, userUUID, 
            Config.TYPE_MESSAGE_ADD_NEW_FRIEND, 
            Config.TYPE_MESSAGE_UNREAD, limitSQL)
    # print querySQL

    dbManager = DB.DBManager.shareInstanced()
    dataList = []
    messageIdList = []
    try: 
        dataList = dbManager.executeSingleQuery(querySQL)
        for data in dataList:
            messageIdList.append(str(data["id"]))
            userUUID = data["userUUID"]
            data["time"] = str(data["time"])
            data["avatar"] = userAvatarURL(userUUID, data["avatar"])
    except Exception as e:
        Loger.error(e, __file__)
        return RESPONSE_JSON(CODE_ERROR_SERVICE)
    else:
        __updateMessageData(messageIdList, update)
        return RESPONSE_JSON(CODE_SUCCESS, data=dataList)
    

def __getUserPostCommentDataFromStorage(userUUID, limitSQL, update):
    querySQL = """
        SELECT t_quickTalk_message.id, t_quickTalk_message.time,
            content_uuid, generated_user_uuid, %s AS type,
            t_quickTalk_user.id AS userID, t_quickTalk_user.uuid AS userUUID, 
            t_quickTalk_user.nickname, t_quickTalk_user.avatar,
            t_quickTalk_userPost_comment.userPost_uuid AS userPostUUID, t_quickTalk_userPost.title, 
            t_quickTalk_userPost.content
        FROM t_quickTalk_message INNER JOIN t_quickTalk_user 
            INNER JOIN t_quickTalk_userPost
            INNER JOIN t_quickTalk_userPost_comment
        ON t_quickTalk_message.user_uuid='%s' AND t_quickTalk_message.type=%s
        AND t_quickTalk_message.status=%d
        AND t_quickTalk_user.uuid=t_quickTalk_message.generated_user_uuid
        AND t_quickTalk_userPost_comment.uuid=t_quickTalk_message.content_uuid
        AND t_quickTalk_userPost.uuid=t_quickTalk_userPost_comment.userPost_uuid
        ORDER BY t_quickTalk_message.time DESC %s
    """ % (Config.TYPE_MESSAGE_USERPOST_COMMENT, userUUID,
             Config.TYPE_MESSAGE_USERPOST_COMMENT, 
             Config.TYPE_MESSAGE_UNREAD, limitSQL)
    # print querySQL

    dbManager = DB.DBManager.shareInstanced()
    dataList = []
    messageIdList = []
    try: 
        dataList = dbManager.executeSingleQuery(querySQL)
        for data in dataList:
            messageIdList.append(str(data["id"]))
            userUUID = data["userUUID"]
            data["time"] = str(data["time"])
            data["avatar"] = userAvatarURL(userUUID, data["avatar"])
    except Exception as e:
        Loger.error(e, __file__)
        return RESPONSE_JSON(CODE_ERROR_SERVICE)
    else:
        __updateMessageData(messageIdList, update)
        return RESPONSE_JSON(CODE_SUCCESS, data=dataList)




def __updateMessageData(messageIdList, update):
    if update != None:
        return
    if len(messageIdList) == 0:
        return

    inString = "'" + "','".join(messageIdList) + "'"
    updataSQL = """
        UPDATE t_quickTalk_message SET status=%s WHERE id IN (%s)
    """ % (Config.TYPE_MESSAGE_READ, inString)
    # print updataSQL
    try: 
        dbManager = DB.DBManager.shareInstanced()
        dbManager.executeTransactionDml(updataSQL)
    except Exception as e:
        Loger.error(e, __file__)
    





if __name__ == '__main__':
    pass
