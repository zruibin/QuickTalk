#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# forgetPassword.py
#
# Created by ruibin.chow on 2017/08/14.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""
忘记密码
"""
from service.account import account
from flask import Flask, Response, request
from module.database import DB
from module.log.Log import Loger
from config import *
from common.code import *
from common.auth import vertifyTokenHandle
from service.account.universal import verifyEmailIsExistsForReturnUUID, verifyPhoneIsExistsForReturnUUID
from common.tools import getValueFromRequestByKey, md5hex
from module.cache.RuntimeCache import CacheManager


@account.route('/forget_password', methods=["POST", "GET"])
@vertifyTokenHandle
def forgetPassword():
    accountStr = getValueFromRequestByKey("account")
    password = getValueFromRequestByKey("newpassword")
    typeStr = str(getValueFromRequestByKey("type"))

    # 参数没有直接报错返回
    if accountStr == None or password == None or typeStr == None:
            return RESPONSE_JSON(CODE_ERROR_MISS_PARAM)
    
    password = md5hex(password) # md5后(32位)

    userUUID = None
    # 邮箱注册则看验证码是否过期或存在
    if typeStr == Config.TYPE_FOR_EMAIL:
        code = getValueFromRequestByKey("code")
        if code == None:
                return RESPONSE_JSON(CODE_ERROR_TEST_AND_VERIFY)
        else:
                codeCache = CacheManager.shareInstanced().getCache(accountStr)
                if code != codeCache:
                        return RESPONSE_JSON(CODE_ERROR_VERIFY_CODE_OUTDATE)
        userUUID = verifyPhoneIsExistsForReturnUUID(accountStr)
        if userUUID == None: return RESPONSE_JSON(CODE_ERROR_THE_EMAIL_NOT_FOUND)
    
    if typeStr == Config.TYPE_FOR_PHONE:
        userUUID = verifyPhoneIsExistsForReturnUUID(accountStr)
        print userUUID
        if userUUID == None: return RESPONSE_JSON(CODE_ERROR_THE_PHONE_NOT_FOUND)

    if changePasswordInStorage(userUUID, password):
        return RESPONSE_JSON(CODE_SUCCESS) 
    else:
        return RESPONSE_JSON(CODE_ERROR_SERVICE)
    

def changePasswordInStorage(userUUID, password):
    print "changePasswordInStorage"
    result = False
    updateSQL = """
        UPDATE t_user_auth SET password='%s' WHERE user_uuid='%s'
    """ % (password, userUUID)

    dbManager = DB.DBManager.shareInstanced()
    try: 
        results = dbManager.executeTransactionDml(updateSQL)
    except Exception as e:
        Loger.error(e, __file__)

    return results 


if __name__ == '__main__':
    pass
