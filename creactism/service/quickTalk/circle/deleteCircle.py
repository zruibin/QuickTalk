#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# deleteCircle.py
#
# Created by ruibin.chow on 2017/11/07.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""
删除圈子
"""

from service.quickTalk import quickTalk
from module.database import DB
from module.log.Log import Loger
from config import *
from common.code import *
from common.tools import getValueFromRequestByKey


@quickTalk.route('/circle/deleteCircle', methods=["GET", "POST"])
def deleteCircle():
    uuid = getValueFromRequestByKey("uuid")
    userUUID = getValueFromRequestByKey("user_uuid")
    if uuid == None or userUUID == None:
        return RESPONSE_JSON(CODE_ERROR_MISS_PARAM) 
    return __deleteAction(uuid, userUUID)
    

def __deleteAction(uuid, userUUID):
    deleteTopicSQL = """DELETE FROM t_quickTalk_circle WHERE uuid='%s' AND user_uuid='%s';""" % (uuid, userUUID)

    dbManager = DB.DBManager.shareInstanced()
    try: 
            dbManager.executeTransactionDml(deleteTopicSQL)
    except Exception as e:
        Loger.error(e, __file__)
        return RESPONSE_JSON(CODE_ERROR_SERVICE)
    else:
        return RESPONSE_JSON(CODE_SUCCESS)
    


if __name__ == '__main__':
    pass
