#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# searchProjectByTag.py
#
# Created by ruibin.chow on 2017/08/16.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""
根据标签搜索项目
"""

from service.search import search
from module.database import DB
from module.log.Log import Loger
from config import *
from common.code import *
from common.tools import getValueFromRequestByKey, fullPathForMediasFile, parsePageIndex
from common.commonMethods import queryProjectString


@search.route('/search_project_by_tag', methods=["GET", "POST"])
def searchProjectByTag():
    searchText = getValueFromRequestByKey("searchText")
    index = getValueFromRequestByKey("index")

    if searchText == None:
        return RESPONSE_JSON(CODE_ERROR_MISS_PARAM)

    index = parsePageIndex(index)
    
    return __searchProjectByTagInStorage(searchText, index)
    

def __searchProjectByTagInStorage(searchText, index):
    dataList = None
    searchText = "%" + searchText + "%"

    subSQL = """
        , t_project.detail,
        (SELECT count(t_comment.uuid) FROM t_comment WHERE project_uuid=t_project.uuid) AS commentNum
        FROM t_project WHERE uuid IN (
            SELECT project_uuid FROM t_tag_project WHERE t_tag_project.content LIKE %s)
        ORDER BY t_project.time DESC """

    dbManager = DB.DBManager.shareInstanced()
    try: 
        querySQL = queryProjectString(subSQL, index)
        dataList = dbManager.executeSingleQueryWithArgs(querySQL, [searchText])
        for data in dataList:
            time = data["time"]
            time = str(time)
            data["time"] = time
    except Exception as e:
        Loger.error(e, __file__)
        return RESPONSE_JSON(CODE_ERROR_SERVICE)
    else:
        return RESPONSE_JSON(CODE_SUCCESS, dataList)


if __name__ == '__main__':
    pass
