#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# info.py
#
# Created by ruibin.chow on 2017/08/10.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""
个人详细信息
"""

from service.quickTalk.account import account
from module.database import DB
from module.log.Log import Loger
from config import *
from common.code import *
from common.auth import vertifyTokenHandle
from common.tools import getValueFromRequestByKey, userAvatarURL


@account.route('/info', methods=["GET", "POST"])
def info():
    userUUID = getValueFromRequestByKey("user_uuid")
    if userUUID == None: return RESPONSE_JSON(CODE_ERROR_MISS_PARAM)
    dataDict = __getUserBaseInfo(userUUID)
    if dataDict == None:
        return RESPONSE_JSON(CODE_ERROR_SERVICE)
    else:
        return RESPONSE_JSON(CODE_SUCCESS, data=dataDict)
    

def __getUserBaseInfo(userUUID):
    dataDict = None
    querySQL = """ 
    SELECT uuid, t_quickTalk_user.id, nickname, avatar, phone, email, detail,   
            gender, qq, weibo, wechat, area
    FROM t_quickTalk_user WHERE uuid=%s 
    """
    args = [userUUID]

    dbManager = DB.DBManager.shareInstanced()
    try: 
        rows = dbManager.executeSingleQueryWithArgs(querySQL, args)
        dataDict  = rows[0]
        avatar = dataDict["avatar"].strip()
        if len(avatar) > 0:
            avatar = userAvatarURL(userUUID, avatar)
            dataDict["avatar"] = avatar
    except Exception as e:
            Loger.error(e, __file__)

    return dataDict
    

if __name__ == '__main__':
    pass
