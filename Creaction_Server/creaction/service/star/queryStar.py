#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# queryStar.py
#
# Created by ruibin.chow on 2017/09/17.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""
查看是否关注了(项目与人)
"""

from service.star import star
from module.database import DB
from module.log.Log import Loger
from config import *
from common.code import *
from common.auth import vertifyTokenHandle
from common.tools import getValueFromRequestByKey, fullPathForMediasFile, generateCurrentTime
from common.commonMethods import verifyUserIsExists


@star.route('/query_star', methods=["GET", "POST"])
@vertifyTokenHandle
def queryStar():
    userUUID = getValueFromRequestByKey("user_uuid")
    typeStr = getValueFromRequestByKey("type")
    uuid = getValueFromRequestByKey("uuid")

    if typeStr == None or uuid == None:
        return RESPONSE_JSON(CODE_ERROR_MISS_PARAM)

    if typeStr == Config.TYPE_FOR_START_PROJECT: # 关注或取消关注项目
        return __queryProjectStar(userUUID, uuid)
    elif typeStr == Config.TYPE_FOR_START_USER: # 关注或取消关注用户
        return __queryUserStar(userUUID, uuid)
    else:
        return RESPONSE_JSON(CODE_ERROR_PARAM)


def __queryProjectStar(userUUID, uuid):
    querySQL = """SELECT project_uuid FROM t_project_user WHERE project_uuid=%s AND user_uuid=%s"""
    data = {"star": "0"}

    dbManager = DB.DBManager.shareInstanced()
    try:
        rows = dbManager.executeSingleQueryWithArgs(querySQL, [uuid, userUUID])
        if len(rows) > 0: data = {"star": "1"}
        return RESPONSE_JSON(CODE_SUCCESS, data) 
    except Exception as e:
        Loger.error(e, __file__)
        return RESPONSE_JSON(CODE_ERROR_SERVICE)


def __queryUserStar(userUUID, uuid):
    querySQL = """SELECT other_user_uuid FROM t_user_user WHERE other_user_uuid=%s AND user_uuid=%s AND type=%s"""
    data = {"star": "0"}

    dbManager = DB.DBManager.shareInstanced()
    try:
        rows = dbManager.executeSingleQueryWithArgs(querySQL, [uuid, userUUID, str(Config.TYPE_FOR_USER_FOLLOWING)])
        if len(rows) > 0: data = {"star": "1"}
        return RESPONSE_JSON(CODE_SUCCESS, data) 
    except Exception as e:
        Loger.error(e, __file__)
        return RESPONSE_JSON(CODE_ERROR_SERVICE)



if __name__ == '__main__':
    pass
