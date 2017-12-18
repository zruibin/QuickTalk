#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# phoneListUsers.py
#
# Created by ruibin.chow on 2017/12/18.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""

"""

from service.quickTalk.user import user
from module.database import DB
from module.log.Log import Loger
from config import *
from common.code import *
from common.tools import getValueFromRequestByKey, parsePageIndex, limit, fullPathForMediasFile, userAvatarURL
from service.quickTalk.star.queryStarUserRelation import queryStarUserRelation
import json


@user.route('/phoneListUsers', methods=["GET", "POST"])
def phoneListUsers():
    phoneList = getValueFromRequestByKey("phoneList")
    userUUID = getValueFromRequestByKey("user_uuid")

    if phoneList == None:
        return RESPONSE_JSON(CODE_ERROR_MISS_PARAM)

    try:
        phoneList = json.loads(phoneList)
    except Exception as e:
        Loger.error(e, __file__)
        return RESPONSE_JSON(CODE_ERROR_ILLEGAL_DATA_CONTENT)

    return __queryUserFromStorage(phoneList, userUUID)


def __queryUserFromStorage(phoneList, userUUID):
    inString = "'" + "','".join(phoneList) + "'"
    querySQL = """
        SELECT uuid, t_quickTalk_user.id, nickname, avatar, phone, email, detail,   
            gender, qq, weibo, wechat, area, time
        FROM t_quickTalk_user WHERE phone IN (%s) ORDER BY INSTR('%s', phone);
    """ % (inString, ",".join(phoneList))

    # print querySQL

    dbManager = DB.DBManager.shareInstanced()
    try: 
        dataList = dbManager.executeTransactionQuery(querySQL)

        dataDict = {}
        if userUUID != None:
            fansUUIDList = []
            for data in dataList:
                fansUUIDList.append(data["uuid"])
            dataDict = queryStarUserRelation(userUUID, fansUUIDList)
            # print dataDict

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
