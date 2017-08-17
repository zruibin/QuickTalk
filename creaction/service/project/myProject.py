#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# myProject.py
#
# Created by ruibin.chow on 2017/08/17.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""
我创建的可行项目
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


@project.route('/my_project', methods=["GET", "POST"])
@vertifyTokenHandle
def myProject():
    userUUID = getValueFromRequestByKey("user_uuid")
    index = getValueFromRequestByKey("index")

    index = parsePageIndex(index)

    return getMyProjectFromStorage(userUUID, index)


def getMyProjectFromStorage(userUUID, index):

    subSQL = """
        , t_project.detail FROM t_project 
        WHERE author_uuid='%s' ORDER BY time DESC """ % userUUID
    querySQL = queryProjectString(subSQL, index)
    print querySQL
    dbManager = DB.DBManager.shareInstanced()
    try:
        dataList = dbManager.executeSingleQuery(querySQL)
        for data in dataList:
            time = data["time"]
            time = str(time) 
            data["time"] = time
        return RESPONSE_JSON(CODE_SUCCESS, dataList) 
        # return RESPONSE_JSON(CODE_SUCCESS) 
    except Exception as e:
        Loger.error(e, __file__)
        return RESPONSE_JSON(CODE_ERROR_SERVICE)
        


if __name__ == '__main__':
    pass


if __name__ == '__main__':
    pass
