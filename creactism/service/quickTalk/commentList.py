#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# commentList.py
#
# Created by ruibin.chow on 2017/10/11.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""
评论列表
"""

from service.quickTalk import quickTalk
from module.database import DB
from module.log.Log import Loger
from config import *
from common.code import *
from common.tools import getValueFromRequestByKey, parsePageIndex, limit, fullPathForMediasFile


@quickTalk.route('/commentList', methods=["GET", "POST"])
def commentList():
    topicUUID = getValueFromRequestByKey("topic_uuid")
    index = getValueFromRequestByKey("index")
    index = parsePageIndex(index)

    if topicUUID == None:
        return RESPONSE_JSON(CODE_ERROR_MISS_PARAM) 

    return __getCommentListFromStorage(topicUUID, index)


def __getCommentListFromStorage(topicUUID, index):
    limitSQL = limit(index)
    querySQL = """
        SELECT id, uuid, user_uuid AS userUUID, topic_uuid AS topicUUID, 
        (SELECT avatar FROM t_quickTalk_user WHERE t_quickTalk_user.uuid=user_uuid) AS avatar,
        content, time, `like`, dislike FROM t_quickTalk_topic_comment WHERE topic_uuid='%s' ORDER BY time DESC %s
    """ % (topicUUID, limitSQL)
    # print querySQL

    dbManager = DB.DBManager.shareInstanced()
    try: 
        dataList = dbManager.executeSingleQuery(querySQL)
        for data in dataList:
            data["time"] = str(data["time"])
            data["avatar"] = fullPathForMediasFile(Config.UPLOAD_FILE_FOR_USER, data["userUUID"], data["avatar"])
        return RESPONSE_JSON(CODE_SUCCESS, dataList)
    except Exception as e:
        Loger.error(e, __file__)
        return RESPONSE_JSON(CODE_ERROR_SERVICE)


if __name__ == '__main__':
    pass
