#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# changeArea.py
#
# Created by ruibin.chow on 2017/12/04.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""
修改用户地区
"""

from . import account
import os.path
from module.database import DB
from module.log.Log import Loger
from config import *
from common.code import *
from common.tools import getValueFromRequestByKey, fullPathForMediasFile


@account.route('/change_area', methods=["POST"])
def changeArea():
    userUUID = getValueFromRequestByKey("user_uuid")
    area = getValueFromRequestByKey("area")
    
    if userUUID == None or area == None:
        return RESPONSE_JSON(CODE_ERROR_MISS_PARAM)

    return __changeUserAreaInStorage(userUUID, area)


def __changeUserAreaInStorage(userUUID, area):
   
    updateSQL = """UPDATE t_quickTalk_user SET area=%s WHERE uuid=%s;
    """

    dbManager = DB.DBManager.shareInstanced()
    try: 
        action = dbManager.executeTransactionDmlWithArgs(updateSQL, [area, userUUID])
        if action:
            return RESPONSE_JSON(CODE_SUCCESS)
        else:
            return RESPONSE_JSON(CODE_ERROR_SERVICE)
    except Exception as e:
        Loger.error(e, __file__)
        return RESPONSE_JSON(CODE_ERROR_SERVICE)
    

if __name__ == '__main__':
    pass
