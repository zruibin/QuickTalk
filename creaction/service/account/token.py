#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# token.py
#
# Created by ruibin.chow on 2017/08/09.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""
获得token
"""
from service.account import account
from flask import Flask, Response, request
from module.database import DB
from module.log.Log import Loger
from config import *
from common.code import *
from common.auth import generateToken, cacheToken


@account.route('/token')
def token():
    userUUID = request.args.get("user_uuid")
    password = request.args.get("password")

    # 参数没有直接报错返回
    if userUUID == None or  password == None:
            return RESPONSE_JSON(CODE_ERROR_MISS_PARAM)

    # 验证用户是否存在
    result = verifyUserIsExists(userUUID)
    if not result:  return RESPONSE_JSON(CODE_ERROR_USER_NOT_EXISTS)
    
    # 验证用户密码是否正确
    result = verifyUserPassword(userUUID, password)
    if not result:  return RESPONSE_JSON(CODE_ERROR_PASSWORD_ERROR)

    # 生成token并缓存
    token = generateToken(userUUID)
    if token == None or cacheToken(userUUID, token) == False: 
            return RESPONSE_JSON(CODE_ERROR_TOKEN_CACHE_FAIL)

    response = RESPONSE_JSON(CODE_SUCCESS, data={"token": token})
    response.set_cookie('token', token)
    return response


def verifyUserIsExists(userUUID):
    result  = False
    querySQL = """
        SELECT uuid FROM t_user WHERE uuid='%s'; """ % userUUID
    dbManager = DB.DBManager.shareInstanced()
    try: 
            resultData = dbManager.executeSingleQuery(querySQL)
            if len(resultData) > 0: result = True
    except Exception as e:
            Loger.error(e, __file__)

    return result


def verifyUserPassword(userUUID, password):
    result  = False
    querySQL = """
        SELECT password FROM t_user_auth WHERE user_uuid='%s'; """ % userUUID
    dbManager = DB.DBManager.shareInstanced()
    try: 
            resultData = dbManager.executeSingleQuery(querySQL)
            dataPassword = ""
            if len(resultData) > 0 : dataPassword = resultData[0][0]
            if dataPassword == password: result = True
    except Exception as e:
            Loger.error(e, __file__)

    return result




if __name__ == '__main__':
    pass
