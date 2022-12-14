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
from module.database import DB
from module.log.Log import Loger
from config import *
from common.code import *
from common.auth import vertifyTokenHandle
from common.tools import getValueFromRequestByKey
import json


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

    if len(userDict) < 5:
        return RESPONSE_JSON(CODE_ERROR_PARAM)

    if __changeUserInfoInStorage(userUUID, userDict):
        return RESPONSE_JSON(CODE_SUCCESS)
    else:
        return RESPONSE_JSON(CODE_ERROR_SERVICE)


def __changeUserInfoInStorage(userUUID, userDict):
    result = False
    excuteSQLList = []
    argsList = []

    deleteSQL = """DELETE FROM t_user_eduction WHERE user_uuid=%s;"""
    excuteSQLList.append(deleteSQL)
    argsList.append([userUUID])

    schoolList = userDict["school"]
    if len(schoolList) != 0:
        insertSQL = """INSERT INTO t_user_eduction (user_uuid, sorting, school) VALUES """
        values = ""
        i = 0
        valuesList = []
        for school in schoolList:
            tempString = """(%s, %s, %s)"""
            values += tempString + ","
            i += 1
            valuesList.append(userUUID)
            valuesList.append(str(i))
            valuesList.append(school)
        values = values[:-1] + ";"
        insertSQL += values
        excuteSQLList.append(insertSQL)
        argsList.append(valuesList)

    updateSQL = """
        UPDATE t_user SET nickname=%s, gender=%s, area=%s, career=%s WHERE uuid=%s; """
    excuteSQLList.append(updateSQL)
    argsList.append([userDict["nickname"], userDict["gender"], userDict["area"], userDict["career"], userUUID])

    dbManager = DB.DBManager.shareInstanced()
    try: 
            result = dbManager.executeTransactionMutltiDmlWithArgsList(excuteSQLList, argsList)
    except Exception as e:
            Loger.error(e, __file__)
            
    return result
    


if __name__ == '__main__':
    pass
