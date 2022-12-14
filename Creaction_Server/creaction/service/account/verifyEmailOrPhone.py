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
from common.code import *
from common.commonMethods import verifyEmailIsExists, verifyPhoneIsExists
from common.tools import getValueFromRequestByKey


@account.route("/verify_phone_and_email", methods=["POST", "GET"])
def verifyEmailOrPhone():
        accountStr = getValueFromRequestByKey("account")
        typeStr = getValueFromRequestByKey("type")

        # 参数没有直接报错返回
        if accountStr == None or  typeStr == None:
                return RESPONSE_JSON(CODE_ERROR_MISS_PARAM)

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
        return RESPONSE_JSON(CODE_SUCCESS, data="0")





if __name__ == '__main__':
    pass
