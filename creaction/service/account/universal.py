#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# universal.py
#
# Created by ruibin.chow on 2017/08/10.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""
account下需要用到的通用方法
"""
from module.database import DB
from module.log.Log import Loger


def verifyEmailIsExists(email):
    result  = False
    querySQL = """
            SELECT email FROM t_user WHERE email='%s'; """ % email
    dbManager = DB.DBManager.shareInstanced()
    try: 
            resultData = dbManager.executeSingleQuery(querySQL)
            if len(resultData) > 0: result = True
    except Exception as e:
            Loger.error(e, __file__)

    return result


def verifyPhoneIsExists(phone):
    result  = False
    querySQL = """
            SELECT phone FROM t_user WHERE phone='%s'; """ % phone
    dbManager = DB.DBManager.shareInstanced()
    try: 
            resultData = dbManager.executeSingleQuery(querySQL)
            if len(resultData) > 0: result = True
    except Exception as e:
            Loger.error(e, __file__)

    return result


def verifyUserIsExists(userUUID):
    result  = False
    querySQL = """
        SELECT uuid FROM t_user WHERE uuid='%s'; """ % userUUID
    dbManager = DB.DBManager.shareInstanced()
    try: 
            resultData = dbManager.executeSingleQuery(querySQL)
            if len(resultData) > 0: result = True
    except Exception as e:
            Loger.error(e, __file__)

    return result


def verifyUserPassword(userUUID, password):
    result  = False
    querySQL = """
        SELECT password FROM t_user_auth WHERE user_uuid='%s'; """ % userUUID
    dbManager = DB.DBManager.shareInstanced()
    try: 
            resultData = dbManager.executeSingleQuery(querySQL)
            dataPassword = ""
            if len(resultData) > 0 : dataPassword = resultData[0][0]
            if dataPassword == password: result = True
    except Exception as e:
            Loger.error(e, __file__)

    return result



if __name__ == '__main__':
    pass
