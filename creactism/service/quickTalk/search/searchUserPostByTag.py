#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# searchUserPostByTag.py
#
# Created by ruibin.chow on 2018/01/16.
# Copyright (c) 2018年 ruibin.chow All rights reserved.
# 

"""
搜索拥有标签的userPost
"""

from . import search
from module.database import DB
from module.log.Log import Loger
from config import *
from common.code import *
from common.tools import getValueFromRequestByKey, parsePageIndex, limit, fullPathForMediasFile, userAvatarURL
from ..like.queryLikeRelation import queryLikeRelation
from ..userPost.userPostList import queryTheUserPostIsLiked, queryPackageUserPostLikeList, queryTheUserPostTagList


@search.route('/searchUserPostByTag', methods=["GET", "POST"])
def searchUserPostByTag():
    userUUID = getValueFromRequestByKey("user_uuid")
    tag = getValueFromRequestByKey("tag")
    index = getValueFromRequestByKey("index")
    index = parsePageIndex(index)
    size = getValueFromRequestByKey("size")

    if tag == None:
        return RESPONSE_JSON(CODE_ERROR_MISS_PARAM)

    return __getUserPostFromStorage(tag, userUUID, index, size)


def __getUserPostFromStorage(tag, userUUID, index, size):
    limitSQL = limit(index)
    if size is not None: limitSQL = limit(index, int(size))
    
    searchText = "%" + tag + "%"
    querySQL = """
            SELECT id, uuid, title, content, read_count AS readCount, time,
            user_uuid AS userUUID, txt,
            (SELECT t_quickTalk_user.id FROM t_quickTalk_user WHERE t_quickTalk_user.uuid=t_quickTalk_userPost.user_uuid) AS userId,
            (SELECT nickname FROM t_quickTalk_user WHERE t_quickTalk_user.uuid=t_quickTalk_userPost.user_uuid) AS nickname,
            (SELECT avatar FROM t_quickTalk_user WHERE t_quickTalk_user.uuid=t_quickTalk_userPost.user_uuid) AS avatar,
            (SELECT COUNT(t_quickTalk_userPost_comment.uuid) FROM t_quickTalk_userPost_comment WHERE userPost_uuid=t_quickTalk_userPost.uuid) AS commentCount
            FROM t_quickTalk_userPost 
            WHERE t_quickTalk_userPost.uuid IN (
                SELECT userPost_uuid FROM 
                (SELECT userPost_uuid FROM `t_tag_userPost` 
                    WHERE tag LIKE %s """ + limitSQL + """
                ) AS t_temp
            )
            ORDER BY t_quickTalk_userPost.time DESC
        """
        
    # DLog(querySQL, False)

    dbManager = DB.DBManager.shareInstanced()
    try: 
        dataList = dbManager.executeSingleQueryWithArgs(querySQL, [searchText])
        uuidList = []
        for data in dataList:
            uuidList.append(data["uuid"])
            userUUID = data["userUUID"]
            data["time"] = str(data["time"])
            data["avatar"] = userAvatarURL(userUUID, data["avatar"])
        dataList = queryTheUserPostIsLiked(dataList, uuidList, userUUID)
        dataList = queryPackageUserPostLikeList(dataList, uuidList)
        dataList = queryTheUserPostTagList(dataList, uuidList)
        return RESPONSE_JSON(CODE_SUCCESS, dataList)
    except Exception as e:
        Loger.error(e, __file__)
        return RESPONSE_JSON(CODE_ERROR_SERVICE)


if __name__ == '__main__':
    pass
