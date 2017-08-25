#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# agreeApplyContact.py
#
# Created by ruibin.chow on 2017/08/15.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""
同意查看联系方式
"""

from service.account import account
from module.database import DB
from module.log.Log import Loger
from config import *
from common.code import *
from common.auth import vertifyTokenHandle
from common.tools import getValueFromRequestByKey, generateCurrentTime
from common.commonMethods import verifyUserIsExists


@account.route('/agree_apply_contact', methods=["POST"])
@vertifyTokenHandle
def agreeApplyContact():
    userUUID = getValueFromRequestByKey("user_uuid")
    applyUserUUID = getValueFromRequestByKey("apply_user_uuid") # 申请者的uuid

    if applyUserUUID == None:
        return RESPONSE_JSON(CODE_ERROR_MISS_PARAM)

    if not verifyUserIsExists(applyUserUUID):
        return RESPONSE_JSON(CODE_ERROR_USER_NOT_EXISTS)
    
    if __agreeApplyExchangeContactOperation(userUUID, applyUserUUID):
        return RESPONSE_JSON(CODE_SUCCESS)
    else:
        return RESPONSE_JSON(CODE_ERROR_SERVICE)


def __agreeApplyExchangeContactOperation(userUUID, applyUserUUID):
    result = False
    time = generateCurrentTime()
    insertSQL = """INSERT INTO t_user_user (user_uuid, type, other_user_uuid, time) 
    VALUES ('{userUUID}', {typeInt}, '{applyUserUUID}', '{time}'), ('{applyUserUUID}', {typeInt}, '{userUUID}', '{time}'); """.format(userUUID=userUUID, 
        typeInt=Config.TYPE_FOR_USER_CONTACT, applyUserUUID=applyUserUUID, time=time)

    # 避免多次通过
    querySQL = """
        SELECT user_uuid FROM t_user_user WHERE user_uuid='%s' 
        AND type=%s AND other_user_uuid='%s'; """ % (userUUID, Config.TYPE_FOR_USER_CONTACT, applyUserUUID)

    dbManager = DB.DBManager.shareInstanced()
    try:
        resultData = dbManager.executeSingleQuery(querySQL)
        if len(resultData) > 0: 
            result = True
        else:
            result = dbManager.executeTransactionDml(insertSQL)
    except Exception as e:
        Loger.error(e, __file__)
            
    return result


if __name__ == '__main__':
    pass
