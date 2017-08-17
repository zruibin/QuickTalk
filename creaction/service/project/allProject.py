#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# allProject.py
#
# Created by ruibin.chow on 2017/08/17.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""
全部可行项目(我参与的、我关注的、我创建的)
"""
from service.project import project
from flask import Flask, Response, request
from module.database import DB
from module.log.Log import Loger
from config import *
from common.code import *
from common.auth import vertifyTokenHandle
from common.tools import getValueFromRequestByKey, parsePageIndex
from common.commonMethods import queryProjectDataFromStorageBySubSQL, limit


@project.route('/all_project', methods=["GET", "POST"])
@vertifyTokenHandle
def allProject():
    userUUID = getValueFromRequestByKey("user_uuid")
    index = getValueFromRequestByKey("index")

    index = parsePageIndex(index)

    return getAllProjectFromStorage(userUUID, index)


def getAllProjectFromStorage(userUUID, index=1):
    limitSQL = limit(index)
    sql = """
        SELECT uuid FROM (
        (SELECT project_uuid AS uuid,  time FROM t_project_user WHERE user_uuid='{userUUID}' GROUP BY project_uuid {limitSQL})
        UNION
        (SELECT uuid, time FROM t_project WHERE author_uuid='{userUUID}' {limitSQL})

        ORDER BY time DESC
        ) AS t_temp_table
        """.format(userUUID=userUUID, limitSQL=limitSQL)
    try:
        dataDict = queryProjectDataFromStorageBySubSQL(sql, 1, True)
        return RESPONSE_JSON(CODE_SUCCESS, dataDict)
    except Exception as e:
        Loger.error(e, __file__)
        return RESPONSE_JSON(CODE_ERROR_SERVICE)


if __name__ == '__main__':
    pass

