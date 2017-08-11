#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# getVerifyCode.py
#
# Created by ruibin.chow on 2017/08/11.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""
手机或邮箱获得验证码
(手机暂时用第三方，不需要，客户端与第三方进行验证)
"""
from service.account import account
from flask import Flask, Response, request
import json
from module.database import DB
from module.log.Log import Loger
from config import *
from common.code import *
from common.auth import vertifyTokenHandle
from common.tools import getValueFromRequestByKey
from common.mail import sendEmailForVerifyCodeByCache
from service.account.universal import verifyEmailIsExists


@account.route('/get_verify_code', methods=["GET"])
def getVerifyCode():
    account = getValueFromRequestByKey("account")
    typeStr = getValueFromRequestByKey("type")

    if typeStr == Config.TYPE_FOR_EMAIL:
        # 验证email是否已使用了
        if verifyEmailIsExists(account) :  return RESPONSE_JSON(CODE_ERROR_THE_EMAIL_HAS_BE_USED)

        if sendEmailForVerifyCodeByCache(account):
            return RESPONSE_JSON(CODE_SUCCESS)
        else:
            return RESPONSE_JSON(CODE_ERROR_SERVICE)

    else:
        return RESPONSE_JSON(CODE_ERROR_ONLY_FOR_EMAIL)
    




if __name__ == '__main__':
    pass
