#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# likeList.py
#
# Created by ruibin.chow on 2017/12/19.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""
个人的已赞列表
"""

from . import like
from module.database import DB
from module.log.Log import Loger
from config import *
from common.code import *
from common.tools import getValueFromRequestByKey, parsePageIndex, limit, fullPathForMediasFile, userAvatarURL
from ..userPost.userPostList import queryPackageUserPostLikeList, queryTheUserPostIsLiked, queryTheUserPostTagList


@like.route('/likeList', methods=["GET", "POST"])
def likeList():
    userUUID = getValueFromRequestByKey("user_uuid")
    relationUserUUID = getValueFromRequestByKey("relation_user_uuid")
    typeStr = getValueFromRequestByKey("type")
    index = getValueFromRequestByKey("index")
    index = parsePageIndex(index)
    size = getValueFromRequestByKey("size")

    if userUUID == None or typeStr == None:
        return RESPONSE_JSON(CODE_ERROR_MISS_PARAM)

    if typeStr != Config.TYPE_MESSAGE_LIKE_USERPOST:
        return RESPONSE_JSON(CODE_ERROR_PARAM)

    return __getLikeListFromStorage(userUUID, typeStr, index, size, relationUserUUID)


def __getLikeListFromStorage(userUUID, typeStr, index, size, relationUserUUID):
    limitSQL = limit(index)
    if size is not None: limitSQL = limit(index, int(size))
        
    querySQL = """
            SELECT content_uuid 
            FROM t_quickTalk_like WHERE user_uuid='%s' AND type='%s'
            ORDER BY time DESC %s
    """ % (userUUID, Config.TYPE_MESSAGE_LIKE_USERPOST, limitSQL)
        
    # print querySQL 

    dbManager = DB.DBManager.shareInstanced()
    try: 
        dataList = dbManager.executeSingleQuery(querySQL)
        userPostUUIDList = []
        for data in dataList:
            userPostUUIDList.append(data["content_uuid"])
        dataList = __queryUserPostList(userPostUUIDList, relationUserUUID)
        return RESPONSE_JSON(CODE_SUCCESS, dataList)
    except Exception as e:
        Loger.error(e, __file__)
        return RESPONSE_JSON(CODE_ERROR_SERVICE)
    

def __queryUserPostList(userPostUUIDList, relationUserUUID):
    if len(userPostUUIDList) == 0:
        return []
    
    inString = "'" + "','".join(userPostUUIDList) + "'"
    querySQL = """
        SELECT id, uuid, title, content, read_count AS readCount, time,
        user_uuid AS userUUID, txt, type,
        (SELECT t_quickTalk_user.id FROM t_quickTalk_user WHERE t_quickTalk_user.uuid=t_quickTalk_userPost.user_uuid) AS userId,
        (SELECT nickname FROM t_quickTalk_user WHERE t_quickTalk_user.uuid=t_quickTalk_userPost.user_uuid) AS nickname,
        (SELECT avatar FROM t_quickTalk_user WHERE t_quickTalk_user.uuid=t_quickTalk_userPost.user_uuid) AS avatar,
        (SELECT COUNT(t_quickTalk_userPost_comment.uuid) FROM t_quickTalk_userPost_comment WHERE userPost_uuid=t_quickTalk_userPost.uuid) AS commentCount
        FROM t_quickTalk_userPost WHERE uuid IN (%s) 
        ORDER BY INSTR('%s', uuid);
    """ % (inString, ",".join(userPostUUIDList))
    # print querySQL

    dbManager = DB.DBManager.shareInstanced()
    try: 
        dataList = dbManager.executeSingleQuery(querySQL)
        uuidList = []
        for data in dataList:
            uuidList.append(data["uuid"])
            userUUID = data["userUUID"]
            data["time"] = str(data["time"])
            data["avatar"] = userAvatarURL(userUUID, data["avatar"])
        dataList = queryTheUserPostIsLiked(dataList, userPostUUIDList, relationUserUUID)
        dataList = queryPackageUserPostLikeList(dataList, uuidList)
        dataList = queryTheUserPostTagList(dataList, uuidList)
        return dataList
    except Exception as e:
        Loger.error(e, __file__)
        raise e


if __name__ == '__main__':
    pass
