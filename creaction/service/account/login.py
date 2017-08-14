#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# login.py
#
# Created by ruibin.chow on 2017/08/14.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""
用户登录
"""
from service.account import account
from flask import Flask, Response, request
from module.database import DB
from module.log.Log import Loger
from config import *
from common.code import *
from common.tools import getValueFromRequestByKey, md5hex, generateUUID, generateCurrentTime
from module.cache.RuntimeCache import CacheManager
from common.auth import generateToken, cacheToken
from service.account.register import createNewUserOperation


@account.route('/login', methods=["POST"])
def login():
    accountStr = getValueFromRequestByKey("account")
    password = getValueFromRequestByKey("password")
    typeStr = getValueFromRequestByKey("type")
    authOpenId = getValueFromRequestByKey("authOpenId")

    # 检查参数是否为空
    if typeStr in (Config.TYPE_FOR_EMAIL, Config.TYPE_FOR_PHONE):
        if accountStr == None or password == None:
            return RESPONSE_JSON(CODE_ERROR_MISS_PARAM)
        else:
            password = md5hex(password) # md5加密后
            return loginForUserAndPassword(accountStr, typeStr, password)
    if typeStr in (Config.TYPE_FOR_AUTH_WECHAT, Config.TYPE_FOR_AUTH_QQ, Config.TYPE_FOR_AUTH_WEIBO):
        if  authOpenId is None:
            return RESPONSE_JSON(CODE_ERROR_MISS_PARAM)
        else:
            return loginForThirdAuth(typeStr, authOpenId)
        


def loginForUserAndPassword(accountStr, typeStr, password):
    typeDict = {Config.TYPE_FOR_EMAIL : "email",
        Config.TYPE_FOR_PHONE : "phone"
    }
    querySQL = """
        SELECT t_user.uuid, t_user.id, t_user.nickname, t_user.avatar, t_user.phone, t_user.email,
         t_user.contact_phone, t_user.contact_email, t_user.qq, t_user.weibo, t_user.wechat,
        t_user_auth.password, t_user_auth.qq AS authQQ, t_user_auth.wechat AS authWechat, t_user_auth.weibo AS authWeibo
        FROM t_user, t_user_auth 
        WHERE t_user.%s='%s' AND t_user_auth.password='%s' 
        AND t_user_auth.user_uuid=t_user.uuid; 
        """ % (typeDict[typeStr], accountStr, password)
    
    dbManager = DB.DBManager.shareInstanced()
    try: 
        resultData = dbManager.executeSingleQuery(querySQL)
        if len(resultData) > 0:
            return cacheUserDataWithToken(resultData[0])
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


def loginForThirdAuth(typeStr, authOpenId):
    typeDict = {Config.TYPE_FOR_AUTH_WECHAT : "wechat",
        Config.TYPE_FOR_AUTH_QQ : "qq", Config.TYPE_FOR_AUTH_WEIBO : "weibo"
    }
    querySQL = """
        SELECT t_user.uuid, t_user.id, t_user.nickname, t_user.avatar, t_user.phone, t_user.email,
         t_user.contact_phone, t_user.contact_email, t_user.qq, t_user.weibo, t_user.wechat,
        t_user_auth.password, t_user_auth.qq AS authQQ, t_user_auth.wechat AS authWechat, t_user_auth.weibo AS authWeibo
        FROM t_user, t_user_auth 
        WHERE t_user.uuid=t_user_auth.user_uuid 
        AND t_user_auth.%s='%s'; """ % (typeDict[typeStr], authOpenId)
    dbManager = DB.DBManager.shareInstanced()
    try: 
        resultData = dbManager.executeSingleQuery(querySQL)
        if len(resultData) > 0:
            return cacheUserDataWithToken(resultData[0])
        else:
            # 登录不存在用户则注册新用户，调用register模块的createNewUserOperation
            return createNewUserOperation(authType=typeStr, authOpenId=authOpenId)
    except Exception as e:
        Loger.error(e, __file__)
        return RESPONSE_JSON(CODE_ERROR_SERVICE)
    else:
        return RESPONSE_JSON(CODE_SUCCESS)


def cacheUserDataWithToken(resultData):
    try:
        userUUID = resultData["uuid"]
        token = generateToken(userUUID)
        if token == None or cacheToken(userUUID, token) == False: 
                return RESPONSE_JSON(CODE_ERROR_TOKEN_CACHE_FAIL)
        dataDict = {
            "token": token,
            "uuid": userUUID,
            "id": resultData["id"],
            "nickname": resultData["nickname"],
            "avatar": resultData["avatar"],
            "phone": resultData["phone"],
            "email": resultData["email"],
            "password": resultData["password"],
            "authQQ": resultData["authQQ"], 
            "authWechat":resultData["authWechat"], 
            "authWeibo":resultData["authWeibo"],
            "contactPhone" : resultData["contact_phone"],
            "contactEmail" : resultData["contact_email"],
            "contactQQ" : resultData["qq"],
            "contactWeibo" : resultData["weibo"],
            "contactWechat" : resultData["wechat"]
        }
        response = RESPONSE_JSON(CODE_SUCCESS, data=dataDict)
        response.set_cookie('token', token)
        return response
    except Exception as e:
        Loger.error(e, __file__)
        raise e


if __name__ == '__main__':
    pass
