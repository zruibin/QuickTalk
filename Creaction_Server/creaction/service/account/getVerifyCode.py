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
from module.database import DB
from module.log.Log import Loger
from config import *
from common.code import *
from common.auth import vertifyTokenHandle
from common.tools import getValueFromRequestByKey
from dispatch.tasks import dispatchSendEmailForVerifyCode
from common.commonMethods import verifyEmailIsExistsForReturnUUID


@account.route('/get_verify_code', methods=["GET", "POST"])
def getVerifyCode():
    account = getValueFromRequestByKey("account")
    typeStr = getValueFromRequestByKey("type")

    if typeStr == Config.TYPE_FOR_EMAIL:
        # 验证email是否存在了
        # userUUID = verifyEmailIsExistsForReturnUUID(account)
        # if userUUID == None: return RESPONSE_JSON(CODE_ERROR_THE_EMAIL_NOT_FOUND)

        # 利用Celery异步发邮件
        if dispatchSendEmailForVerifyCode.delay(account):
            return RESPONSE_JSON(CODE_SUCCESS)
        else:
            return RESPONSE_JSON(CODE_ERROR_SERVICE)

    else:
        return RESPONSE_JSON(CODE_ERROR_ONLY_FOR_EMAIL)
    

if __name__ == '__main__':
    pass
