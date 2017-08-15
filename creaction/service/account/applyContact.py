#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# applyContact.py
#
# Created by ruibin.chow on 2017/08/15.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""
申请查看联系方式
"""
from service.account import account
from flask import Flask, Response, request
from module.database import DB
from module.log.Log import Loger
from config import *
from common.code import *
from common.auth import vertifyTokenHandle
from common.tools import getValueFromRequestByKey
from service.account.universal import verifyUserIsExists
import common.notification as notification


@account.route('/apply_contact', methods=["POST"])
@vertifyTokenHandle
def applyContact():
    userUUID = getValueFromRequestByKey("user_uuid")
    beApplyUserUUID = getValueFromRequestByKey("be_apply_user_uuid") # 被申请者的uuid
    userName = getValueFromRequestByKey("username")

    if userName == None:
        return RESPONSE_JSON(CODE_ERROR_MISS_PARAM)

    if not verifyUserIsExists(beApplyUserUUID):
        return RESPONSE_JSON(CODE_ERROR_USER_NOT_EXISTS)
    
    if applyExchangeContactOperation(userUUID, userName, beApplyUserUUID):
        return RESPONSE_JSON(CODE_SUCCESS)
    else:
        return RESPONSE_JSON(CODE_ERROR_SERVICE)


def applyExchangeContactOperation(userUUID, userName, beApplyUserUUID):
    result = False
    content = userName + "向你申请交换联系方式"

    insertSQL = """INSERT INTO t_message_contact (user_uuid, type, content_uuid, owner_user_uuid, status, content) 
    VALUES ('%s', 1, '%s', '%s', %d, '%s'); """ % (beApplyUserUUID, userUUID, userUUID, Config.TYPE_FOR_MESSAGE_UNREAD, content)

    dbManager = DB.DBManager.shareInstanced()
    try: 
        result = dbManager.executeTransactionDml(insertSQL)
        notification.notificationUserForContent(beApplyUserUUID, content)
    except Exception as e:
        Loger.error(e, __file__)
            
    return result
    

if __name__ == '__main__':
    pass
