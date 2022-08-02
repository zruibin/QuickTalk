#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# changeEmailOrPhone.py
#
# Created by ruibin.chow on 2017/09/07.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""
修改登录的邮箱或手机
"""

from service.account import account
from module.database import DB
from module.log.Log import Loger
from config import *
from common.code import *
from common.auth import vertifyTokenHandle
from common.tools import getValueFromRequestByKey
from common.commonMethods import verifyEmailIsExists, verifyPhoneIsExists
from module.cache.RuntimeCache import CacheManager


@account.route('/change_email_or_phone', methods=["POST"])
@vertifyTokenHandle
def changeEmailOrPhone():
    userUUID = getValueFromRequestByKey("user_uuid")
    typeStr = getValueFromRequestByKey("type")
    account = getValueFromRequestByKey("account")
    

    if userUUID == None or typeStr == None or account == None:
        return RESPONSE_JSON(CODE_ERROR_MISS_PARAM)

    typeString = ""
    if typeStr == Config.TYPE_FOR_EMAIL:
        typeString = "email"
        if verifyEmailIsExists(account): return RESPONSE_JSON(CODE_ERROR_THE_EMAIL_HAS_BE_USED)
        code = getValueFromRequestByKey("code")
        if code == None:
            return RESPONSE_JSON(CODE_ERROR_TEST_AND_VERIFY)
        else:
            code = CacheManager.shareInstanced().getCache(account)
            if code == None:
                return RESPONSE_JSON(CODE_ERROR_VERIFY_CODE_OUTDATE)
    elif typeStr == Config.TYPE_FOR_PHONE:
        typeString = "phone"
        if verifyPhoneIsExists(account): return RESPONSE_JSON(CODE_ERROR_THE_PHONE_HAS_BE_USED)
    else:
        return RESPONSE_JSON(CODE_ERROR_SERVICE)

    if __changeEmailOrPhoneInStorage(userUUID, typeString, account):
        return RESPONSE_JSON(CODE_SUCCESS)
    else:
        return RESPONSE_JSON(CODE_ERROR_SERVICE)


def __changeEmailOrPhoneInStorage(userUUID, typeString, account):
    result = False
    updateSQL = """
        UPDATE t_user SET %s='%s' WHERE uuid='%s'; """ % (typeString, account, userUUID)

    dbManager = DB.DBManager.shareInstanced()
    try: 
            result = dbManager.executeTransactionDml(updateSQL)
    except Exception as e:
            Loger.error(e, __file__)
            
    return result
    


if __name__ == '__main__':
    pass
