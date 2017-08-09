#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# setting.py
#
# Created by ruibin.chow on 2017/08/09.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""
个人设置(初步为6种消息通知)

PS:是否要走APNS(手机通知栏的显示)的通知，默认为全部都开
1、赞(第一次赞就有通知)
2、评论
3、日志更新
4、关注的可行(1、日志更新；2、可行项目更改；3、邀请加入；4、申请加入；5、踢人；6、主动退出)
5、关注的人(被关注是否有消息通知)
6、联系人消息
"""
from service.account import account
from flask import Flask, Response, request
from module.database import DB
from module.log.Log import Loger
from config import *
from common.code import *
from common.auth import vertifyTokenHandle


@account.route('/setting', methods=["POST"])
@vertifyTokenHandle
def setting():
    userUUID = request.args.get("user_uuid")
    typeStr = request.args.get("type")
    status = request.args.get("status")

    # 参数没有直接报错返回
    if userUUID == None or typeStr == None or status == None:
        return RESPONSE_JSON(CODE_ERROR_MISS_PARAM)

    if changeSettingStatus(userUUID, typeStr, status):
        return RESPONSE_JSON(CODE_SUCCESS)
    else:
        return RESPONSE_JSON(CODE_ERROR_SERVICE)
    

def changeSettingStatus(userUUID, typeStr, status):
    result  = False
    querySQL = """
        UPDATE t_user_setting SET status='%s' WHERE user_uuid='%s' AND type='%s'; """ % (status, userUUID, typeStr)
    dbManager = DB.DBManager.shareInstanced()
    try: 
            result = dbManager.executeSingleDml(querySQL)
    except Exception as e:
            Loger.error(e, __file__)
    return result



if __name__ == '__main__':
    pass
