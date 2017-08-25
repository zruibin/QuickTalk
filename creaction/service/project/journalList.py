#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# journalList.py
#
# Created by ruibin.chow on 2017/08/21.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""
查看项目日志
"""

from service.project import project
from module.database import DB
from module.log.Log import Loger
from config import *
from common.code import *
from common.tools import getValueFromRequestByKey, fullPathForMediasFile, parsePageIndex
from common.commonMethods import limit


@project.route('/journal', methods=["GET", "POST"])
def journalList():
    projectUUID = getValueFromRequestByKey("project_uuid")
    index = getValueFromRequestByKey("index")

    index = parsePageIndex(index)
    if projectUUID == None:
        return RESPONSE_JSON(CODE_ERROR_MISS_PARAM)

    return __queryJournalFromStorage(projectUUID, index)


def __queryJournalFromStorage(projectUUID, index):
    limitStr = limit(index)
    querySQL = """
        SELECT t_project_journal.uuid AS journal_uuid, t_project_journal.project_uuid, user_uuid, t_project_journal.time, `like`, content,
        t_user.nickname, t_user.avatar,
        t_project_journal_media.media_name, t_project_journal_media.sorting
        FROM t_project_journal 
        LEFT JOIN t_user
            ON project_uuid='{projectUUID}' AND t_user.uuid=t_project_journal.user_uuid
        LEFT JOIN t_project_journal_media
            ON t_project_journal_media.journal_uuid=t_project_journal.uuid 
            AND  t_project_journal_media.type={typeStr}
        ORDER BY t_project_journal.time DESC {limitStr};
    """.format(projectUUID=projectUUID, limitStr=limitStr,
            typeStr=Config.TYPE_FOR_PROJECT_MEDIAS_PICTURE)

    dbManager = DB.DBManager.shareInstanced()
    try:
        dataDict = dbManager.executeSingleQuery(querySQL)
        dataDict = __packageData(projectUUID, dataDict)
        return RESPONSE_JSON(CODE_SUCCESS, dataDict)
    except Exception as e:
        Loger.error(e, __file__)
        return RESPONSE_JSON(CODE_ERROR_SERVICE)
 

def __packageData(projectUUID, dataDict):
    projectUUIDList = []
    for data in dataDict:
        if data["media_name"] is not None:
            del data["sorting"]
            path = projectUUID + "/" + data["journal_uuid"]
            data["media_name"] = fullPathForMediasFile(Config.UPLOAD_FILE_FOR_PROJECT, path, data["media_name"])
        data["time"] = str(data["time"])
        data["avatar"] = fullPathForMediasFile(Config.UPLOAD_FILE_FOR_USER, data["user_uuid"], data["avatar"])
        projectUUIDList.append(data["journal_uuid"])

    #日志归整
    uuidList = list(set(projectUUIDList))
    uuidList.sort(key = projectUUIDList.index)

    tempDict = {}
    for data in dataDict:
        if not tempDict.has_key(data["journal_uuid"]):
            tempDict[data["journal_uuid"]] = data

    mediaDict = {}
    for data in dataDict:
        if not mediaDict.has_key(data["journal_uuid"]):
            mediaDict[data["journal_uuid"]] = []
        mediaDict[data["journal_uuid"]].append(data["media_name"])

    for key, value in tempDict.items():
        if mediaDict.has_key(key):
            value["medias"] = mediaDict[key]
        del value["media_name"]

    return tempDict.values()



if __name__ == '__main__':
    pass
