#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# register.py
#
# Created by ruibin.chow on 2017/08/08.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""
用户注册
"""

from service.quickTalk.account import account
from flask import Flask, Response, request
from module.database import DB
from module.cache.RuntimeCache import CacheManager
from module.log.Log import Loger
from config import *
from common.tools import getValueFromRequestByKey, generateUUID, generateCurrentTime, md5hex, userAvatarURL, makeCookie
from common.code import *
from common.auth import generateToken, cacheToken
from service.quickTalk.account.generalMethod import verifyEmailIsExists, verifyPhoneIsExists


@account.route("/register", methods=["POST"])
def register():                         
    accountStr = getValueFromRequestByKey("account")
    password = md5hex(getValueFromRequestByKey("password")) # md5后(32位)
    typeStr = getValueFromRequestByKey("type")

    # 参数没有直接报错返回
    if accountStr == None or password == None or typeStr == None:
        return RESPONSE_JSON(CODE_ERROR_MISS_PARAM)

    # 邮箱注册则看验证码是否过期或存在
    if typeStr == Config.TYPE_FOR_EMAIL:
        code = getValueFromRequestByKey("code")
        if code == None:
            return RESPONSE_JSON(CODE_ERROR_TEST_AND_VERIFY)
        else:
            code = CacheManager.shareInstanced().getCache(accountStr)
            if code == None:
                return RESPONSE_JSON(CODE_ERROR_VERIFY_CODE_OUTDATE)


    phone = ""
    email = ""
    #注册前要验证手机或email是否已使用了
    if typeStr == Config.TYPE_FOR_EMAIL: 
        email = accountStr
        result = verifyEmailIsExists(email)
        if result :  return RESPONSE_JSON(CODE_ERROR_THE_EMAIL_HAS_BE_USED)

    if typeStr == Config.TYPE_FOR_PHONE: 
        phone = accountStr
        result = verifyPhoneIsExists(phone)
        if result :  return RESPONSE_JSON(CODE_ERROR_THE_PHONE_HAS_BE_USED)

    response = createNewUserOperation(phone=phone, email=email, password=password)
    return response


def createNewUserOperation(password="", phone="", email="", authType="", authOpenId=""):
    try:
        # 生成用户的uuid
        userUUID = generateUUID()
        time = generateCurrentTime()

        # 用户数据入库
        if __operationDataStorage(userUUID, password, time, phone, email, authType, authOpenId) == False:
            return RESPONSE_JSON(CODE_ERROR_SERVICE)

        # 生成token并缓存
        token = generateToken(userUUID)
        if token == None or cacheToken(userUUID, token) == False: 
            return RESPONSE_JSON(CODE_ERROR_TOKEN_CACHE_FAIL)
        dataDict = __generateResponseData(userUUID, token)

        response = RESPONSE_JSON(CODE_SUCCESS, data=dataDict)
        response = makeCookie(response, "token", token)
        return response
    except Exception as e:
        Loger.error(e, __file__)
        return RESPONSE_JSON(CODE_ERROR_SERVICE)


def  __operationDataStorage(userUUID, password="", time="", phone="", email="", authType="", authOpenId=""):
    results = False
    typeContent = "qq"
    if len(authType) > 0:
        typeDict = {
                Config.TYPE_FOR_AUTH_WECHAT : "wechat",
                Config.TYPE_FOR_AUTH_QQ : "qq",
                Config.TYPE_FOR_AUTH_WEIBO : "weibo"
        }
        typeContent = typeDict[authType]

    try: 
        sqlList = []
        argsList = []
        userSQL = """ 
                INSERT INTO `t_quickTalk_user`(`uuid`, `phone`, `email`, `time`, `""" + typeContent + """`)
                VALUES(%s, %s, %s, %s, %s);
        """
        sqlList.append(userSQL)
        argsList.append([userUUID, phone, email, time, authOpenId])

        userAuthSQL = """
                INSERT INTO `t_quickTalk_user_auth`(`user_uuid`, `password`)
                VALUES(%s, %s);
                """
        sqlList.append(userAuthSQL)
        argsList.append([userUUID, password])

        userSettingSQL = """
                INSERT INTO t_quickTalk_user_setting (user_uuid, type, status) 
                VALUES (%s, %s, %s), (%s, %s, %s), (%s, %s, %s), (%s, %s, %s);
        """
        settingArgsList= [
                userUUID, str(Config.NOTIFICATION_FOR_LIKE), str(Config.STATUS_ON),
                userUUID, str(Config.NOTIFICATION_FOR_COMMENT), str(Config.STATUS_ON),
                userUUID, str(Config.NOTIFICATION_FOR_NEW_STAR), str(Config.STATUS_ON),
                userUUID, str(Config.NOTIFICATION_FOR_NEW_SHARE), str(Config.STATUS_OFF)
            ]
        sqlList.append(userSettingSQL)
        argsList.append(settingArgsList)

        dbManager = DB.DBManager.shareInstanced()
        results = dbManager.executeTransactionMutltiDmlWithArgsList(sqlList, argsList)  
    except Exception as e:
        Loger.error(e, __file__)
        raise e

    return results 


def __generateResponseData(userUUID, token):
    querySQL = """
        SELECT uuid, id, nickname, avatar, phone, email, detail, gender, 
            qq, weibo, wechat, area
        FROM t_quickTalk_user WHERE uuid=%s
    """

    dbManager = DB.DBManager.shareInstanced()
    results = None
    try: 
        results = dbManager.executeTransactionQueryWithArgs(querySQL, [userUUID])
        tupleData  = results[0]

        avatar = tupleData["avatar"].strip()
        tupleData["token"] = token
        if len(avatar) > 0:
            avatar = userAvatarURL(userUUID, avatar)
            tupleData["avatar"] = avatar
        results  = tupleData
    except Exception as e:
        Loger.error(e, __file__)
        raise e

    return results
