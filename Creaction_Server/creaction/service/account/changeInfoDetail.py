#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# changeInfoDetail.py
#
# Created by ruibin.chow on 2017/09/07.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""
修改个人简介
"""

from service.account import account
from module.database import DB
from module.log.Log import Loger
from config import *
from common.code import *
from common.auth import vertifyTokenHandle
from common.tools import getValueFromRequestByKey


@account.route('/change_info_detail', methods=["POST"])
@vertifyTokenHandle
def changeInfoDetail():
    userUUID = getValueFromRequestByKey("user_uuid")
    detail = getValueFromRequestByKey("detail")
    

    if detail == None:
        return RESPONSE_JSON(CODE_ERROR_MISS_PARAM)

    if __changeUserInfoDetailInStorage(userUUID, detail):
        return RESPONSE_JSON(CODE_SUCCESS)
    else:
        return RESPONSE_JSON(CODE_ERROR_SERVICE)


def __changeUserInfoDetailInStorage(userUUID, detail):
    result = False
    updateSQL = """UPDATE t_user SET detail=%s WHERE uuid=%s; """
    print updateSQL
    dbManager = DB.DBManager.shareInstanced()
    try: 
            result = dbManager.executeTransactionDmlWithArgs(updateSQL, [detail, userUUID])
    except Exception as e:
            Loger.error(e, __file__)
            
    return result
    


if __name__ == '__main__':
    pass
