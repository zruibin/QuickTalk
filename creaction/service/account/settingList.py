#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# settingList.py
#
# Created by ruibin.chow on 2017/09/06.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""
获得设置列表内容
"""
from service.account import account
from module.database import DB
from module.log.Log import Loger
from config import *
from common.code import *
from common.auth import vertifyTokenHandle
from common.tools import getValueFromRequestByKey


@account.route('/setting_list', methods=["POST", "GET"])
@vertifyTokenHandle
def settingList():
    userUUID = getValueFromRequestByKey("user_uuid")

    # 参数没有直接报错返回
    if userUUID == None:
        return RESPONSE_JSON(CODE_ERROR_MISS_PARAM)

    return __getSettingStatus(userUUID)
    

def __getSettingStatus(userUUID):
    querySQL = """
        SELECT type, status FROM `t_user_setting` WHERE user_uuid='%s'; """ % userUUID
    dbManager = DB.DBManager.shareInstanced()
    try: 
        dataDict = {}
        dataList = dbManager.executeSingleQuery(querySQL)
        for data in dataList:
            dataDict[data["type"]] = data["status"]
            
        return RESPONSE_JSON(CODE_SUCCESS, data=dataDict)
    except Exception as e:
        Loger.error(e, __file__)
        return RESPONSE_JSON(CODE_ERROR_SERVICE)



if __name__ == '__main__':
    pass
