#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# changeDetail.py
#
# Created by ruibin.chow on 2017/12/04.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 


"""
修改用户简介
"""

from . import account
import os.path
from module.database import DB
from module.log.Log import Loger
from config import *
from common.code import *
from common.tools import getValueFromRequestByKey, fullPathForMediasFile


@account.route('/change_detail', methods=["POST"])
def changeDetail():
    userUUID = getValueFromRequestByKey("user_uuid")
    detail = getValueFromRequestByKey("detail")
    
    if userUUID == None or detail == None:
        return RESPONSE_JSON(CODE_ERROR_MISS_PARAM)

    return __changeUserDetailInStorage(userUUID, detail)


def __changeUserDetailInStorage(userUUID, detail):
   
    updateSQL = """UPDATE t_quickTalk_user SET detail=%s WHERE uuid=%s;
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

