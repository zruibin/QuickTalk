#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# searchUser.py
#
# Created by ruibin.chow on 2017/12/18.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""
搜索用户(手机号码或昵称)
"""

from service.quickTalk.search import search
from module.database import DB
from module.log.Log import Loger
from config import *
from common.code import *
from common.tools import getValueFromRequestByKey, parsePageIndex, limit, fullPathForMediasFile, userAvatarURL
from service.quickTalk.star.queryStarUserRelation import queryStarUserRelation


@search.route('/searchUser', methods=["GET", "POST"])
def searchUser():
    text = getValueFromRequestByKey("text")
    index = getValueFromRequestByKey("index")
    index = parsePageIndex(index)
    size = getValueFromRequestByKey("size")
    userUUID = getValueFromRequestByKey("user_uuid")

    if text == None:
        return RESPONSE_JSON(CODE_ERROR_MISS_PARAM)

    return __queryUserFromStorage(text, index, size, userUUID)


def __queryUserFromStorage(text, index, size, userUUID):
    limitSQL = limit(index)
    if size is not None: limitSQL = limit(index, int(size))

    searchText = "%" + text + "%"
    querySQL = """
        SELECT uuid, t_quickTalk_user.id, nickname, avatar, phone, email, detail,   
            gender, qq, weibo, wechat, area, time
        FROM t_quickTalk_user WHERE nickname LIKE %s OR phone LIKE %s 
    """ + limitSQL
    # print querySQL

    dbManager = DB.DBManager.shareInstanced()
    try: 
        dataList = dbManager.executeSingleQueryWithArgs(querySQL, [searchText, searchText])

        dataDict = {}
        if userUUID != None:
            uuidList = []
            for data in dataList:
                uuidList.append(data["uuid"])
            # print uuidList, userUUID
            dataDict = queryStarUserRelation(userUUID, uuidList)
        print dataDict

        for data in dataList:
            uuid = data["uuid"]
            data["time"] = str(data["time"])
            data["avatar"] = userAvatarURL(uuid, data["avatar"])
            if userUUID != None:
                if dataDict.has_key(uuid):
                    data["relation"] = 1
                else:
                    data["relation"] = 0

        return RESPONSE_JSON(CODE_SUCCESS, data=dataList)
    except Exception as e:
        Loger.error(e, __file__)
        return RESPONSE_JSON(CODE_ERROR_SERVICE)




if __name__ == '__main__':
    pass
