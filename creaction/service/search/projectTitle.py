#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# projectTitle.py
#
# Created by ruibin.chow on 2017/08/16.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""
根据标题搜索
"""
from service.search import search
from flask import Flask, Response, request
from module.database import DB
from module.log.Log import Loger
from config import *
from common.code import *
from common.tools import getValueFromRequestByKey, fullPathForMediasFile
from common.commonMethods import verifyUserIsExists, queryProjectString


@search.route('/project_title', methods=["GET", "POST"])
def projectTitle():
    searchText = getValueFromRequestByKey("searchText")
    index = getValueFromRequestByKey("index")

    if searchText == None:
        return RESPONSE_JSON(CODE_ERROR_MISS_PARAM)

    if index is None:
        index = 1
    index = int(index)
    
    return searchByProjectTitle(searchText, index)


def searchByProjectTitle(searchText, index):
    dataDict = None

    subSQL = """, t_tag_project.content AS tag FROM t_project, t_tag_project
        WHERE t_tag_project.project_uuid=t_project.uuid AND t_project.title LIKE '%{searchText}%'  ORDER BY t_project.time  """.format(searchText=searchText)

    dbManager = DB.DBManager.shareInstanced()
    try: 
        querySQL = queryProjectString(subSQL, index)
        tempDict = dbManager.executeSingleQuery(querySQL)
        dataDict = packageData(tempDict)
    except Exception as e:
        Loger.error(e, __file__)
        return RESPONSE_JSON(CODE_ERROR_SERVICE)
    else:
        return RESPONSE_JSON(CODE_SUCCESS, dataDict)
    

def packageData(dataDict):
    projectUUIDList = []
    for data in dataDict:
        projectUUIDList.append(data["uuid"])
        time = data["time"]
        time = str(time) 
        data["time"] = time

    uuidList = list(set(projectUUIDList))
    uuidList.sort(key = projectUUIDList.index)

    tempDict = {}
    for data in dataDict:
        if not tempDict.has_key(data["uuid"]):
            tempDict[data["uuid"]] = data

    # tempDict = {data["uuid"]:data for data in dataDict if not tempDict.has_key(data["uuid"])}
    
    tagDict = {}
    for data in dataDict:
        if not tagDict.has_key(data["uuid"]):
            tagDict[data["uuid"]] = []
        tagDict[data["uuid"]].append(data["tag"])

    datatList = []
    for uuid in uuidList:
        data = tempDict[uuid]
        data["tag"] = tagDict[uuid]
        datatList.append(data)
        
    return datatList
    


if __name__ == '__main__':
    pass
