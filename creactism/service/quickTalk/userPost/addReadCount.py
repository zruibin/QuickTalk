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

from . import userPost
from module.database import DB
from module.log.Log import Loger
from config import *
from common.code import *
from common.tools import getValueFromRequestByKey


@userPost.route('/addReadCount', methods=["GET", "POST"])
def addReadCount():
    uuid = getValueFromRequestByKey("uuid")
    userUUID = getValueFromRequestByKey("user_uuid")

    if uuid == None:
        return RESPONSE_JSON(CODE_ERROR_MISS_PARAM)

    return __updateActionInStorage(uuid, userUUID)
    

def __updateActionInStorage(uuid, userUUID):
    sqlList = []
    updateSQL = """
        UPDATE t_quickTalk_userPost SET `read_count`=`read_count`+1 WHERE uuid='%s';
    """ % uuid
    sqlList.append(updateSQL)
    if userUUID != None:
        recodSQL = """
            INSERT INTO t_quickTalk_user_read(user_uuid, type, uuid) VALUES ('%s', '%s', '%s'); 
        """ % (userUUID, Config.TYPE_READ_FOR_USERPOST, uuid)
        sqlList.append(recodSQL)
            
    dbManager = DB.DBManager.shareInstanced()
    try: 
        dbManager.executeTransactionMutltiDml(sqlList)
        return RESPONSE_JSON(CODE_SUCCESS)
    except Exception as e:
        Loger.error(e, __file__)
        return RESPONSE_JSON(CODE_ERROR_SERVICE)



if __name__ == '__main__':
    pass
