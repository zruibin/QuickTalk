#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# userPostList.py
#
# Created by ruibin.chow on 2017/12/04.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""
userPost列表
"""

from . import userPost
from module.database import DB
from module.log.Log import Loger
from config import *
from common.code import *
from common.tools import getValueFromRequestByKey, parsePageIndex, limit, fullPathForMediasFile, userAvatarURL
from service.quickTalk.like.queryLikeRelation import queryLikeRelation


@userPost.route('/userPostList', methods=["GET", "POST"])
def userPostList():
    userUUID = getValueFromRequestByKey("user_uuid")
    relationUserUUID = getValueFromRequestByKey("relation_user_uuid")
    index = getValueFromRequestByKey("index")
    index = parsePageIndex(index)
    size = getValueFromRequestByKey("size")

    return __getUserPostFromStorage(index, size, userUUID, relationUserUUID)


def __getUserPostFromStorage(index, size, userUUID, relationUserUUID):
    limitSQL = limit(index)
    if size is not None: limitSQL = limit(index, int(size))
        
    querySQL = """
        SELECT id, uuid, title, content, read_count AS readCount, time,
        user_uuid AS userUUID, txt, type,
        (SELECT t_quickTalk_user.id FROM t_quickTalk_user WHERE t_quickTalk_user.uuid=t_quickTalk_userPost.user_uuid) AS userId,
        (SELECT nickname FROM t_quickTalk_user WHERE t_quickTalk_user.uuid=t_quickTalk_userPost.user_uuid) AS nickname,
        (SELECT avatar FROM t_quickTalk_user WHERE t_quickTalk_user.uuid=t_quickTalk_userPost.user_uuid) AS avatar,
        (SELECT COUNT(t_quickTalk_userPost_comment.uuid) FROM t_quickTalk_userPost_comment WHERE userPost_uuid=t_quickTalk_userPost.uuid) AS commentCount
        FROM t_quickTalk_userPost ORDER BY time DESC %s
    """ % limitSQL
    if userUUID is not None:
        querySQL = """
            SELECT id, uuid, title, content, read_count AS readCount, time,
            user_uuid AS userUUID, txt, type,
            (SELECT t_quickTalk_user.id FROM t_quickTalk_user WHERE t_quickTalk_user.uuid=t_quickTalk_userPost.user_uuid) AS userId,
            (SELECT nickname FROM t_quickTalk_user WHERE t_quickTalk_user.uuid=t_quickTalk_userPost.user_uuid) AS nickname,
            (SELECT avatar FROM t_quickTalk_user WHERE t_quickTalk_user.uuid=t_quickTalk_userPost.user_uuid) AS avatar,
            (SELECT COUNT(t_quickTalk_userPost_comment.uuid) FROM t_quickTalk_userPost_comment WHERE userPost_uuid=t_quickTalk_userPost.uuid) AS commentCount
            FROM t_quickTalk_userPost WHERE user_uuid='%s' ORDER BY time DESC %s
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
        dataList = queryTheUserPostTagList(dataList, uuidList)
        return RESPONSE_JSON(CODE_SUCCESS, dataList)
    except Exception as e:
        Loger.error(e, __file__)
        return RESPONSE_JSON(CODE_ERROR_SERVICE)


def queryTheUserPostIsLiked(dataList, uuidList, relationUserUUID):
    if len(dataList) == 0 or relationUserUUID == None:
        return dataList
    # print uuidList, relationUserUUID
    try: 
        uuidList = queryLikeRelation(relationUserUUID, uuidList)
        for data in dataList:
            if data["uuid"] in uuidList:
                data["liked"] = 1
            else: 
                data["liked"] = 0
    except Exception as e:
        Loger.error(e, __file__)

    return dataList



def queryPackageUserPostLikeList(dataList, uuidList):
    """查询userPost列表里每个userPost的所有赞"""
    if len(dataList) == 0:
        return dataList

    inString = "'" + "','".join(uuidList) + "'"
    querySQL = """
        SELECT content_uuid AS userPostUUID, t_quickTalk_like.time,
        t_quickTalk_user.uuid AS userUUID, nickname, t_quickTalk_user.id AS userId, avatar
        FROM t_quickTalk_like INNER JOIN t_quickTalk_user
        ON type='%s' AND content_uuid IN (%s) 
        AND t_quickTalk_user.uuid=t_quickTalk_like.user_uuid
        ORDER BY t_quickTalk_like.time ASC 
    """ % (Config.TYPE_MESSAGE_LIKE_USERPOST, inString)
    # print querySQL

    dbManager = DB.DBManager.shareInstanced()
    try: 
        likeList = dbManager.executeSingleQuery(querySQL)
        # print likeList
        return __packageUserPostLike(dataList, likeList)
    except Exception as e:
        Loger.error(e, __file__)
        raise e


def __packageUserPostLike(dataList, likeList):
    if len(likeList) == 0:
        return dataList

    # 所有点赞归整于每条userPost上
    likeDict = {}
    for like in likeList:
        userPostUUID = like["userPostUUID"]
        del like["userPostUUID"]
        userUUID = like["userUUID"]
        like["time"] = str(like["time"])
        like["avatar"] = userAvatarURL(userUUID, like["avatar"])
        if likeDict.has_key(userPostUUID):
            likeDict[userPostUUID].append(like)
        else:
            likeDictList = [like]
            likeDict[userPostUUID] = likeDictList

    # print likeDict

    # 合并点赞
    for key, value in likeDict.items():
        for data in dataList:
            if data["uuid"] == key:
                data["likeList"] = value
        
    return dataList


def queryTheUserPostTagList(dataList, uuidList):
    """查询userPost列表里每个userPost的标签"""
    if len(dataList) == 0:
        return dataList

    inString = "'" + "','".join(uuidList) + "'"
    querySQL = """
        SELECT userPost_uuid AS userPostUUID, sorting, tag FROM t_quickTalk_tag_userPost
        WHERE userPost_uuid IN (%s);
    """ % (inString)
    # DLog(querySQL, False)

    dbManager = DB.DBManager.shareInstanced()
    try: 
        tagList = dbManager.executeSingleQuery(querySQL)
        # DLog(tagList)
        return __packageUserPostTags(dataList, tagList)
    except Exception as e:
        Loger.error(e, __file__)
        raise e


def __packageUserPostTags(dataList, tagList):
    if len(tagList) == 0:
        return dataList

    tagsDict = {}
    for tag in tagList:
        userPostUUID = tag["userPostUUID"]
        del tag["userPostUUID"]
        tagValue = tag["tag"]
        if tagsDict.has_key(userPostUUID):
            tagsDict[userPostUUID].append(tagValue)
        else:
            tagList = [tagValue]
            tagsDict[userPostUUID] = tagList
    # DLog(tagsDict)

    # 合并标签
    for key, value in tagsDict.items():
        for data in dataList:
            if data["uuid"] == key:
                data["tagList"] = value
    
    return dataList
    
    

if __name__ == '__main__':
    pass


