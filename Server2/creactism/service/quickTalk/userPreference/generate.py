#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# generate.py
#
# Created by ruibin.chow on 2018/02/07.
# Copyright (c) 2018年 ruibin.chow All rights reserved.
# 

"""

"""
from module.log.Log import Loger
from config import *
from common.code import *
from common.tools import getValueFromRequestByKey
from module.cache.RuntimeCache import CacheManager
import json
from collections import OrderedDict  


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


def updateUserReadingCache(userUUID, userPostUUID):
    """阅读触发，已阅读的放于推荐队尾"""
    if userUUID == None or userPostUUID == None:
        return

    try: 
        readingCacheList = [] #个人阅读记录缓存
        readingCacheString = CacheManager.shareInstanced().getStringCache(Config.CACHE_PREFIX_reading_cache+userUUID)
        if readingCacheString != None:
            readingCacheList = json.loads(readingCacheString)
        
        if userPostUUID in readingCacheList:
            readingCacheList.remove(userPostUUID)
        readingCacheList.append(userPostUUID)

        readingCacheString = json.dumps(readingCacheList)
        CacheManager.shareInstanced().setStringCache(Config.CACHE_PREFIX_reading_cache+userUUID, readingCacheString)
    except Exception as e:
        Loger.error(e, __file__)
    



if __name__ == '__main__':
    pass
