#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# changeInfo.py
#
# Created by ruibin.chow on 2017/11/01.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""
修改用户昵称
"""

from service.quickTalk import quickTalk
import os.path
from module.database import DB
from module.log.Log import Loger
from config import *
from common.code import *
from common.tools import getValueFromRequestByKey, fullPathForMediasFile


@quickTalk.route('/change_info', methods=["POST"])
def changeInfo():
    userUUID = getValueFromRequestByKey("user_uuid")
    nickname = getValueFromRequestByKey("nickname")
    
    if userUUID == None or nickname == None:
        return RESPONSE_JSON(CODE_ERROR_MISS_PARAM)

    return __changeUserInfoInStorage(userUUID, nickname)


def __changeUserInfoInStorage(userUUID, nickname):
   
    updateSQL = """UPDATE t_quickTalk_user SET nickname=%s WHERE uuid=%s;
    """

    dbManager = DB.DBManager.shareInstanced()
    try: 
        action = dbManager.executeTransactionDmlWithArgs(updateSQL, [nickname, userUUID])
        if action:
            return RESPONSE_JSON(CODE_SUCCESS)
        else:
            return RESPONSE_JSON(CODE_ERROR_SERVICE)
    except Exception as e:
        Loger.error(e, __file__)
        return RESPONSE_JSON(CODE_ERROR_SERVICE)
    

if __name__ == '__main__':
    pass
