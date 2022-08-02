#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# timeline.py
#
# Created by ruibin.chow on 2017/08/20.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""
时间轴
"""

from service.user import user
from module.database import DB
from module.log.Log import Loger
from config import *
from common.code import *
from common.auth import vertifyTokenHandle
from common.tools import getValueFromRequestByKey, fullPathForMediasFile, parsePageIndex
from common.commonMethods import verifyUserIsExists, limit


@user.route('/timeline', methods=["GET", "POST"])
@vertifyTokenHandle
def userTimeline():
    userUUID = getValueFromRequestByKey("user_uuid")
    return __getUserTimelineFromStorage(userUUID)
    

def __getUserTimelineFromStorage(userUUID):
    dataDict = {}
    queryTimeProjectSQL = """
        SELECT uuid AS project_uuid, title, author_uuid, time, over_time AS overTime, status
        FROM t_project WHERE uuid IN (
            SELECT uuid FROM t_project WHERE author_uuid='{userUUID}'
            UNION
            SELECT project_uuid AS uuid FROM t_project_user WHERE user_uuid='{userUUID}' AND type={typeStr}
        ) ORDER BY time DESC LIMIT 0,3;
    """.format(userUUID=userUUID, typeStr=Config.TYPE_FOR_PROJECT_MEMBER)
    queryUserRegisterTimeSQL = """SELECT time FROM t_user WHERE uuid='%s'; """ % userUUID
    dbManager = DB.DBManager.shareInstanced()
    try: 

        dataList = dbManager.executeSingleQuery(queryTimeProjectSQL)
        for data in dataList:
            data["time"] = str(data["time"])
            data["overTime"] = str(data["overTime"])
        dataDict["timeline"] = dataList
        dataList = dbManager.executeSingleQuery(queryUserRegisterTimeSQL)
        dataDict["joinTime"] = str(dataList[0]["time"])
    except Exception as e:
        Loger.error(e, __file__)
        return RESPONSE_JSON(CODE_ERROR_SERVICE)
    else:
        return RESPONSE_JSON(CODE_SUCCESS, dataDict)


if __name__ == '__main__':
    pass
