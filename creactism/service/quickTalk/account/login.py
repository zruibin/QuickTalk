#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# login.py
#
# Created by ruibin.chow on 2017/10/12.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""
登录
"""

from . import account
from module.database import DB
from module.log.Log import Loger
from config import *
from common.code import *
from common.tools import getValueFromRequestByKey, generateUUID, generateCurrentTime, userAvatarURL, md5hex, makeCookie
from common.auth import vertifyTokenHandle, generateToken, cacheToken
from .register import createNewUserOperation


@account.route('/login', methods=["POST"])
def login():
    accountStr = getValueFromRequestByKey("account")
    password = getValueFromRequestByKey("password")
    typeStr = getValueFromRequestByKey("type")
    # print account, password, typeStr
    if  accountStr is None:
            return RESPONSE_JSON(CODE_ERROR_MISS_PARAM)

    # 检查参数是否为空
    if typeStr in (Config.TYPE_FOR_EMAIL, Config.TYPE_FOR_PHONE):
        if accountStr == None or password == None:
            return RESPONSE_JSON(CODE_ERROR_MISS_PARAM)
        else:
            password = md5hex(password) # md5加密后
            return __loginForUserAndPassword(accountStr, typeStr, password)
    if typeStr in (Config.TYPE_FOR_AUTH_WECHAT, Config.TYPE_FOR_AUTH_QQ, Config.TYPE_FOR_AUTH_WEIBO):
        authOpenId = accountStr
        return __loginForThirdAuth(typeStr, authOpenId)
        


def __loginForUserAndPassword(accountStr, typeStr, password):
    typeDict = {Config.TYPE_FOR_EMAIL : "email",
        Config.TYPE_FOR_PHONE : "phone"
    }
    querySQL = """
        SELECT uuid, t_quickTalk_user.id, nickname, avatar, phone, email, detail,   
            gender, qq, weibo, wechat, area, password
        FROM t_quickTalk_user, t_quickTalk_user_auth 
        WHERE t_quickTalk_user."""+ typeDict[typeStr] +"""=%s 
            AND t_quickTalk_user_auth.password=%s
            AND t_quickTalk_user_auth.user_uuid=t_quickTalk_user.uuid; 
        """

    dbManager = DB.DBManager.shareInstanced()
    try: 
        resultData = dbManager.executeSingleQueryWithArgs(querySQL, [accountStr, password])
        if len(resultData) > 0:
            return __cacheUserDataWithToken(resultData[0])
        else:
            # 登录失败
            if typeStr == Config.TYPE_FOR_EMAIL:
                return RESPONSE_JSON(CODE_ERROR_EMAIL_OR_PASSWORD_ERROR)
            else:
                return RESPONSE_JSON(CODE_ERROR_PHONE_OR_PASSWORD_ERROR)
    except Exception as e:
        Loger.error(e, __file__)
        return RESPONSE_JSON(CODE_ERROR_SERVICE)
    else:
        return RESPONSE_JSON(CODE_SUCCESS)


def __loginForThirdAuth(typeStr, authOpenId):
    typeDict = {Config.TYPE_FOR_AUTH_WECHAT : "wechat",
        Config.TYPE_FOR_AUTH_QQ : "qq", Config.TYPE_FOR_AUTH_WEIBO : "weibo"
    }
    querySQL = """
        SELECT uuid, id, nickname, avatar, phone, email, detail, gender, qq, weibo, wechat, area
        FROM t_quickTalk_user
        WHERE """ + typeDict[typeStr] + """=%s; """

    dbManager = DB.DBManager.shareInstanced()
    try: 
        resultData = dbManager.executeSingleQueryWithArgs(querySQL, [authOpenId])
        if len(resultData) > 0:
            return __cacheUserDataWithToken(resultData[0])
        else:
            # 登录不存在用户则注册新用户，调用register模块的createNewUserOperation
            return createNewUserOperation(authType=typeStr, authOpenId=authOpenId)
    except Exception as e:
        Loger.error(e, __file__)
        return RESPONSE_JSON(CODE_ERROR_SERVICE)
    else:
        return RESPONSE_JSON(CODE_SUCCESS)


def __cacheUserDataWithToken(resultData):
    try:
        userUUID = resultData["uuid"]
        token = generateToken(userUUID)
        if token == None or cacheToken(userUUID, token) == False: 
                return RESPONSE_JSON(CODE_ERROR_TOKEN_CACHE_FAIL)
        avatar = resultData["avatar"].strip()
        if len(avatar) > 0:
            avatar = userAvatarURL(userUUID, avatar)
            resultData["avatar"] = avatar
        resultData["token"] = token
        response = RESPONSE_JSON(CODE_SUCCESS, data=resultData)
        response = makeCookie(response, "token", token)
        return response
    except Exception as e:
        Loger.error(e, __file__)
        raise e


if __name__ == '__main__':
    pass
