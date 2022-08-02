#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# recommendUserPostList.py
#
# Created by ruibin.chow on 2018/01/08.
# Copyright (c) 2018年 ruibin.chow All rights reserved.
# 

"""
推荐userPost列表
"""

from . import userPost
from module.database import DB
from module.log.Log import Loger
from config import *
from common.code import *
from common.tools import getValueFromRequestByKey, parsePageIndex, limit, fullPathForMediasFile, userAvatarURL
from ..like.queryLikeRelation import queryLikeRelation
from .userPostList import queryTheUserPostIsLiked, queryPackageUserPostLikeList, queryTheUserPostTagList
from module.cache.RuntimeCache import CacheManager
import json
from collections import OrderedDict


@userPost.route('/recommendUserPostList', methods=["GET", "POST"])
def recommendUserPostList():
    relationUserUUID = getValueFromRequestByKey("relation_user_uuid")
    index = getValueFromRequestByKey("index")
    index = parsePageIndex(index)
    size = getValueFromRequestByKey("size")

    return __getRecommendUserPostFromStorage(index, size, relationUserUUID)


def __getRecommendUserPostFromStorage(index, size, relationUserUUID):
    # limitSQL = limit(index)
    # if size is not None: limitSQL = limit(index, int(size))
    userPostCacheList = __getRecommendUserPostFromCache(index, Config.PAGE_OF_SIZE, relationUserUUID)
    if len(userPostCacheList) == 0:
        return RESPONSE_JSON(CODE_SUCCESS, None) 

    inString = "'" + "','".join(userPostCacheList) + "'"
    querySQL = """
        SELECT id, uuid, title, content, read_count AS readCount, time,
        user_uuid AS userUUID, txt, type,
        (SELECT t_quickTalk_user.id FROM t_quickTalk_user WHERE t_quickTalk_user.uuid=t_quickTalk_userPost.user_uuid) AS userId,
        (SELECT nickname FROM t_quickTalk_user WHERE t_quickTalk_user.uuid=t_quickTalk_userPost.user_uuid) AS nickname,
        (SELECT avatar FROM t_quickTalk_user WHERE t_quickTalk_user.uuid=t_quickTalk_userPost.user_uuid) AS avatar,
        (SELECT COUNT(t_quickTalk_userPost_comment.uuid) FROM t_quickTalk_userPost_comment WHERE userPost_uuid=t_quickTalk_userPost.uuid) AS commentCount
        FROM t_quickTalk_userPost WHERE t_quickTalk_userPost.uuid IN (%s) 
        ORDER BY INSTR('%s', uuid);
    """ % (inString, ",".join(userPostCacheList))
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
        dataList = queryTheUserPostTagList(dataList, uuidList)
        return RESPONSE_JSON(CODE_SUCCESS, dataList)
    except Exception as e:
        Loger.error(e, __file__)
        return RESPONSE_JSON(CODE_ERROR_SERVICE)


def __getRecommendUserPostFromCache(index, size, relationUserUUID):
    start = (index-1) * size
    end = index * size 

    #所有userPost字典json，按时间倒序
    userPostTagString = CacheManager.shareInstanced().getStringCache(Config.CACHE_PREFIX_userPost_tag)
    userPostTagOrderDict = json.loads(userPostTagString, object_pairs_hook=OrderedDict)
    userPostUUIDList = userPostTagOrderDict.keys()
    if relationUserUUID == None:
        if start > len(userPostUUIDList):
            return []
        if end > len(userPostUUIDList):
            end = -1
        return userPostUUIDList[start:end]

    # 用户个人行为偏好分析所得的userPost列表
    key = Config.CACHE_PREFIX_userPost_recommend + relationUserUUID
    userRecommendUserPostList = CacheManager.shareInstanced().getListCache(key)

    readingCacheList = [] #个人阅读记录缓存
    readingCacheString = CacheManager.shareInstanced().getStringCache(Config.CACHE_PREFIX_reading_cache+relationUserUUID)
    if readingCacheString != None:
        readingCacheList = json.loads(readingCacheString)

    recommendUserPostList = []
    for uuid in userRecommendUserPostList:
        if uuid not in readingCacheList:
            recommendUserPostList.append(uuid)
        
    recommendUserPostList.extend(readingCacheList)
    
    if start > len(recommendUserPostList):
            return []
    if end > len(recommendUserPostList):
        end = -1

    return recommendUserPostList[start:end]
    
    

if __name__ == '__main__':
    pass


