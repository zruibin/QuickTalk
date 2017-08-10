#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# checkContact.py
#
# Created by ruibin.chow on 2017/08/10.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""
查看别人的联系方式
"""
from service.account import account
from flask import Flask, Response, request
from module.database import DB
from module.log.Log import Loger
from config import *
from common.code import *
from common.auth import vertifyTokenHandle
from service.account.universal import verifyUserIsExists

@account.route('/check_contact', methods=["GET"])
# @vertifyTokenHandle
def checkContact():
    
    userUUID = request.args.get("user_uuid")
    checkUserUUID = request.args.get("check_user_uuid")

    # 验证用户是否存在
    result = verifyUserIsExists(checkUserUUID)
    if not result:  return RESPONSE_JSON(CODE_ERROR_USER_NOT_EXISTS)

    dataDict = getPeopleContact(userUUID, checkUserUUID)
    if dataDict == None:
        return RESPONSE_JSON(CODE_ERROR_SERVICE)
    else:
        return RESPONSE_JSON(CODE_SUCCESS, data=dataDict)

"""
{
code:1,
msg:"success",
data:{
    status:"状态(1、已申请过；2、未申请过)",
    qq:"被查看者的qq",
    phone:"被查看者的电话",
    wechat:"被查看者的微信号",
    email:"被查看者的电子邮箱"
}
}
"""
def getPeopleContact(userUUID, checkUserUUID):
    dataDict = None
    querySQL = """
        SELECT uuid, id, contact_phone, contact_email, qq, weibo, wechat
                FROM t_user WHERE uuid IN (SELECT other_user_uuid FROM t_user_user WHERE user_uuid='%s' AND other_user_uuid='%s' AND type='%s');
    """ % (userUUID, checkUserUUID, Config.TYPE_FOR_USER_CONTACT)
    dbManager = DB.DBManager.shareInstanced()
    try: 
            dataDict = {}
            rows = dbManager.executeSingleQuery(querySQL)
            if len(rows) > 0:
                row  = rows[0]
                dataDict["uuid"] = row["uuid"]
                dataDict["userId"] = row["id"]
                dataDict["phone"] = row["contact_phone"]
                dataDict["email"] = row["contact_email"]
                dataDict["qq"] = row["qq"]
                dataDict["weibo"] = row["weibo"]
                dataDict["wechat"] = row["wechat"]
                dataDict["status"] = 1
            else:
                dataDict["status"] = 2

    except Exception as e:
            Loger.error(e, __file__)
            

    return dataDict

if __name__ == '__main__':
    pass
