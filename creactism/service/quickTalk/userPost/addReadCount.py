#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# addReadCount.py
#
# Created by ruibin.chow on 2017/12/04.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""
更新阅读数
"""

from service.quickTalk.userPost import userPost
from module.database import DB
from module.log.Log import Loger
from config import *
from common.code import *
from common.tools import getValueFromRequestByKey


@userPost.route('/addReadCount', methods=["GET", "POST"])
def addReadCount():
    uuid = getValueFromRequestByKey("uuid")

    if uuid == None:
        return RESPONSE_JSON(CODE_ERROR_MISS_PARAM)

    return __updateActionInStorage(uuid)
    

def __updateActionInStorage(uuid):
    updateSQL = """
        UPDATE t_quickTalk_userPost SET `read_count`=`read_count`+1 WHERE uuid='%s';
    """ % uuid
            
    dbManager = DB.DBManager.shareInstanced()
    try: 
        dbManager.executeTransactionDml(updateSQL)
        return RESPONSE_JSON(CODE_SUCCESS)
    except Exception as e:
        Loger.error(e, __file__)
        return RESPONSE_JSON(CODE_ERROR_SERVICE)



if __name__ == '__main__':
    pass
