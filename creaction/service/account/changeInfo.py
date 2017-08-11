#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# changeInfo.py
#
# Created by ruibin.chow on 2017/08/11.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""
修改个人信息
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


@account.route('/change_info', methods=["POST"])
@vertifyTokenHandle
def changeInfo():
    userUUID = getValueFromRequestByKey("user_uuid")
    userdata = getValueFromRequestByKey("userdata")
    
    userDict = None
    try:
        userDict = json.loads(userdata)
    except Exception as e:
        Loger.error(e, __file__)
        return RESPONSE_JSON(CODE_ERROR_ILLEGAL_DATA_CONTENT)
    pass

    if len(userDict) < 6:
        return RESPONSE_JSON(CODE_ERROR_PARAM)

    if changeUserInfoInStorage(userUUID, userDict):
        return RESPONSE_JSON(CODE_SUCCESS)
    else:
        return RESPONSE_JSON(CODE_ERROR_SERVICE)


def changeUserInfoInStorage(userUUID, userDict):
    result = False
    excuteSQLList = []
    
    deleteSQL = """DELETE FROM t_user_eduction WHERE user_uuid='%s'""" % userUUID
    excuteSQLList.append(deleteSQL)

    schoolList = userDict["school"]
    if len(schoolList) != 0:
        insertSQL = """INSERT INTO t_user_eduction (user_uuid, sorting, school) VALUES """
        values = ""
        schoolListNum = len(schoolList)
        for i in range(schoolListNum):
            tempString = """('%s', %d, '%s')""" % (userUUID, i, schoolList[i])
            values += tempString + ","
        values = values[:-1] + ";"
        insertSQL += values
        excuteSQLList.append(insertSQL)

    updateSQL = """
        UPDATE t_user SET nickname='%s', gender=%d, area='%s', detail='%s', career='%s'
        WHERE uuid='%s'; """ % (userDict["nickname"], int(userDict["gender"]), 
        userDict["area"], userDict["detail"], userDict["career"], userUUID)
    excuteSQLList.append(updateSQL)

    dbManager = DB.DBManager.shareInstanced()
    try: 
            result = dbManager.executeTransactionMutltiDml(excuteSQLList)
    except Exception as e:
            Loger.error(e, __file__)
            
    return result
    





if __name__ == '__main__':
    pass
