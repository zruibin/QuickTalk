#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# submitCircle.py
#
# Created by ruibin.chow on 2017/11/07.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""
提交圈子内容
"""

from service.quickTalk import quickTalk
from module.database import DB
from module.log.Log import Loger
from config import *
from common.code import *
from common.tools import getValueFromRequestByKey, generateUUID, generateCurrentTime


@quickTalk.route('/circle/submitCircle', methods=["GET", "POST"])
def submitCircle():
    userUUID = getValueFromRequestByKey("user_uuid")
    content = getValueFromRequestByKey("content")

    if userUUID == None or content == None:
        return RESPONSE_JSON(CODE_ERROR_MISS_PARAM) 

    return __storageCircle(userUUID, content)
    

def __storageCircle(userUUID, content):
    uuid = generateUUID()
    time = generateCurrentTime()
    insertSQL = "INSERT INTO t_quickTalk_circle (uuid, user_uuid, content, time) VALUES (%s, %s, %s, %s)"
    args = [uuid, userUUID, content, time]
        
    dbManager = DB.DBManager.shareInstanced()
    try: 
        result = dbManager.executeTransactionDmlWithArgs(insertSQL, args)
    except Exception as e:
        Loger.error(e, __file__)
        return RESPONSE_JSON(CODE_ERROR_SERVICE)
    return RESPONSE_JSON(CODE_SUCCESS)
    


if __name__ == '__main__':
    pass
