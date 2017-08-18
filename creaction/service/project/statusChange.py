#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# statusChange.py
#
# Created by ruibin.chow on 2017/08/18.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""
项目状态更改(包含完成、放弃，放弃了的项目只能评论)
"""
from service.project import project
from flask import Flask, Response, request
from module.database import DB
from module.log.Log import Loger
from config import *
from common.code import *
from common.auth import vertifyTokenHandle
from common.tools import getValueFromRequestByKey, parsePageIndex
from common.commonMethods import queryProjectString


@project.route('/status_change', methods=["GET", "POST"])
@vertifyTokenHandle
def statusChange():
    userUUID = getValueFromRequestByKey("user_uuid")
    projectUUID = getValueFromRequestByKey("project_uuid")
    status = getValueFromRequestByKey("status")

    if projectUUID == None or status == None:
        return RESPONSE_JSON(CODE_ERROR_MISS_PARAM)
    
    status = int(status)
    if status not in (Config.TYPE_FOR_PROJECT_STATUS_COMPLETE, Config.TYPE_FOR_PROJECT_STATUS_GIVEUP):
        return RESPONSE_JSON(CODE_ERROR_PARAM)

    return __changeProjectStatus(userUUID, projectUUID, status)
    

def __changeProjectStatus(userUUID, projectUUID, status):
    
    updateSQL = """ UPDATE t_project SET status=%d WHERE uuid='%s' AND author_uuid='%s'; """ % (status, projectUUID, userUUID)
    print  updateSQL
    dbManager = DB.DBManager.shareInstanced()
    try:
        result = dbManager.executeTransactionDml(updateSQL)
        if result == False: raise Exception()
    except Exception as e:
        Loger.error(e, __file__)
        return RESPONSE_JSON(CODE_ERROR_SERVICE)
    else:
        return RESPONSE_JSON(CODE_SUCCESS)



if __name__ == '__main__':
    pass
