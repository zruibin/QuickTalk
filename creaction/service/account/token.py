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
from common.tools import md5hex
from service.account.universal import verifyUserIsExists, verifyUserPassword


@account.route("/token", methods=["POST", "GET"])
def token():
    userUUID = request.args.get("user_uuid")
    password = md5hex(request.args.get("password")) # md5后(32位)

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




if __name__ == '__main__':
    pass
