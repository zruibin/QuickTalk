#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# starUserPostList.py
#
# Created by ruibin.chow on 2017/12/25.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""
关注的用户的userPost列表
"""

from service.quickTalk.userPost import userPost
from module.database import DB
from module.log.Log import Loger
from config import *
from common.code import *
from common.tools import getValueFromRequestByKey, parsePageIndex, limit, fullPathForMediasFile, userAvatarURL
from service.quickTalk.like.queryLikeRelation import queryLikeRelation
from service.quickTalk.userPost.userPostList import queryTheUserPostIsLiked, queryPackageUserPostLikeList
from common.auth import vertifyTokenHandle


@userPost.route('/starUserPostList', methods=["GET", "POST"])
@vertifyTokenHandle
def starUserPostList():
    userUUID = getValueFromRequestByKey("user_uuid")
    relationUserUUID = getValueFromRequestByKey("relation_user_uuid")
    index = getValueFromRequestByKey("index")
    index = parsePageIndex(index)
    size = getValueFromRequestByKey("size")

    if userUUID == None:
        return RESPONSE_JSON(CODE_ERROR_MISS_PARAM)

    return __getUserPostFromStorage(index, size, userUUID, relationUserUUID)


def __getUserPostFromStorage(index, size, userUUID, relationUserUUID):
    limitSQL = limit(index)
    if size is not None: limitSQL = limit(index, int(size))
        
    querySQL = """
            SELECT id, uuid, title, content, read_count AS readCount, time,
            user_uuid AS userUUID, txt,
            (SELECT t_quickTalk_user.id FROM t_quickTalk_user WHERE t_quickTalk_user.uuid=t_quickTalk_userPost.user_uuid) AS userId,
            (SELECT nickname FROM t_quickTalk_user WHERE t_quickTalk_user.uuid=t_quickTalk_userPost.user_uuid) AS nickname,
            (SELECT avatar FROM t_quickTalk_user WHERE t_quickTalk_user.uuid=t_quickTalk_userPost.user_uuid) AS avatar,
            (SELECT COUNT(t_quickTalk_userPost_comment.uuid) FROM t_quickTalk_userPost_comment WHERE userPost_uuid=t_quickTalk_userPost.uuid) AS commentCount
            FROM t_quickTalk_userPost 
            WHERE user_uuid IN (
                SELECT t_quickTalk_user_user.other_user_uuid 
                FROM t_quickTalk_user_user 
                WHERE t_quickTalk_user_user.user_uuid='%s'
            ) 
            ORDER BY time DESC %s
        """ % (userUUID, limitSQL)
        
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
        dataList = queryTheUserPostIsLiked(dataList, uuidList, relationUserUUID)
        dataList = queryPackageUserPostLikeList(dataList, uuidList)
        return RESPONSE_JSON(CODE_SUCCESS, dataList)
    except Exception as e:
        Loger.error(e, __file__)
        return RESPONSE_JSON(CODE_ERROR_SERVICE)

    

if __name__ == '__main__':
    pass
