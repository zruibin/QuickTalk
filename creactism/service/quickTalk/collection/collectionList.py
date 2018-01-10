#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# collectionList.py
#
# Created by ruibin.chow on 2017/12/15.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""
收藏列表
"""

from . import collection
from module.database import DB
from module.log.Log import Loger
from config import *
from common.code import *
from common.auth import vertifyTokenHandle
from common.tools import getValueFromRequestByKey, parsePageIndex, limit, fullPathForMediasFile, userAvatarURL
from ..userPost.userPostList import queryPackageUserPostLikeList, queryTheUserPostIsLiked


@collection.route('/list', methods=["POST", "GET"])
@vertifyTokenHandle
def collectionList():
    userUUID = getValueFromRequestByKey("user_uuid")
    typeStr = getValueFromRequestByKey("type")
    index = getValueFromRequestByKey("index")
    index = parsePageIndex(index)
    size = getValueFromRequestByKey("size")
    
    if userUUID == None or typeStr == None:
        return RESPONSE_JSON(CODE_ERROR_MISS_PARAM)

    if typeStr not in (Config.TYPE_FOR_COLLECTION_USERPOST):
        return RESPONSE_JSON(CODE_ERROR_PARAM)

    if typeStr == Config.TYPE_FOR_COLLECTION_USERPOST:
        return __collectionListForUserPost(userUUID, index, size)
    else:
        return RESPONSE_JSON(CODE_ERROR_SERVICE)


def __collectionListForUserPost(userUUID, index, size):
    limitSQL = limit(index)
    if size is not None: limitSQL = limit(index, int(size))
        
    querySQL = """
        SELECT content_uuid, type FROM t_quickTalk_collection 
            WHERE user_uuid='%s' AND type='%s'  ORDER BY time DESC %s
    """ % (userUUID, Config.TYPE_FOR_COLLECTION_USERPOST, limitSQL)

    # print querySQL 

    dbManager = DB.DBManager.shareInstanced()
    try: 
        dataList = dbManager.executeSingleQuery(querySQL)
        dataList = __packQueryUserPost(dataList)
        uuidList = []
        for data in dataList:
            uuidList.append(data["uuid"])
        dataList = queryTheUserPostIsLiked(dataList, uuidList, userUUID)
        dataList = queryPackageUserPostLikeList(dataList, uuidList)
        return RESPONSE_JSON(CODE_SUCCESS, dataList)
    except Exception as e:
        Loger.error(e, __file__)
        return RESPONSE_JSON(CODE_ERROR_SERVICE)


def __packQueryUserPost(dataList):
    if len(dataList) == 0:
        return dataList

    uuidList = []
    for data in dataList:
        uuidList.append(data["content_uuid"])

    inString = "'" + "','".join(uuidList) + "'"
    querySQL = """
        SELECT id, uuid, title, content, read_count AS readCount, time,
            user_uuid AS userUUID, txt,
            (SELECT nickname FROM t_quickTalk_user WHERE t_quickTalk_user.uuid=t_quickTalk_userPost.user_uuid) AS nickname,
            (SELECT avatar FROM t_quickTalk_user WHERE t_quickTalk_user.uuid=t_quickTalk_userPost.user_uuid) AS avatar,
            (SELECT COUNT(t_quickTalk_userPost_comment.uuid) FROM t_quickTalk_userPost_comment WHERE userPost_uuid=t_quickTalk_userPost.uuid) AS commentCount
            FROM t_quickTalk_userPost WHERE uuid IN (%s) 
            ORDER BY INSTR('%s', uuid);
    """ % (inString, ",".join(uuidList))

    # print querySQL

    dbManager = DB.DBManager.shareInstanced()
    try: 
        dataList = dbManager.executeSingleQuery(querySQL)
        for data in dataList:
            userUUID = data["userUUID"]
            data["time"] = str(data["time"])
            data["avatar"] = userAvatarURL(userUUID, data["avatar"])
        return dataList
    except Exception as e:
        Loger.error(e, __file__)
        raise e



if __name__ == '__main__':
    pass
