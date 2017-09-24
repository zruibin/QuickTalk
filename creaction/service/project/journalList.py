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
    userUUID = getValueFromRequestByKey("user_uuid")
    index = getValueFromRequestByKey("index")

    index = parsePageIndex(index)
    if projectUUID == None:
        return RESPONSE_JSON(CODE_ERROR_MISS_PARAM)

    return __queryJournalFromStorage(projectUUID, index, userUUID)


def __queryJournalFromStorage(projectUUID, index, userUUID):
    limitStr = limit(index)
    querySQL = ""
    if userUUID == None:
        querySQL = """
            SELECT t_temp.journal_uuid, t_temp.project_uuid, user_uuid, t_temp.time, `like`,content, nickname, avatar, t_project_journal_media.media_name, t_project_journal_media.sorting FROM 
            (
            SELECT t_project_journal.uuid AS journal_uuid, 
                    t_project_journal.project_uuid, 
                    t_project_journal.user_uuid, 
                    t_project_journal.time, `like`, content,
                    t_user.nickname, t_user.avatar
                    FROM t_project_journal, t_user
                    WHERE t_project_journal.project_uuid='{projectUUID}' 
                        AND t_user.uuid=t_project_journal.user_uuid
                    ORDER BY t_project_journal.time DESC {limitStr}
            ) AS t_temp 
            LEFT JOIN t_project_journal_media 
            ON t_project_journal_media.journal_uuid=t_temp.journal_uuid
                        AND  t_project_journal_media.type={typeStr} ;
        """.format(projectUUID=projectUUID, limitStr=limitStr,
                typeStr=Config.TYPE_FOR_PROJECT_MEDIAS_PICTURE)
    else:
        querySQL = """
            SELECT t_temp.journal_uuid, t_temp.project_uuid, user_uuid, t_temp.time, `like`,content, likeStatus, nickname, avatar, t_project_journal_media.media_name, t_project_journal_media.sorting FROM 
            (
            SELECT t_project_journal.uuid AS journal_uuid, 
                    t_project_journal.project_uuid, 
                    t_project_journal.user_uuid, 
                    t_project_journal.time, `like`, content,
                    (SELECT count(content_uuid) FROM t_like 
                        WHERE content_uuid=t_project_journal.uuid 
                        AND user_uuid='{userUUID}' AND type='{likeType}'
                    ) AS likeStatus,
                    t_user.nickname, t_user.avatar
                    FROM t_project_journal, t_user
                    WHERE t_project_journal.project_uuid='{projectUUID}' 
                        AND t_user.uuid=t_project_journal.user_uuid
                    ORDER BY t_project_journal.time DESC {limitStr}
            ) AS t_temp 
            LEFT JOIN t_project_journal_media 
            ON t_project_journal_media.journal_uuid=t_temp.journal_uuid
                        AND  t_project_journal_media.type={typeStr} ;
        """.format(projectUUID=projectUUID, limitStr=limitStr,
                typeStr=Config.TYPE_FOR_PROJECT_MEDIAS_PICTURE, userUUID=userUUID, likeType=Config.TYPE_FOR_LIKE_IN_JOURNAL)
    # print querySQL
    dbManager = DB.DBManager.shareInstanced()
    try:
        dataDict = dbManager.executeSingleQuery(querySQL)
        dataDict = __packageData(projectUUID, dataDict)
        return RESPONSE_JSON(CODE_SUCCESS, dataDict)
    except Exception as e:
        Loger.error(e, __file__)
        return RESPONSE_JSON(CODE_ERROR_SERVICE)
 

def __packageData(projectUUID, dataDict):
    journalUUIDList = []
    for data in dataDict:
        if data["media_name"] is not None:
            path = projectUUID + "/" + data["journal_uuid"]
            data["media_name"] = fullPathForMediasFile(Config.UPLOAD_FILE_FOR_PROJECT, path, data["media_name"])
        data["time"] = str(data["time"])
        data["avatar"] = fullPathForMediasFile(Config.UPLOAD_FILE_FOR_USER, data["user_uuid"], data["avatar"])
        journalUUID = data["journal_uuid"]
        if journalUUID not in journalUUIDList:
            journalUUIDList.append(journalUUID)

    tempDict = {}
    for data in dataDict:
        journalUUID = data["journal_uuid"]
        if not tempDict.has_key(journalUUID):
            tempDict[journalUUID] = data

    # 整理多媒体数据
    mediaDict = {}
    for data in dataDict:
        journalUUID = data["journal_uuid"]
        if not mediaDict.has_key(journalUUID):
            mediaDict[journalUUID] = []
        if data["media_name"] is not None:
            sortingMediaDict = {str(data["sorting"]) : data["media_name"]}
            mediaDict[journalUUID].append(sortingMediaDict)

    # 归整多媒体数据
    for key, mediaList in mediaDict.items():
        count = len(mediaList)
        medias = []
        for index in range(count):
            for media in mediaList:
                if media.has_key(str(index)): 
                    medias.append(media[str(index)])   
        mediaDict[key] = medias

    # 添加多媒体字段
    for key, value in tempDict.items():
        if mediaDict.has_key(key):
            value["medias"] = mediaDict[key]
        del value["media_name"]
        del value["sorting"]

    outputList = []
    for journalUUID in journalUUIDList:
        outputList.append(tempDict[journalUUID])

    return outputList



if __name__ == '__main__':
    pass
