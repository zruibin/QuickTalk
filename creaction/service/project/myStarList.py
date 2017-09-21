#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# myStarList.py
#
# Created by ruibin.chow on 2017/09/21.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""
我关注的可行
"""

from service.project import project
from module.database import DB
from module.log.Log import Loger
from config import *
from common.code import *
from common.auth import vertifyTokenHandle
from common.tools import getValueFromRequestByKey, parsePageIndex
from common.commonMethods import queryProjectDataFromStorageBySubSQL, limit


@project.route('/my_star_list', methods=["GET", "POST"])
@vertifyTokenHandle
def myStarProjectList():
    userUUID = getValueFromRequestByKey("user_uuid")
    index = getValueFromRequestByKey("index")
    index = parsePageIndex(index)
    return __getMyStarProjectFromStorage(userUUID, index)


def __getMyStarProjectFromStorage(userUUID, index):
    """由于mysql中不支持IN子查询中的limit，则先查询出所有in的子查询数据，不为空则再进一步查询"""
    limitSQL = limit(index)
    inSQL = """
        SELECT project_uuid AS uuid FROM t_project_user WHERE user_uuid='%s' AND type=%s
                ORDER BY time DESC %s
        """ % (userUUID, Config.TYPE_FOR_PROJECT_FOLLOWER, limitSQL)
    
    dbManager = DB.DBManager.shareInstanced()
    try:
        dataList = dbManager.executeSingleQuery(inSQL)
        if len(dataList) > 0:
            uuidList = [data["uuid"] for data in dataList]
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
