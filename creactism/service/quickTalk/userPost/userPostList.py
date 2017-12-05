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

    return __getuserPostFromStorage(index, size, userUUID)


def __getuserPostFromStorage(index, size, userUUID):
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
        for data in dataList:
            userUUID = data["userUUID"]
            data["time"] = str(data["time"])
            data["avatar"] = userAvatarURL(userUUID, data["avatar"])
        return RESPONSE_JSON(CODE_SUCCESS, dataList)
    except Exception as e:
        Loger.error(e, __file__)
        return RESPONSE_JSON(CODE_ERROR_SERVICE)
    

if __name__ == '__main__':
    pass


