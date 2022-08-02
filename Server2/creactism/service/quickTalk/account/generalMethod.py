#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# generalMethod.py
#
# Created by ruibin.chow on 2017/08/15.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""
需要用到校验的通用方法
"""
from module.database import DB
from module.log.Log import Loger
from config import *
import datetime


def verifyEmailIsExists(email):
    result  = False
    querySQL = """
            SELECT email FROM t_quickTalk_user WHERE email=%s; """
    dbManager = DB.DBManager.shareInstanced()
    try: 
        resultData = dbManager.executeSingleQueryWithArgs(querySQL, [email])
        if len(resultData) > 0: result = True
        # print resultData
    except Exception as e:
        Loger.error(e, __file__)

    return result


def verifyEmailIsExistsForReturnUUID(email):
    result  = None
    querySQL = """
            SELECT uuid FROM t_quickTalk_user WHERE email=%s; """
    dbManager = DB.DBManager.shareInstanced()
    try: 
        resultData = dbManager.executeSingleQueryWithArgs(querySQL, [email])
        if len(resultData) > 0:
            result = resultData[0]["uuid"]
    except Exception as e:
        Loger.error(e, __file__)

    return result


def verifyPhoneIsExists(phone):
    result  = False
    querySQL = """
            SELECT phone FROM t_quickTalk_user WHERE phone=%s; """
    dbManager = DB.DBManager.shareInstanced()
    try: 
        resultData = dbManager.executeSingleQueryWithArgs(querySQL, [phone])
        if len(resultData) > 0: result = True
    except Exception as e:
        Loger.error(e, __file__)

    return result


def verifyPhoneIsExistsForReturnUUID(phone):
    result  = None
    querySQL = """
            SELECT uuid FROM t_quickTalk_user WHERE phone=%s; """
    dbManager = DB.DBManager.shareInstanced()
    try: 
        resultData = dbManager.executeSingleQueryWithArgs(querySQL, [phone])
        if len(resultData) > 0: 
            result = resultData[0]["uuid"]
    except Exception as e:
        Loger.error(e, __file__)
    return result


def verifyUserIsExists(userUUID):
    result  = False
    querySQL = """
        SELECT uuid FROM t_quickTalk_user WHERE uuid=%s; """
    dbManager = DB.DBManager.shareInstanced()
    try: 
        resultData = dbManager.executeSingleQueryWithArgs(querySQL, [userUUID])
        if len(resultData) > 0: result = True
    except Exception as e:
        Loger.error(e, __file__)

    return result


def verifyUserPassword(userUUID, password):
    result  = False
    querySQL = """
        SELECT password FROM t_quickTalk_user_auth WHERE user_uuid=%s; """
    dbManager = DB.DBManager.shareInstanced()
    try: 
        resultData = dbManager.executeSingleQueryWithArgs(querySQL, [userUUID])
        if len(resultData) > 0:
            dataPassword = ""
            dataPassword = resultData[0]["password"]
            if dataPassword == password or  len(dataPassword) == 0: 
                    result = True
        else:
            result = True
    except Exception as e:
        Loger.error(e, __file__)

    return result



if __name__ == '__main__':
    pass

