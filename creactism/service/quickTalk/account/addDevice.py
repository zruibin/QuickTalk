#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# addDevice.py
#
# Created by ruibin.chow on 2017/12/25.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""
添加通知设备
"""

from service.quickTalk.account import account
from module.database import DB
from module.log.Log import Loger
from config import *
from common.code import *
from common.tools import getValueFromRequestByKey, generateCurrentTime
from common.auth import vertifyTokenHandle


@account.route('/addDevice', methods=["POST", "GET"])
@vertifyTokenHandle
def addDeviceRequest():
    userUUID = getValueFromRequestByKey("user_uuid")
    deviceId = getValueFromRequestByKey("deviceId")

    # 参数没有直接报错返回
    if userUUID == None or deviceId == None:
        return RESPONSE_JSON(CODE_ERROR_MISS_PARAM)

    return __addDevice(userUUID, deviceId)
        

def __addDevice(userUUID, deviceId):
    if __queryWhetherDevice(userUUID, deviceId):
        return RESPONSE_JSON(CODE_ERROR_ALREADY_REGISTER_DEVICE)

    time = generateCurrentTime()
    insertSQL = """
        INSERT INTO t_quickTalk_notification_device (user_uuid, deviceId, time) VALUES (%s, %s, %s)
    """
    dbManager = DB.DBManager.shareInstanced()
    try: 
        result = dbManager.executeSingleDmlWithArgs(insertSQL, [userUUID, deviceId, time])
        return RESPONSE_JSON(CODE_SUCCESS)
    except Exception as e:
        Loger.error(e, __file__)
        return RESPONSE_JSON(CODE_ERROR_SERVICE)


def __queryWhetherDevice(userUUID, deviceId):
    querySQL = """SELECT user_uuid FROM t_quickTalk_notification_device WHERE deviceId='%s' AND user_uuid='%s'; """ % (deviceId, userUUID)
    dbManager = DB.DBManager.shareInstanced()
    try:
        resultList = dbManager.executeSingleQuery(querySQL)
        if len(resultList) > 0: 
            return True
        else:
            return False
    except Exception as e:
        Loger.error(e, __file__)
        return False


if __name__ == '__main__':
    pass
