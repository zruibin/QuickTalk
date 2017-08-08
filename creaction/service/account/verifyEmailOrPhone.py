#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# verifyEmailOrPhone.py
#
# Created by ruibin.chow on 2017/08/08.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""
验证邮箱或手机是否已被使用
"""

from service.account import account
from module.database import DB
from module.log.Log import Loger
from config import *
from common.tools import jsonTool
from common.code import *

@account.route('/verifyphoneandemail')
def verifyEmailOrPhone():
        accountStr = request.args.get("account")
        typeStr = request.args.get("type")

        # 参数没有直接报错返回
        if accountStr == None or  typeStr == None:
                return PACKAGE_CODE(CODE_ERROR_MISS_PARAM, MESSAGE[CODE_ERROR_MISS_PARAM])

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
        return PACKAGE_CODE(CODE_SUCCESS, MESSAGE[CODE_SUCCESS], data="0")



def verifyEmailIsExists(email):
    result  = False
    querySQL = """
            SELECT email FROM t_user WHERE email='%s'; """ % email
    dbManager = DB.DBManager()
    try: 
            results = dbManager.executeSingleQuery(querySQL)
            if len(results) > 0: result = True
    except Exception as e:
            Loger.error(e, __file__)

    return result


def verifyPhoneIsExists(phone):
    result  = False
    querySQL = """
            SELECT phone FROM t_user WHERE phone='%s'; """ % phone
    dbManager = DB.DBManager()
    try: 
            results = dbManager.executeSingleQuery(querySQL)
            if len(results) > 0: result = True
    except Exception as e:
            Loger.error(e, __file__)

    return result

if __name__ == '__main__':
    pass
