#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# deleteDevice.py
#
# Created by ruibin.chow on 2017/12/25.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""
删除通知设备
"""

from service.quickTalk.account import account
from module.database import DB
from module.log.Log import Loger
from config import *
from common.code import *
from common.tools import getValueFromRequestByKey
from common.auth import vertifyTokenHandle


@account.route('/deleteDevice', methods=["POST", "GET"])
@vertifyTokenHandle
def deleteDeviceRequest():
    userUUID = getValueFromRequestByKey("user_uuid")
    deviceId = getValueFromRequestByKey("deviceId")

    # 参数没有直接报错返回
    if userUUID == None or deviceId == None:
        return RESPONSE_JSON(CODE_ERROR_MISS_PARAM)

    return __deleteDevice(userUUID, deviceId)
        

def __deleteDevice(userUUID, deviceId):

    deleteSQL = """
        DELETE FROM t_quickTalk_notification_device WHERE deviceId=%s AND user_uuid=%s;  
    """
    dbManager = DB.DBManager.shareInstanced()
    try: 
        result = dbManager.executeSingleDmlWithArgs(deleteSQL, [deviceId, userUUID])
        return RESPONSE_JSON(CODE_SUCCESS)
    except Exception as e:
        Loger.error(e, __file__)
        return RESPONSE_JSON(CODE_ERROR_SERVICE)



if __name__ == '__main__':
    pass
