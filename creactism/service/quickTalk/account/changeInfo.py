#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# changeDetail.py
#
# Created by ruibin.chow on 2017/12/04.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 


"""
修改用户信息
"""

from service.quickTalk.account import account
import os.path
from module.database import DB
from module.log.Log import Loger
from config import *
from common.code import *
from common.tools import getValueFromRequestByKey, fullPathForMediasFile


@account.route('/changeInfo', methods=["POST"])
def changeInfo():
    userUUID = getValueFromRequestByKey("user_uuid")
    typeStr = getValueFromRequestByKey("type")
    data = getValueFromRequestByKey("data")
    
    if userUUID == None or typeStr == None or data == None:
        return RESPONSE_JSON(CODE_ERROR_MISS_PARAM)
    if typeStr not in ("nickname", "phone", "email", "area", "detail"):
        return RESPONSE_JSON(CODE_ERROR_ILLEGAL_REQUEST)

    return  __changeUserInfoInStorage(userUUID, typeStr, data)


def __changeUserInfoInStorage(userUUID, typeStr, data):
   
    updateSQL = """UPDATE t_quickTalk_user SET """+typeStr+"""=%s WHERE uuid=%s;
    """

    dbManager = DB.DBManager.shareInstanced()
    try: 
        action = dbManager.executeTransactionDmlWithArgs(updateSQL, [detail, userUUID])
        if action:
            return RESPONSE_JSON(CODE_SUCCESS)
        else:
            return RESPONSE_JSON(CODE_ERROR_SERVICE)
    except Exception as e:
        Loger.error(e, __file__)
        return RESPONSE_JSON(CODE_ERROR_SERVICE)
    

if __name__ == '__main__':
    pass

