#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# generateAll.py
#
# Created by ruibin.chow on 2018/02/06.
# Copyright (c) 2018年 ruibin.chow All rights reserved.
# 

"""

"""

from . import userPreference
from module.database import DB
from module.log.Log import Loger
from config import *
from common.code import *
from common.tools import getValueFromRequestByKey
from module.cache.RuntimeCache import CacheManager
import json
from collections import OrderedDict  


@userPreference.route('/generateAll', methods=["GET", "POST"])
def generateAll():
    
    try:
        # __generateAllUserPostToCache()
        # __generateAllUserPostTagToCache()
        # __generateAllUserForUserPostToCache()
        # __generateAllUserForLikeToCache()
        # __generateAllUserForCommentToCache()
        # __generateAllUserForCollectionToCache()
        # __generateAllUserForReadingToCache()
        generateUserRecommendList("fbd1d63882ff73751accacd39621fa9c")
        return RESPONSE_JSON(CODE_SUCCESS)
    except Exception as e:
        return RESPONSE_JSON(CODE_ERROR_SERVICE)


def __generateAllUserPostToCache():
    """"归并所有userPost进缓存"""
    querySQL = """
        SELECT uuid, time FROM t_quickTalk_userPost ORDER BY time DESC
    """
    dbManager = DB.DBManager.shareInstanced()
    try: 
        dataList = dbManager.executeTransactionQuery(querySQL)
        usePostList = []
        for data in dataList:
            # data["time"] = str(data["time"])
            usePostList.append(data["uuid"])
        CacheManager.shareInstanced().setListCache(Config.CACHE_PREFIX_userPost, usePostList)
    except Exception as e:
        Loger.error(e, __file__)
        raise e


def __generateAllUserPostTagToCache():
    """"归并所有userPost的标签进缓存"""
    querySQL = """
        SELECT userPost_uuid, tag, time FROM t_quickTalk_tag_userPost
        LEFT JOIN t_quickTalk_userPost
        ON t_quickTalk_userPost.uuid=t_quickTalk_tag_userPost.userPost_uuid
        ORDER BY time DESC
    """
    dbManager = DB.DBManager.shareInstanced()
    try: 
        dataList = dbManager.executeTransactionQuery(querySQL)
        userPostTagDict = OrderedDict()
        for data in dataList:
            # data["time"] = str(data["time"])
            key = data["userPost_uuid"]
            if userPostTagDict.has_key(key):
                userTagSet = userPostTagDict[key]
                userTagSet.add(data["tag"])
            else:
                userTagSet = set([data["tag"]])
                userPostTagDict[key] = userTagSet
        # DLog(userPostTagDict, True)
        def set_default(obj):
            if isinstance(obj, set):
                return list(obj)
            raise TypeError
        userPostTagString = json.dumps(userPostTagDict, default=set_default)
        CacheManager.shareInstanced().setStringCache(Config.CACHE_PREFIX_userPost_tag, userPostTagString)
    except Exception as e:
        Loger.error(e, __file__)
        raise e


def __generateAllUserForUserPostToCache():
    """归并每个用户的发表的标签"""
    querySQL = """
        SELECT uuid, user_uuid, tag FROM t_quickTalk_userPost LEFT JOIN t_quickTalk_tag_userPost ON userPost_uuid=uuid ORDER BY uuid
    """
    dbManager = DB.DBManager.shareInstanced()
    try: 
        dataList = dbManager.executeTransactionQuery(querySQL)
        userTagDict = {}
        for data in dataList:
            # data["time"] = str(data["time"])
            key = Config.CACHE_PREFIX_userPost_add + data["user_uuid"]
            if userTagDict.has_key(key):
                userTagSet = userTagDict[key]
                userTagSet.add(data["tag"])
            else:
                userTagSet = set([data["tag"]])
                userTagDict[key] = userTagSet
        # DLog(userTagDict, True)
        for key, value in userTagDict.items():
            CacheManager.shareInstanced().setListCache(key, value)
    except Exception as e:
        Loger.error(e, __file__)
        raise e


def __generateAllUserForLikeToCache():
    """归并每个用户的点赞的userPost所属的标签"""
    querySQL = """
        SELECT user_uuid, content_uuid, tag FROM t_quickTalk_like LEFT JOIN t_quickTalk_tag_userPost ON content_uuid=userPost_uuid
    """
    dbManager = DB.DBManager.shareInstanced()
    try: 
        dataList = dbManager.executeTransactionQuery(querySQL)
        userTagDict = {}
        for data in dataList:
            # data["time"] = str(data["time"])
            key = Config.CACHE_PREFIX_liked + data["user_uuid"]
            if userTagDict.has_key(key):
                userTagSet = userTagDict[key]
                userTagSet.add(data["tag"])
            else:
                userTagSet = set([data["tag"]])
                userTagDict[key] = userTagSet
        # DLog(userTagDict, True)
        for key, value in userTagDict.items():
            CacheManager.shareInstanced().setListCache(key, value)
    except Exception as e:
        Loger.error(e, __file__)
        raise e


def __generateAllUserForCommentToCache():
    """归并每个用户的评论的userPost所属的标签"""
    querySQL = """
        SELECT t_quickTalk_userPost_comment.user_uuid, t_quickTalk_userPost_comment.userPost_uuid, tag 
        FROM t_quickTalk_userPost_comment
        LEFT JOIN t_quickTalk_tag_userPost
        ON t_quickTalk_userPost_comment.userPost_uuid=t_quickTalk_tag_userPost.userPost_uuid
        ORDER BY t_quickTalk_userPost_comment.user_uuid
    """
    dbManager = DB.DBManager.shareInstanced()
    try: 
        dataList = dbManager.executeTransactionQuery(querySQL)
        userTagDict = {}
        for data in dataList:
            # data["time"] = str(data["time"])
            key = Config.CACHE_PREFIX_comment + data["user_uuid"]
            if userTagDict.has_key(key):
                userTagSet = userTagDict[key]
                userTagSet.add(data["tag"])
            else:
                userTagSet = set([data["tag"]])
                userTagDict[key] = userTagSet
        # DLog(userTagDict, True)
        for key, value in userTagDict.items():
            CacheManager.shareInstanced().setListCache(key, value)
    except Exception as e:
        Loger.error(e, __file__)
        raise e


def __generateAllUserForCollectionToCache():
    """归并每个用户收藏的userPost所属的标签"""
    querySQL = """
        SELECT t_quickTalk_collection.user_uuid, content_uuid, tag 
        FROM t_quickTalk_collection
        LEFT JOIN t_quickTalk_tag_userPost
        ON t_quickTalk_tag_userPost.userPost_uuid=t_quickTalk_collection.content_uuid
        ORDER BY t_quickTalk_collection.user_uuid
    """
    dbManager = DB.DBManager.shareInstanced()
    try: 
        dataList = dbManager.executeTransactionQuery(querySQL)
        userTagDict = {}
        for data in dataList:
            # data["time"] = str(data["time"])
            key = Config.CACHE_PREFIX_collection + data["user_uuid"]
            if userTagDict.has_key(key):
                userTagSet = userTagDict[key]
                userTagSet.add(data["tag"])
            else:
                userTagSet = set([data["tag"]])
                userTagDict[key] = userTagSet
        # DLog(userTagDict, True)
        for key, value in userTagDict.items():
            CacheManager.shareInstanced().setListCache(key, value)
    except Exception as e:
        Loger.error(e, __file__)
        raise e


def __generateAllUserForReadingToCache():
    """归并每个用户阅读的userPost所属的标签(可重复)"""
    querySQL = """
        SELECT t_quickTalk_user_read.user_uuid, uuid, tag 
        FROM t_quickTalk_user_read
        LEFT JOIN t_quickTalk_tag_userPost
        ON t_quickTalk_tag_userPost.userPost_uuid=t_quickTalk_user_read.uuid
        ORDER BY t_quickTalk_user_read.user_uuid
    """
    dbManager = DB.DBManager.shareInstanced()
    try: 
        dataList = dbManager.executeTransactionQuery(querySQL)
        userTagDict = {}
        for data in dataList:
            # data["time"] = str(data["time"])
            key = Config.CACHE_PREFIX_reading + data["user_uuid"]
            if userTagDict.has_key(key):
                userTagList = userTagDict[key]
                userTagList.append(data["tag"])
            else:
                userTagList = [data["tag"]]
                userTagDict[key] = userTagList
        # DLog(userTagDict, True)
        for key, value in userTagDict.items():
            CacheManager.shareInstanced().setListCache(key, value)
    except Exception as e:
        Loger.error(e, __file__)
        raise e


def generateUserRecommendList(userUUID):
    """"发表10、点赞2、评论4、收藏5、阅读1"""
    tagScoringDict = {}

    userPostListKey = Config.CACHE_PREFIX_userPost_add + userUUID
    userPostList = CacheManager.shareInstanced().getListCache(userPostListKey)
    for tag in userPostList: #计算发表的分值
        if tagScoringDict.has_key(tag):
            score = tagScoringDict[tag]
            score += 10
            tagScoringDict[tag] = score
        else:
            tagScoringDict[tag] = 10

    likedListKey = Config.CACHE_PREFIX_liked + userUUID
    likedList = CacheManager.shareInstanced().getListCache(likedListKey)
    for tag in likedList: #计算点赞的分值
        if tagScoringDict.has_key(tag):
            score = tagScoringDict[tag]
            score += 2
            tagScoringDict[tag] = score
        else:
            tagScoringDict[tag] = 2

    commentListKey = Config.CACHE_PREFIX_comment + userUUID
    commentList = CacheManager.shareInstanced().getListCache(commentListKey)
    for tag in commentList: #计算评论的分值
        if tagScoringDict.has_key(tag):
            score = tagScoringDict[tag]
            score += 4
            tagScoringDict[tag] = score
        else:
            tagScoringDict[tag] = 4

    collectionListKey = Config.CACHE_PREFIX_collection + userUUID
    collectionList = CacheManager.shareInstanced().getListCache(collectionListKey)
    for tag in collectionList: #计算收藏的分值
        if tagScoringDict.has_key(tag):
            score = tagScoringDict[tag]
            score += 5
            tagScoringDict[tag] = score
        else:
            tagScoringDict[tag] = 5

    readingListKey = Config.CACHE_PREFIX_reading + userUUID
    readingList = CacheManager.shareInstanced().getListCache(readingListKey)
    for tag in readingList: #计算阅读的分值
        if tagScoringDict.has_key(tag):
            score = tagScoringDict[tag]
            score += 1
            tagScoringDict[tag] = score
        else:
            tagScoringDict[tag] = 1

    # DLog(tagScoringDict, True)
    sortTagScoringList = sorted(tagScoringDict.items(), key=lambda d:d[1], reverse=True)
    userPreferenceList = [tagScoring[0] for tagScoring in sortTagScoringList]

    #所有userPost字典json，按时间倒序
    userPostTagString = CacheManager.shareInstanced().getStringCache(Config.CACHE_PREFIX_userPost_tag)
    userPostTagOrderDict = json.loads(userPostTagString, object_pairs_hook=OrderedDict)

    readingCacheList = [] #个人阅读记录缓存
    readingCacheString = CacheManager.shareInstanced().getStringCache(Config.CACHE_PREFIX_reading_cache+userUUID)
    if readingCacheString != None:
        readingCacheList = json.loads(readingCacheString)

    userRecommendUserPostList = [] #个人的推荐列表
    for tag in userPreferenceList:
        for key, value in userPostTagOrderDict.items():
            #用户计算的标签权值搜索并且未阅读过的，不重复
            if tag in value and key not in readingCacheList and key not in userRecommendUserPostList:
                userRecommendUserPostList.append(key)
    
    for key in userPostTagOrderDict.keys():
        #去除用户相关的标签的剩下的userPost并且未阅读过的，不重复
        if key not in readingCacheList and key not in userRecommendUserPostList:
            userRecommendUserPostList.append(key)
    
    #已阅读的放于最后
    userRecommendUserPostList.extend(readingCacheList)

    key = Config.CACHE_PREFIX_userPost_recommend + userUUID
    CacheManager.shareInstanced().setListCache(key, userRecommendUserPostList)
    # DLog(userRecommendUserPostList, True)
    # print len(userRecommendUserPostList)
    pass


if __name__ == '__main__':
    pass
