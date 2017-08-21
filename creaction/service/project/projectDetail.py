#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# projectDetail.py
#
# Created by ruibin.chow on 2017/08/18.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""
查看项目(项目详细内容)
"""

from service.project import project
from module.database import DB
from module.log.Log import Loger
from config import *
from common.code import *
from common.tools import getValueFromRequestByKey, fullPathForMediasFile
from common.commonMethods import queryProjectString, limit


@project.route('/project', methods=["GET", "POST"])
def projectDetail():
    projectUUID = getValueFromRequestByKey("project_uuid")
    if projectUUID == None:
        return RESPONSE_JSON(CODE_ERROR_MISS_PARAM)

    return __queryProjectDetailFromStorage(projectUUID)


def __queryProjectDetailFromStorage(projectUUID):
    dataDict = None

    subSQL = """,  t_project.detail FROM  t_project WHERE  t_project.uuid='%s' """ % projectUUID
    queryProjectSQL = queryProjectString(subSQL)
    
    queryResultMediasSQL = """SELECT media_name FROM t_project_media WHERE project_uuid='%s'  AND type=%d ORDER BY sorting ASC;""" % (projectUUID, Config.TYPE_FOR_PROJECT_MEDIAS_PICTURE)

    queryTagsSQL = """ SELECT content FROM t_tag_project WHERE project_uuid='%s' AND type=%d  ORDER BY sorting ASC;""" % (projectUUID, Config.TYPE_FOR_PROJECT_MEDIAS_PICTURE)

    queryMemberSQL = """
        SELECT uuid, avatar, nickname FROM t_user WHERE uuid IN 
        (
            SELECT  user_uuid FROM t_project_user WHERE project_uuid='%s' AND type=%s ORDER BY time ASC
        )
    """ % (projectUUID, Config.TYPE_FOR_PROJECT_MEMBER)

    dbManager = DB.DBManager.shareInstanced()
    try:
        dataList = dbManager.executeSingleQuery(queryProjectSQL)
        if len(dataList) > 0:
            dataDict = dataList[0]
            dataDict["time"] = str(dataDict["time"])

            resulteList = dbManager.executeSingleQuery(queryResultMediasSQL, False)
            resulteList = [fullPathForMediasFile(Config.UPLOAD_FILE_FOR_PROJECT, projectUUID, result[0]) for result in resulteList]
            dataDict["resulteList"] = resulteList

            tagList = dbManager.executeSingleQuery(queryTagsSQL, False)
            tagList = [tag[0] for tag in tagList]
            dataDict["tagList"] = tagList

            memberList = dbManager.executeSingleQuery(queryMemberSQL)
            for member in memberList:
                member["avatar"] = fullPathForMediasFile(Config.UPLOAD_FILE_FOR_USER, member["uuid"], member["avatar"])
            dataDict["memberList"] = memberList
    except Exception as e:
        Loger.error(e, __file__)
        return RESPONSE_JSON(CODE_ERROR_SERVICE)
    else:
        return RESPONSE_JSON(CODE_SUCCESS, dataDict) 

        
if __name__ == '__main__':
    pass
