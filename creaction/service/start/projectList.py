#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# projectList.py
#
# Created by ruibin.chow on 2017/08/16.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""
关注的项目列表
"""
from service.start import start
from flask import Flask, Response, request
from module.database import DB
from module.log.Log import Loger
from config import *
from common.code import *
from common.auth import vertifyTokenHandle
from common.tools import getValueFromRequestByKey
from common.commonMethods import queryProjectDataFromStorageBySubSQL


@start.route('/project_list', methods=["GET", "POST"])
@vertifyTokenHandle
def projectList():
    userUUID = getValueFromRequestByKey("user_uuid")
    index = getValueFromRequestByKey("index")

    if index is None:
        index = 1
    # print type(index)
    index = int(index)

    return getStartProjectFromStorage(userUUID, index)


def getStartProjectFromStorage(userUUID, index=1):
    sql = """
        SELECT project_uuid FROM t_project_user WHERE user_uuid='%s' AND type=%s""" % (userUUID, Config.TYPE_FOR_PROJECT_FOLLOWER)

    try:
        dataDict = queryProjectDataFromStorageBySubSQL(sql, index)
        return RESPONSE_JSON(CODE_SUCCESS, dataDict)
    except Exception as e:
        Loger.error(e, __file__)
        return RESPONSE_JSON(CODE_ERROR_SERVICE)


if __name__ == '__main__':
    pass
