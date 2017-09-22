#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# myProjectList.py
#
# Created by ruibin.chow on 2017/08/17.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""
我创建的可行项目列表
"""

from service.project import project
from module.database import DB
from module.log.Log import Loger
from config import *
from common.code import *
from common.auth import vertifyTokenHandle
from common.tools import getValueFromRequestByKey, parsePageIndex
from common.commonMethods import queryProjectDataFromStorageBySubSQL, limit


@project.route('/my_project_list', methods=["GET", "POST"])
@vertifyTokenHandle
def myProjectList():
    userUUID = getValueFromRequestByKey("user_uuid")
    index = getValueFromRequestByKey("index")

    index = parsePageIndex(index)

    return __getMyProjectFromStorage(userUUID, index)


def __getMyProjectFromStorage(userUUID, index):
    limitSQL = limit(index)
    inSQL = """
        SELECT uuid FROM t_project WHERE author_uuid='%s'
                ORDER BY time DESC %s
        """ % (userUUID, limitSQL)

    dbManager = DB.DBManager.shareInstanced()
    try:
        inDataList = dbManager.executeSingleQuery(inSQL)

        if len(inDataList) > 0:
            uuidList = [data["uuid"] for data in inDataList]
            inString = "'" + "','".join(uuidList) + "'"
            dataList = queryProjectDataFromStorageBySubSQL(inString, 1, True)
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

