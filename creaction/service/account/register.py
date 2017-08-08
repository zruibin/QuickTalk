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
from common.tools import jsonTool, generateUUID, generateCurrentTime
from common.code import *
from common.auth import generateToken
from service.account.verifyEmailOrPhone import *


@account.route('/register')
def register():                         

        accountStr = request.args.get("account")
        password = request.args.get("password") # md5后(32位)
        typeStr = request.args.get("type")

        # 参数没有直接报错返回
        if accountStr == None or password == None or typeStr == None:
                return PACKAGE_CODE(CODE_ERROR_MISS_PARAM, MESSAGE[CODE_ERROR_MISS_PARAM])

        # 邮箱注册则看验证码是否过期或存在
        if typeStr == Config.TYPE_FOR_EMAIL:
                code = request.args.get("code")
                if code == None:
                        return PACKAGE_CODE(CODE_ERROR_TEST_AND_VERIFY, MESSAGE[CODE_ERROR_TEST_AND_VERIFY])
                else:
                        code = CacheManager.shareInstanced().getCache(accountStr)
                        if code == None:
                                return PACKAGE_CODE(CODE_ERROR_VERIFY_CODE_OUTDATE, MESSAGE[CODE_ERROR_VERIFY_CODE_OUTDATE])


        phone = ""
        email = ""
        #注册前要验证手机或email是否已使用了
        if typeStr == Config.TYPE_FOR_EMAIL: 
                email = accountStr
                result = verifyEmailIsExists(email)
                if result :  return PACKAGE_CODE(CODE_ERROR_THE_EMAIL_HAS_BE_USED, MESSAGE[CODE_ERROR_THE_EMAIL_HAS_BE_USED])

        if typeStr == Config.TYPE_FOR_PHONE: 
                phone = accountStr
                result = verifyPhoneIsExists(phone)
                if result :  return PACKAGE_CODE(CODE_ERROR_THE_PHONE_HAS_BE_USED, MESSAGE[CODE_ERROR_THE_PHONE_HAS_BE_USED])


        userUUID = generateUUID()
        time = generateCurrentTime()
        
        if operationDataStorage(userUUID, password, time, phone, email) == False:
                return PACKAGE_CODE(CODE_ERROR_SERVICE, MESSAGE[CODE_ERROR_SERVICE])
        token = generateToken(userUUID)

        if token == None or cacheToken(userUUID, token) == False: 
                return PACKAGE_CODE(CODE_ERROR_TOKEN_CACHE_FAIL, MESSAGE[CODE_ERROR_TOKEN_CACHE_FAIL])
        dataSDict = generateResponseData(userUUID, token)
                
        return PACKAGE_CODE(CODE_SUCCESS, MESSAGE[CODE_SUCCESS], data=dataSDict)


def  operationDataStorage(userUUID, password, time, phone="", email=""):
        results = False
        userSQL = """ 
                INSERT INTO `t_user`(`uuid`, `nickname`, `detail`, `phone`, `email`, `qq`, `wechat`, `gender`, `area`, `avatar`, `career`, `time`)
                VALUES('%s', '', '', '%s', '%s', '', '', 2, '', ' ', '', '%s');
        """ % (userUUID, phone, email, time)
        userAuthSQL = """
                INSERT INTO `t_user_auth`(`user_uuid`, `password`, `qq`, `wechat`, `weibo`)
                VALUES('%s', '%s', '', '', '');
        """ % (userUUID, password)
        
        dbManager = DB.DBManager()
        try: 
                results = dbManager.executeTransactionMutltiDml([userSQL, userAuthSQL])  
        except Exception as e:
                Loger.error(e, __file__)

        return results 


def generateResponseData(userUUID, token):
        querySQL = """
                SELECT t_user.uuid, t_user.id, t_user.nickname, t_user.avatar, t_user.phone, t_user.email, 
                t_user_auth.password, t_user_auth.qq, t_user_auth.wechat, t_user_auth.weibo 
                FROM t_user, t_user_auth WHERE t_user.uuid='%s' 
                AND t_user_auth.user_uuid='%s'
        """ % (userUUID, userUUID)

        dbManager = DB.DBManager()
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
                qq = tupleData[7]
                wechat = tupleData[8]
                weibo = tupleData[9]
                dataDict = {
                        "token" : token,
                        "user_uuid" : user_uuid,
                        "user_id" : user_id,
                        "userName" : userName,
                        "avatar" : avatar,
                        "phone" : phone,
                        "email" : email,
                        "password" : password,
                        "authQQ" : qq,
                        "authWechat" : wechat,
                        "authWeibo" : weibo
                }
                results  = dataDict
        except Exception as e:
                Loger.error(e, __file__)

        return results


def cacheToken(userUUID, token):
        results = True
        try:
                CacheManager.shareInstanced().setCache(userUUID, token)
        except Exception as e:
                Loger.error(e, __file__)
                results = False
        return results