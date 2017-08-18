#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# changeTag.py
#
# Created by ruibin.chow on 2017/08/09.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""
修改个人兴趣标签
"""
from service.account import account
from flask import Flask, Response, request
import json
from module.database import DB
from module.log.Log import Loger
from config import *
from common.code import *
from common.auth import vertifyTokenHandle
from common.tools import getValueFromRequestByKey


@account.route('/change_tag', methods=["POST"])
@vertifyTokenHandle
def changeTag():
    userUUID = getValueFromRequestByKey("user_uuid")
    taglistStr = getValueFromRequestByKey("taglist")

    taglist = None
    try:
        taglist = json.loads(taglistStr)
    except Exception as e:
        Loger.error(e, __file__)
        return RESPONSE_JSON(CODE_ERROR_ILLEGAL_TAG_CONTENT)

    if __changeUserTagListInStorage(userUUID, taglist):
        return RESPONSE_JSON(CODE_SUCCESS)
    else:
        return RESPONSE_JSON(CODE_ERROR_SERVICE)


def __changeUserTagListInStorage(userUUID, taglist):
    result  = False
    excuteSQLList = []
    deleteSQL = """
        DELETE FROM t_tag_user WHERE user_uuid='%s'; """ % userUUID
    if len(taglist) == 0:
        excuteSQLList.append(deleteSQL)
    else:
        insertSQL = """ INSERT INTO t_tag_user (user_uuid, sorting, type, content) VALUES """
        values = ""
        tagListNum = len(taglist)
        for i in range(tagListNum):
            values += """('%s', %d, %d, '%s'),""" % (userUUID, i, 0, taglist[i])
        values = values[:-1] + ";"
        insertSQL += values
        excuteSQLList.append(insertSQL)

    dbManager = DB.DBManager.shareInstanced()
    try: 
            result = dbManager.executeTransactionMutltiDml(excuteSQLList)
    except Exception as e:
            Loger.error(e, __file__)
    return result
        



if __name__ == '__main__':
    pass
