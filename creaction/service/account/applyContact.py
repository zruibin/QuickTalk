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
from module.database import DB
from module.log.Log import Loger
from config import *
from common.code import *
from common.auth import vertifyTokenHandle
from common.tools import getValueFromRequestByKey
from common.commonMethods import verifyUserIsExists
import common.notification as notification
from dispatch.tasks import dispatchNotificationUserForContent


@account.route('/apply_contact', methods=["POST"])
# @vertifyTokenHandle
def applyContact():
    userUUID = getValueFromRequestByKey("user_uuid")
    beApplyUserUUID = getValueFromRequestByKey("be_apply_user_uuid") # 被申请者的uuid
    userName = getValueFromRequestByKey("username")

    if userName == None:
        return RESPONSE_JSON(CODE_ERROR_MISS_PARAM)

    if not verifyUserIsExists(beApplyUserUUID):
        return RESPONSE_JSON(CODE_ERROR_USER_NOT_EXISTS)
    
    if __applyExchangeContactOperation(userUUID, userName, beApplyUserUUID):
        return RESPONSE_JSON(CODE_SUCCESS)
    else:
        return RESPONSE_JSON(CODE_ERROR_SERVICE)


def __applyExchangeContactOperation(userUUID, userName, beApplyUserUUID):
    result = False
    content = userName + "向你申请交换联系方式"

    insertSQL = """INSERT INTO t_message_contact (user_uuid, type, content_uuid, owner_user_uuid, status, content, action) 
    VALUES ('%s', %d, '%s', '%s', %d, '%s', %d); """ % (beApplyUserUUID, Config.NOTIFICATION_FOR_CONTACT, 
    userUUID, userUUID, Config.TYPE_FOR_MESSAGE_UNREAD, 
    content, Config.TYPE_FOR_MESSAGE_ACTION_OFF)

    # 避免多次申请
    querySQL = """
        SELECT user_uuid FROM t_message_contact WHERE user_uuid='%s' 
        AND content_uuid='%s' AND owner_user_uuid='%s'; """ % (beApplyUserUUID, userUUID, userUUID)
    # 多次申请只保留一条
    deleteSQL = """ DELETE FROM t_message_contact WHERE user_uuid='%s' 
        AND content_uuid='%s' AND owner_user_uuid='%s'; """ % (beApplyUserUUID, userUUID, userUUID)

    dbManager = DB.DBManager.shareInstanced()
    try:
        resultData = dbManager.executeSingleQuery(querySQL)
        if len(resultData) > 0: 
            dbManager.executeTransactionDml(deleteSQL)
        result = dbManager.executeTransactionDml(insertSQL)
        notification.notificationUserForContent(beApplyUserUUID, content)
        # dispatchNotificationUserForContent.delay(beApplyUserUUID, content)
    except Exception as e:
        Loger.error(e, __file__)
            
    return result
    

if __name__ == '__main__':
    pass
