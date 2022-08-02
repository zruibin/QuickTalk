#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# myCommentList.py
#
# Created by ruibin.chow on 2017/11/08.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""
我的评论列表
"""

from . import news
from module.database import DB
from module.log.Log import Loger
from config import *
from common.code import *
from common.tools import getValueFromRequestByKey, parsePageIndex, limit, fullPathForMediasFile, userAvatarURL


@news.route('/myCommentList', methods=["GET", "POST"])
def myCommentList():
    userUUID = getValueFromRequestByKey("user_uuid")
    index = getValueFromRequestByKey("index")
    index = parsePageIndex(index)
    size = getValueFromRequestByKey("size")

    if userUUID == None:
        return RESPONSE_JSON(CODE_ERROR_MISS_PARAM) 

    return __getMyCommentListFromStorage(userUUID, index, size)


def __getMyCommentListFromStorage(userUUID, index, size):
    limitSQL = limit(index)
    if size is not None: limitSQL = limit(index, int(size))
    querySQL = """
        SELECT id, uuid, user_uuid AS userUUID, topic_uuid AS topicUUID, 
        (SELECT avatar FROM t_quickTalk_user WHERE t_quickTalk_user.uuid=user_uuid) AS avatar,
        (SELECT title FROM t_quickTalk_topic WHERE t_quickTalk_topic.uuid=topic_uuid) AS title,
        content, time, `like`, dislike FROM t_quickTalk_topic_comment WHERE user_uuid='%s' ORDER BY time DESC %s
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
