#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# thirdParty.py
#
# Created by ruibin.chow on 2017/08/11.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""
第三方帐号绑定与解绑
"""

from service.account import account
import os.path
from module.database import DB
from module.log.Log import Loger
from config import *
from common.code import *
from common.auth import vertifyTokenHandle, ThirdPartyAlreadyBeBindException
from common.tools import getValueFromRequestByKey
from common.commonMethods import verifyUserIsExists


@account.route('/third_party', methods=["POST"])
@vertifyTokenHandle
def thirdParty():
    userUUID = getValueFromRequestByKey("user_uuid")
    method = getValueFromRequestByKey("method")
    openId = getValueFromRequestByKey("openId")
    typeStr = getValueFromRequestByKey("type")

    # 验证用户是否存在
    # result = verifyUserIsExists(userUUID) # 没问题则返回文件名列表
    # if not result:  return RESPONSE_JSON(CODE_ERROR_USER_NOT_EXISTS)

    if method not in (Config.TYPE_FOR_AUTH_ACTION_ON,  Config.TYPE_FOR_AUTH_ACTION_OFF):
        return RESPONSE_JSON(CODE_ERROR_PARAM)

    typeDict = {
        Config.TYPE_FOR_AUTH_WECHAT:"wechat",
        Config.TYPE_FOR_AUTH_QQ:"qq",
        Config.TYPE_FOR_AUTH_WEIBO:"weibo",
    }
    typeStr = typeDict[typeStr]

    if typeStr == None:
        return RESPONSE_JSON(CODE_ERROR_PARAM)
   
    if method == Config.TYPE_FOR_AUTH_ACTION_OFF:
        # 解绑
        return __unbindAccount(userUUID, typeStr)
    else:
        # 绑定
        return __bindAccount(userUUID, typeStr, openId)
    pass


def __bindAccount(userUUID, typeStr, openId):
    """绑定第三方帐号，先检查该openId是否已被绑定了，已被绑定则抛出错误"""
    querySQL = """SELECT user_uuid FROM t_user_auth WHERE """+typeStr+"""=%s; """
    updateSQL = """UPDATE t_user_auth SET """+typeStr+"""=%s WHERE user_uuid=%s; """

    dbManager = DB.DBManager.shareInstanced()
    try:
        rows = dbManager.executeSingleQueryWithArgs(querySQL, [openId])

        # 如果已被绑定了则抛出
        if len(rows) > 0: raise ThirdPartyAlreadyBeBindException()
            
        dbManager.executeTransactionDmlWithArgs(updateSQL, [openId, userUUID])
    except ThirdPartyAlreadyBeBindException as e:
        Loger.error(e, __file__)
        return RESPONSE_JSON(CODE_ERROR_THIDR_ALREAD_BE_BIND)
    except Exception as e:
        Loger.error(e, __file__)
        return RESPONSE_JSON(CODE_ERROR_SERVICE)
    else:
        return RESPONSE_JSON(CODE_SUCCESS)
    pass
    

def __unbindAccount(userUUID, typeStr):
    """解除绑定"""
    updateSQL = """UPDATE t_user_auth SET """+typeStr+"""='' WHERE user_uuid=%s; """
    dbManager = DB.DBManager.shareInstanced()
    try:
        dbManager.executeTransactionDmlWithArgs(updateSQL, [userUUID])
    except Exception as e:
        Loger.error(e, __file__)
        return RESPONSE_JSON(CODE_ERROR_SERVICE)
    else:
        return RESPONSE_JSON(CODE_SUCCESS)
    pass




if __name__ == '__main__':
    pass
