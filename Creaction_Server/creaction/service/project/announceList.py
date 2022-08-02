#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# announceList.py
#
# Created by ruibin.chow on 2017/08/22.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""
查看项目公告
"""

from service.project import project
from module.database import DB
from module.log.Log import Loger
from config import *
from common.code import *
from common.auth import vertifyTokenHandle
from common.tools import getValueFromRequestByKey, parsePageIndex
from common.commonMethods import queryProjectDataFromStorageBySubSQL, limit


@project.route('/announce', methods=["GET", "POST"])
# @vertifyTokenHandle
def announceList():
    userUUID = getValueFromRequestByKey("user_uuid")
    projectUUID = getValueFromRequestByKey("project_uuid")
    index = getValueFromRequestByKey("index")

    if projectUUID==None:
        return RESPONSE_JSON(CODE_ERROR_MISS_PARAM) 

    index = parsePageIndex(index)
    return __getProjectAnonunceFromStorage(projectUUID, index)


def __getProjectAnonunceFromStorage(projectUUID, index):
    limitSQL = limit(index)
    sql = """
        SELECT uuid, project_uuid, content, time FROM t_project_announce
        WHERE project_uuid='%s' ORDER BY time DESC %s;
        """ % (projectUUID, limitSQL)
    dbManager = DB.DBManager.shareInstanced()
    try:
        dataDict = dbManager.executeSingleQuery(sql)
        for data in dataDict: data["time"] = str(data["time"])
        return RESPONSE_JSON(CODE_SUCCESS, dataDict)
    except Exception as e:
        Loger.error(e, __file__)
        return RESPONSE_JSON(CODE_ERROR_SERVICE)
    


if __name__ == '__main__':
    pass
