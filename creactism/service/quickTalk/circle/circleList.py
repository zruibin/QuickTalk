#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# circleList.py
#
# Created by ruibin.chow on 2017/11/07.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""
圈子列表
"""

from service.quickTalk import quickTalk
from module.database import DB
from module.log.Log import Loger
from config import *
from common.code import *
from common.tools import getValueFromRequestByKey, parsePageIndex, limit, fullPathForMediasFile, userAvatarURL


@quickTalk.route('/circle/circleList', methods=["GET", "POST"])
def circleList():
    userUUID = getValueFromRequestByKey("user_uuid")
    index = getValueFromRequestByKey("index")
    index = parsePageIndex(index)
    size = getValueFromRequestByKey("size")

    return __getCircleListFromStorage(userUUID, index, size)


def __getCircleListFromStorage(userUUID, index, size):
    limitSQL = limit(index)
    if size is not None: limitSQL = limit(index, int(size))
    querySQL = """
        SELECT id, uuid, user_uuid AS userUUID,
        (SELECT avatar FROM t_quickTalk_user WHERE t_quickTalk_user.uuid=user_uuid) AS avatar,
        content, time, `like` FROM t_quickTalk_circle ORDER BY time DESC %s
    """ % limitSQL
    if userUUID is not None:
        querySQL = """
            SELECT id, uuid, user_uuid AS userUUID,
            (SELECT avatar FROM t_quickTalk_user WHERE t_quickTalk_user.uuid=user_uuid) AS avatar,
            content, time, `like` FROM t_quickTalk_circle WHERE user_uuid='%s' ORDER BY time DESC %s
        """ % (userUUID, limitSQL)
    print querySQL

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
