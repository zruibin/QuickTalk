#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# myJoined.py
#
# Created by ruibin.chow on 2017/08/17.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""
我参与的可行
"""
from service.project import project
from flask import Flask, Response, request
from module.database import DB
from module.log.Log import Loger
from config import *
from common.code import *
from common.auth import vertifyTokenHandle
from common.tools import getValueFromRequestByKey, parsePageIndex
from common.commonMethods import queryProjectString, limit


@project.route('/my_joined', methods=["GET", "POST"])
@vertifyTokenHandle
def myJoinedProject():
    userUUID = getValueFromRequestByKey("user_uuid")
    index = getValueFromRequestByKey("index")
    index = parsePageIndex(index)
    return __getMyJoinedProjectFromStorage(userUUID, index)


def __getMyJoinedProjectFromStorage(userUUID, index):
    """由于mysql中不支持IN子查询中的limit，则先查询出所有in的子查询数据，不为空则再进一步查询"""
    limitSQL = limit(index)
    inSQL = """
        SELECT project_uuid AS uuid FROM t_project_user WHERE user_uuid='%s' AND type=%s
                ORDER BY time DESC %s
        """ % (userUUID, Config.TYPE_FOR_PROJECT_MEMBER, limitSQL)
    
    dbManager = DB.DBManager.shareInstanced()
    try:
        dataList = dbManager.executeSingleQuery(inSQL)
        if len(dataList) > 0:
            uuidList = [data["uuid"] for data in dataList]
            inString = "'" + "','".join(uuidList) + "'"
            subSQL = """, t_project.detail FROM t_project WHERE uuid IN (%s) """ % inString
            querySQL = queryProjectString(subSQL, 1)
            dataList = dbManager.executeSingleQuery(querySQL)
            for data in dataList:
                time = data["time"]
                time = str(time) 
                data["time"] = time
            return RESPONSE_JSON(CODE_SUCCESS, dataList) 
        else:
            return RESPONSE_JSON(CODE_SUCCESS) 
        
    except Exception as e:
        Loger.error(e, __file__)
        return RESPONSE_JSON(CODE_ERROR_SERVICE)
        
        
if __name__ == '__main__':
    pass
