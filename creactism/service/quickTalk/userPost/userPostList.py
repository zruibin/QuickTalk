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

from service.quickTalk.userPost import userPost
from module.database import DB
from module.log.Log import Loger
from config import *
from common.code import *
from common.tools import getValueFromRequestByKey, parsePageIndex, limit, fullPathForMediasFile, userAvatarURL


@userPost.route('/userPostList', methods=["GET", "POST"])
def userPostList():
    userUUID = getValueFromRequestByKey("user_uuid")
    index = getValueFromRequestByKey("index")
    index = parsePageIndex(index)
    size = getValueFromRequestByKey("size")

    return __getUserPostFromStorage(index, size, userUUID)


def __getUserPostFromStorage(index, size, userUUID):
    limitSQL = limit(index)
    if size is not None: limitSQL = limit(index, int(size))
        
    querySQL = """
        SELECT id, uuid, title, content, read_count AS readCount, time,
        user_uuid AS userUUID, txt,
        (SELECT nickname FROM t_quickTalk_user WHERE t_quickTalk_user.uuid=t_quickTalk_userPost.user_uuid) AS nickname,
        (SELECT avatar FROM t_quickTalk_user WHERE t_quickTalk_user.uuid=t_quickTalk_userPost.user_uuid) AS avatar,
        (SELECT COUNT(t_quickTalk_userPost_comment.uuid) FROM t_quickTalk_userPost_comment WHERE userPost_uuid=t_quickTalk_userPost.uuid) AS commentCount
        FROM t_quickTalk_userPost ORDER BY time DESC %s
    """ % limitSQL
    if userUUID is not None:
        querySQL = """
            SELECT id, uuid, title, content, read_count AS readCount, time,
            user_uuid AS userUUID, txt,
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
        dataList = queryPackageUserPostLikeList(dataList, uuidList)
        return RESPONSE_JSON(CODE_SUCCESS, dataList)
    except Exception as e:
        Loger.error(e, __file__)
        return RESPONSE_JSON(CODE_ERROR_SERVICE)



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
        ORDER BY t_quickTalk_like.time DESC 
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



    
    

if __name__ == '__main__':
    pass


