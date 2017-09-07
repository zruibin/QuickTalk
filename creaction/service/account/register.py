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
from common.tools import generateUUID, generateCurrentTime, md5hex, fullPathForMediasFile, makeCookie
from common.code import *
from common.auth import generateToken, cacheToken
from common.commonMethods import verifyEmailIsExists, verifyPhoneIsExists
from common.tools import getValueFromRequestByKey


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


def createNewUserOperation(password="", time="", phone="", email="", authType="", authOpenId=""):
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
                dataDict = generateResponseData(userUUID, token)

                response = RESPONSE_JSON(CODE_SUCCESS, data=dataDict)
                response = makeCookie(response, "token", token)
                return response
        except Exception as e:
                Loger.error(e, __file__)
                return RESPONSE_JSON(CODE_ERROR_SERVICE)


def  __operationDataStorage(userUUID, password="", time="", phone="", email="", authType="", authOpenId=""):
        results = False
        try: 
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
                """ % (userUUID, Config.NOTIFICATION_FOR_LIKE, Config.STATUS_ON,
                        userUUID, Config.NOTIFICATION_FOR_COMMENT, Config.STATUS_ON,
                        userUUID, Config.NOTIFICATION_FOR_JOURNAL, Config.STATUS_ON,
                        userUUID, Config.NOTIFICATION_FOR_START_PROJECT, Config.STATUS_ON,
                        userUUID, Config.NOTIFICATION_FOR_START_PEOPLE, Config.STATUS_ON,
                        userUUID, Config.NOTIFICATION_FOR_CONTACT, Config.STATUS_ON)
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
                results = dbManager.executeTransactionMutltiDml(sqlList)  
        except Exception as e:
                Loger.error(e, __file__)
                raise e

        return results 


def generateResponseData(userUUID, token):
        querySQL = """
                SELECT t_user.uuid, t_user.id, t_user.nickname, t_user.avatar, t_user.phone, t_user.email, t_user.detail,
                t_user.contact_phone, t_user.contact_email, t_user.qq, t_user.weibo, t_user.wechat,
                t_user_auth.qq as authQQ, t_user_auth.wechat as authWechat, t_user_auth.weibo as authWeibo
                FROM t_user, t_user_auth WHERE t_user.uuid='{user_uuid}' 
                AND t_user_auth.user_uuid='{user_uuid}'
        """.format(user_uuid=userUUID)

        dbManager = DB.DBManager.shareInstanced()
        results = None
        try: 
                results = dbManager.executeTransactionQuery(querySQL)
                tupleData  = results[0]
                avatar = tupleData["avatar"].strip()
                if len(avatar) > 0:
                        avatar = fullPathForMediasFile(Config.UPLOAD_FILE_FOR_USER, userUUID, avatar)
                dataDict = {
                        "token" : token,
                        "uuid" : tupleData["uuid"],
                        "id" : str(tupleData["id"]),
                        "nickname" : tupleData["nickname"],
                        "avatar" : avatar,
                        "phone" : tupleData["phone"],
                        "email" : tupleData["email"],
                        "detail" : tupleData["detail"],
                        "authQQ" : tupleData["authQQ"],
                        "authWechat" : tupleData["authWechat"],
                        "authWeibo" : tupleData["authWeibo"],
                        "contactPhone" : tupleData["contact_phone"],
                        "contactEmail" : tupleData["contact_email"],
                        "contactQQ" : tupleData["qq"],
                        "contactWeibo" : tupleData["weibo"],
                        "contactWechat" : tupleData["wechat"]
                }
                results  = dataDict
        except Exception as e:
                Loger.error(e, __file__)
                raise e

        return results
