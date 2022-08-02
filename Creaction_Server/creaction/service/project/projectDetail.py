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
    userUUID = getValueFromRequestByKey("user_uuid")
    if projectUUID == None:
        return RESPONSE_JSON(CODE_ERROR_MISS_PARAM)

    return __queryProjectDetailFromStorage(projectUUID, userUUID)


def __queryProjectDetailFromStorage(projectUUID, userUUID):
    dataDict = None
    
    subSQL = ""
    if userUUID == None:
        subSQL = """,  t_project.detail, t_project.result
            FROM  t_project WHERE  t_project.uuid='%s' """ % projectUUID
    else:
        subSQL = """,  t_project.detail, t_project.result,
            (SELECT count(content_uuid) FROM t_like WHERE content_uuid='{projectUUID}' AND user_uuid='{userUUID}' AND type='{likeType}') AS likeStatus,
            (SELECT count(project_uuid) FROM t_project_user WHERE project_uuid='{projectUUID}' AND user_uuid='{userUUID}' AND type='{starType}') AS StarStatus
            FROM  t_project WHERE  t_project.uuid='{projectUUID}' """.format(projectUUID=projectUUID, userUUID=userUUID, likeType=Config.TYPE_FOR_LIKE_IN_PROJECT, starType=Config.TYPE_FOR_PROJECT_FOLLOWER)
    queryProjectSQL = queryProjectString(subSQL)

    queryResultMediasSQL = """SELECT media_name FROM t_project_media WHERE project_uuid='%s'  AND type=%d ORDER BY sorting ASC;""" % (projectUUID, Config.TYPE_FOR_PROJECT_MEDIAS_PICTURE)

    queryTagsSQL = """ SELECT content FROM t_tag_project WHERE project_uuid='%s' AND type=%d  ORDER BY sorting ASC;""" % (projectUUID, Config.TYPE_FOR_PROJECT_MEDIAS_PICTURE)

    queryMemberSQL = """
        SELECT uuid, avatar, nickname FROM t_user WHERE uuid IN 
        (
            SELECT author_uuid AS user_uuid FROM t_project WHERE 		 
            uuid='%s'
			UNION
            SELECT  user_uuid FROM t_project_user WHERE project_uuid='%s' AND type=%s ORDER BY time ASC
        )
    """ % (projectUUID, projectUUID, Config.TYPE_FOR_PROJECT_MEMBER)

    queryPlanSQL = """
        SELECT content, start_time AS startTime, finish_time AS finishTime FROM t_project_plan WHERE project_uuid='%s' ORDER BY sorting ASC;
    """ % (projectUUID)

    dbManager = DB.DBManager.shareInstanced()
    try:
        dataList = dbManager.executeSingleQuery(queryProjectSQL)
        if len(dataList) > 0:
            dataDict = dataList[0]
            dataDict["time"] = str(dataDict["time"])

            resulteList = dbManager.executeSingleQuery(queryResultMediasSQL, False)
            resulteList = [fullPathForMediasFile(Config.UPLOAD_FILE_FOR_PROJECT, projectUUID, result[0]) for result in resulteList]
            dataDict["resultMedias"] = resulteList

            tagList = dbManager.executeSingleQuery(queryTagsSQL, False)
            tagList = [tag[0] for tag in tagList]
            dataDict["tagList"] = tagList

            memberList = dbManager.executeSingleQuery(queryMemberSQL)
            for member in memberList:
                member["avatar"] = fullPathForMediasFile(Config.UPLOAD_FILE_FOR_USER, member["uuid"], member["avatar"])
            dataDict["memberList"] = memberList

            planList = dbManager.executeSingleQuery(queryPlanSQL)
            for plan in planList:
                plan["startTime"] = str(plan["startTime"])
                plan["finishTime"] = str(plan["finishTime"])
            dataDict["planList"] = planList
    except Exception as e:
        Loger.error(e, __file__)
        return RESPONSE_JSON(CODE_ERROR_SERVICE)
    else:
        return RESPONSE_JSON(CODE_SUCCESS, dataDict) 

        
if __name__ == '__main__':
    pass
