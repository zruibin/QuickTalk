#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# contact.py
#
# Created by ruibin.chow on 2017/08/10.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""
我的联系方式
"""
from service.account import account
from flask import Flask, Response, request
from module.database import DB
from module.log.Log import Loger
from config import *
from common.code import *
from common.auth import vertifyTokenHandle
from common.tools import getValueFromRequestByKey


@account.route('/contact', methods=["GET"])
@vertifyTokenHandle
def contact():
    userUUID = getValueFromRequestByKey("user_uuid")
    dataDict = __getMyContactList(userUUID)
    if dataDict == None:
        return RESPONSE_JSON(CODE_ERROR_SERVICE)
    else:
        return RESPONSE_JSON(CODE_SUCCESS, data=dataDict)


def __getMyContactList(userUUID):
    dataDict = None
    querySQL = """
        SELECT uuid, id, contact_phone, contact_email, qq, weibo, wechat
                FROM t_user WHERE uuid='%s';
    """ % userUUID
    exchangeSQL = """
        SELECT uuid, id, nickname, avatar FROM t_user 
        WHERE uuid IN (SELECT other_user_uuid FROM t_user_user WHERE user_uuid='%s')
    """ % userUUID
    dbManager = DB.DBManager.shareInstanced()
    try: 
            dataDict = {}
            rows = dbManager.executeSingleQuery(querySQL)
            row  = rows[0]
            dataDict["uuid"] = row["uuid"]
            dataDict["userId"] = row["id"]
            dataDict["phone"] = row["contact_phone"]
            dataDict["email"] = row["contact_email"]
            dataDict["qq"] = row["qq"]
            dataDict["weibo"] = row["weibo"]
            dataDict["wechat"] = row["wechat"]

            rows = dbManager.executeSingleQuery(exchangeSQL)
            exchangeList = []
            for row in rows:
                exchangeList.append(row)
            dataDict["exchange"] = exchangeList

    except Exception as e:
            Loger.error(e, __file__)

    return dataDict


if __name__ == '__main__':
    pass
