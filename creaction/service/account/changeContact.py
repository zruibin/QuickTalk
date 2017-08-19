#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# changeContact.py
#
# Created by ruibin.chow on 2017/08/09.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""
修改个人联系方式
"""

from service.account import account
from module.database import DB
from module.log.Log import Loger
from config import *
from common.code import *
from common.auth import vertifyTokenHandle
from common.tools import getValueFromRequestByKey


@account.route('/change_contact', methods=["POST"])
@vertifyTokenHandle
def changeContact():
    userUUID = getValueFromRequestByKey("user_uuid")
    typeStr = getValueFromRequestByKey("type")
    content = getValueFromRequestByKey("content")

    if __changeUserContactStorage(userUUID, typeStr, content):
        return RESPONSE_JSON(CODE_SUCCESS)
    else:
        return RESPONSE_JSON(CODE_ERROR_SERVICE)


""" 
TYPE_FOR_WECHAT = “3”
TYPE_FOR_QQ = “4”
TYPE_FOR_WEIBO = “5”
TYPE_FOR_CONTACT_PHONE = “6”
TYPE_FOR_CONTACT_EMAIL = “7”
"""

def __changeUserContactStorage(userUUID, typeStr, content):
    result  = False
    typeDict = {
        Config.TYPE_FOR_WECHAT : "wechat",
        Config.TYPE_FOR_QQ : "qq",
        Config.TYPE_FOR_WEIBO : "weibo",
        Config.TYPE_FOR_CONTACT_PHONE : "contact_phone",
        Config.TYPE_FOR_CONTACT_EMAIL : "contact_email",
    }
    typeContent = typeDict[typeStr]
    if typeContent == None: return False

    updateSQL = """
        UPDATE t_user SET %s='%s' WHERE uuid='%s'; """ % (typeContent, content, userUUID)
    dbManager = DB.DBManager.shareInstanced()
    try: 
            result = dbManager.executeSingleDml(updateSQL)
    except Exception as e:
            Loger.error(e, __file__)

    return result
    

if __name__ == '__main__':
    pass
