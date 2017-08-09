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
from service.account import account
from flask import Flask, Response, request
from module.database import DB
from module.cache.RuntimeCache import CacheManager
from module.log.Log import Loger
from config import *
from common.tools import generateUUID, generateCurrentTime
from common.code import *
from common.auth import generateToken, cacheToken
from service.account.verifyEmailOrPhone import *


@account.route("/register", methods=["POST"])
def register():                         
        accountStr = request.args.get("account")
        password = request.args.get("password") # md5后(32位)
        typeStr = request.args.get("type")

        # 参数没有直接报错返回
        if accountStr == None or password == None or typeStr == None:
                return RESPONSE_JSON(CODE_ERROR_MISS_PARAM)

        # 邮箱注册则看验证码是否过期或存在
        if typeStr == Config.TYPE_FOR_EMAIL:
                code = request.args.get("code")
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

        # 生成用户的uuid
        userUUID = generateUUID()
        time = generateCurrentTime()
        
        # 用于测试在无用户的情况下第三方登录，则生成一个新的账号并与第三方的进行绑定
        # authType = request.args.get("authType")
        # authOpenId = request.args.get("authOpenId")
        # if operationDataStorage(userUUID, password, time, phone, email, authType, authOpenId) == False:
        #         return RESPONSE_JSON(CODE_ERROR_SERVICE)
        用户数据入库
        if operationDataStorage(userUUID, password, time, phone, email) == False:
                return RESPONSE_JSON(CODE_ERROR_SERVICE)

        # 生成token并缓存
        token = generateToken(userUUID)
        if token == None or cacheToken(userUUID, token) == False: 
                return RESPONSE_JSON(CODE_ERROR_TOKEN_CACHE_FAIL)
        dataSDict = generateResponseData(userUUID, token)

        response = RESPONSE_JSON(CODE_SUCCESS, data=dataSDict)
        response.set_cookie('token', token)
        return response


def  operationDataStorage(userUUID, password, time, phone="", email="", authType="", authOpenId=""):
        results = False
        sqlList = []
        userSQL = """ 
                INSERT INTO `t_user`(`uuid`, `nickname`, `detail`, `phone`, `email`, `qq`, `wechat`, `gender`, `area`, `avatar`, `career`, `time`, `contact_phone`, `contact_email`, `weibo`)
                VALUES('%s', '', '', '%s', '%s', '', '', 2, '', ' ', '', '%s', '', '', '');
        """ % (userUUID, phone, email, time)
        sqlList.append(userSQL)

        userAuthSQL = """
                INSERT INTO `t_user_auth`(`user_uuid`, `password`, `qq`, `wechat`, `weibo`)
                VALUES('%s', '%s', '', '', '');
                """ % (userUUID, password)
        sqlList.append(userAuthSQL)
        
        userSettingSQL = """
                INSERT INTO t_user_setting (user_uuid, type, status) 
                VALUES ('%s', %d, %d), ('%s', %d, %d), 
                        ('%s', %d, %d), ('%s', %d, %d), ('%s', %d, %d), 
                        ('%s', %d, %d);
        """ % (userUUID, Config.NOTIFICATION_FOR_LIKE, Config.NOTIFICATION_STATUS_ON,
                userUUID, Config.NOTIFICATION_FOR_COMMENT, Config.NOTIFICATION_STATUS_ON,
                userUUID, Config.NOTIFICATION_FOR_JOURNAL, Config.NOTIFICATION_STATUS_ON,
                userUUID, Config.NOTIFICATION_FOR_START_PROJECT, Config.NOTIFICATION_STATUS_ON,
                userUUID, Config.NOTIFICATION_FOR_START_PEOPLE, Config.NOTIFICATION_STATUS_ON,
                userUUID, Config.NOTIFICATION_FOR_CONTACT, Config.NOTIFICATION_STATUS_ON)
        sqlList.append(userSettingSQL)

        if len(authType) > 0:
                typeDict = {
                        Config.TYPE_FOR_AUTH_WECHAT : "wechat",
                        Config.TYPE_FOR_AUTH_QQ : "qq",
                        Config.TYPE_FOR_AUTH_WEIBO : "weibo"
                }
                typeContent = typeDict[authType]
                updateSQL = """UPDATE t_user_auth SET %s='%s' WHERE user_uuid='%s'; """ % (typeContent, authOpenId, userUUID)
                sqlList.append(updateSQL)

        dbManager = DB.DBManager.shareInstanced()
        try: 
                results = dbManager.executeTransactionMutltiDml(sqlList)  
        except Exception as e:
                Loger.error(e, __file__)

        return results 


def generateResponseData(userUUID, token):
        querySQL = """
                SELECT t_user.uuid, t_user.id, t_user.nickname, t_user.avatar, t_user.phone, t_user.email, 
                t_user_auth.password, t_user_auth.qq, t_user_auth.wechat, t_user_auth.weibo,
                t_user.contact_phone, t_user.contact_email, t_user.qq, t_user.weibo, t_user.wechat
                FROM t_user, t_user_auth WHERE t_user.uuid='%s' 
                AND t_user_auth.user_uuid='%s'
        """ % (userUUID, userUUID)

        dbManager = DB.DBManager.shareInstanced()
        results = None
        try: 
                results = dbManager.executeTransactionQuery(querySQL)
                tupleData  = results[0]

                user_uuid = tupleData[0]
                user_id = str(tupleData[1])
                userName = tupleData[2]
                avatar = tupleData[3]
                phone = tupleData[4]
                email = tupleData[5]
                password = tupleData[6]
                authQQ = tupleData[7]
                authWechat = tupleData[8]
                authWeibo = tupleData[9]
                contactPhone = tupleData[11]
                contactEmail = tupleData[11]
                contactQQ = tupleData[12]
                contactWeibo = tupleData[13]
                contactWechat = tupleData[14]
                dataDict = {
                        "token" : token,
                        "user_uuid" : user_uuid,
                        "user_id" : user_id,
                        "userName" : userName,
                        "avatar" : avatar,
                        "phone" : phone,
                        "email" : email,
                        "password" : password,
                        "authQQ" : authQQ,
                        "authWechat" : authWechat,
                        "authWeibo" : authWeibo,
                        "contactPhone" : contactPhone,
                        "contactEmail" : contactEmail,
                        "contactQQ" : contactQQ,
                        "contactWeibo" : contactWeibo,
                        "contactWechat" : contactWechat
                }
                results  = dataDict
        except Exception as e:
                Loger.error(e, __file__)

        return results
