#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# discoverList.py
#
# Created by ruibin.chow on 2017/08/23.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""
发现(根据点赞数从大到小)
"""

from service.discover import discover
from module.database import DB
from module.log.Log import Loger
from config import *
from common.code import *
from common.tools import getValueFromRequestByKey, fullPathForMediasFile, parsePageIndex
from common.commonMethods import queryProjectString


@discover.route('/', methods=["GET", "POST"])
def discoverList():
    # userUUID = getValueFromRequestByKey("user_uuid")
    index = getValueFromRequestByKey("index")
    index = parsePageIndex(index)

    return __queryDiscoverListFromStorage(index)
    

def __queryDiscoverListFromStorage(index):
    
    dataList = None
    subSQL = """, t_project.detail,
        (SELECT count(t_comment.uuid) FROM t_comment WHERE project_uuid=t_project.uuid) AS commentNum FROM t_project ORDER BY t_project.like DESC, t_project.time DESC"""

    dbManager = DB.DBManager.shareInstanced()
    try: 
        querySQL = queryProjectString(subSQL, index)
        # print querySQL
        dataList = dbManager.executeSingleQuery(querySQL)
        dataList = __coverTime(dataList)
    except Exception as e:
        Loger.error(e, __file__)
        return RESPONSE_JSON(CODE_ERROR_SERVICE)
    else:
        return RESPONSE_JSON(CODE_SUCCESS, dataList)
    

"""由于前期数据少，则发现只根据点赞数从大到小列出项目"""
# def __queryDiscoverListByUserTagsFromStorage(userUUID, index):
#     dataList = None
#     queryTagSQL = """SELECT content FROM t_tag_user WHERE user_uuid='%s';""" % userUUID

#     dbManager = DB.DBManager.shareInstanced()
#     try: 
#         dataList = dbManager.executeSingleQuery(queryTagSQL, False)
#         if len(dataList) > 0:
#             dataList = [data[0] for data in dataList]
#             inString = "'" + "','".join(dataList) + "'"
#             print inString

#             subSQL = """, t_project.detail,
#                 (SELECT count(t_comment.uuid) FROM t_comment WHERE project_uuid=t_project.uuid) AS commentNum
#                 FROM t_project WHERE uuid IN (
#                     SELECT project_uuid FROM t_tag_project WHERE t_tag_project.content 
#                         IN ({inString})
#                 )
#                 ORDER BY t_project.time DESC """.format(inString=inString)
#             querySQL = queryProjectString(subSQL, index)
#             print querySQL
#             dataList = dbManager.executeSingleQuery(querySQL)
#             dataList = __coverTime(dataList)
#             return RESPONSE_JSON(CODE_SUCCESS, dataList)
#         else:
#             return __queryDiscoverListFromStorage(index)
#     except Exception as e:
#         Loger.error(e, __file__)
#         return RESPONSE_JSON(CODE_ERROR_SERVICE)
    


def __coverTime(dataList):
    for data in dataList:
            data["time"] = str(data["time"])
    return dataList


if __name__ == '__main__':
    pass
