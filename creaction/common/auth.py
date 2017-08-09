#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# auth.py
#
# Created by ruibin.chow on 2017/08/05.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""
产生token: 
通过hmac sha1 算法产生用户给定的key和token的最大过期时间戳的一个消息摘要，
将这个消息摘要和最大过期时间戳通过":"拼接起来，再进行base64编码，生成最终的token

验证token:
将token进行base64解码,通过token得到token最大过期时间戳和消息摘要。判断token是否过期。
如没过期才将 从token中的取得最大过期时间戳进行hmac sha1 算法运算(注意这里的key要与产生token的key要相同)，
最后将产生的摘要与通过token取得消息摘要进行对比， 如果两个摘要相等，则token有效，否则token无效 。
"""

import hmac, hashlib, base64, time
from functools import wraps
from config import Config
from flask import  request, Response,make_response
from common.code import *
from module.log.Log import Loger
from module.cache.RuntimeCache import CacheManager

ENCODE_UTF8 = "utf-8"
ENCODE_BASE64 = "base64"

def generateToken(key, expire=Config.TOKEN_EXPIRE):
    '''
        @Args:
            key: str (用户给定的key[用户uuid]，需要用户保存以便之后验证token,
            每次产生token时的key 都可以是同一个key)
            expire: int(最大有效时间，单位为s)
        @Return:
            state: str
    '''
    tsStr = str(time.time() + expire)
    tsByte = tsStr.encode(ENCODE_UTF8)
    sha1TshexStr = hmac.new(str(key).encode(ENCODE_UTF8), tsByte, 
                                    hashlib.sha1).digest().encode(ENCODE_BASE64)
    token = tsStr + ":" + sha1TshexStr
    b64Token = base64.b64encode(token)
    return b64Token


def vertifyToken(key, token):
    '''
        @Args:
            key: str
            token: str
        @Returns:
            boolean
    '''
    tokenStr = base64.b64decode(token)
    tokenList = tokenStr.split(':')
    if len(tokenList) != 2:
        return False
    tsStr = tokenList[0]
    if float(tsStr) < time.time():
        # token expired
        return False
    knownSha1Tsstr = tokenList[1]
    tsByte = tsStr.encode(ENCODE_UTF8) 
    sha1TshexStr = hmac.new(str(key).encode(ENCODE_UTF8), tsByte, 
                                    hashlib.sha1).digest().encode(ENCODE_BASE64)
    if sha1TshexStr != knownSha1Tsstr:
        # token certification failed
        return False 
    # token certification success
    return True


def cacheToken(userUUID, token):
        results = True
        try:
                CacheManager.shareInstanced().setCache(userUUID, token)
        except Exception as e:
                Loger.error(e, __file__)
                results = False
        return results


def tokenErrorResponse():
    response = RESPONSE_JSON(CODE_ERROR_TOKEN_NOT_FOUND)
    response.headers["Access-Control-Allow-Methods"] = "GET,POST"
    response.headers["Access-Control-Allow-Headers"] = "Referer,Accept,Origin,User-Agent"
    response.headers["WWW-Authenticate"] = "Authentication Required"
    return response


def vertifyTokenHandle(func):
    @wraps(func)
    def wrapper(*args, **kwargs):
        userUUID = request.args.get("user_uuid") if request.args.get("user_uuid") else request.form.get("user_uuid")
        token = request.cookies.get("token") if request.cookies.get("token") else request.args.get("token")

        if userUUID == None or token == None:
            return RESPONSE_JSON(CODE_ERROR_MISS_PARAM)
        if vertifyToken(userUUID, token) == False:
            response = tokenErrorResponse()
            return response
        else:
            return func(*args, **kwargs)
    return wrapper



if __name__ == '__main__':
    pass
