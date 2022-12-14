#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# info.py
#
# Created by ruibin.chow on 2017/08/10.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""
个人详细信息与兴趣标签
"""

from service.account import account
from module.database import DB
from module.log.Log import Loger
from config import *
from common.code import *
from common.auth import vertifyTokenHandle
from common.tools import getValueFromRequestByKey, fullPathForMediasFile


@account.route('/info', methods=["GET"])
def info():
    userUUID = getValueFromRequestByKey("user_uuid")
    if userUUID == None: return RESPONSE_JSON(CODE_ERROR_MISS_PARAM)
    dataDict = __getUserBaseInfo(userUUID)
    if dataDict == None:
        return RESPONSE_JSON(CODE_ERROR_SERVICE)
    else:
        return RESPONSE_JSON(CODE_SUCCESS, data=dataDict)
    

def __getUserBaseInfo(userUUID):
    dataDict = None
    querySQL = """ 
    SELECT t_user.uuid, t_user.id, t_user.nickname, t_user.avatar, t_user.gender, t_user.area, t_user.detail, t_user.career,
        (SELECT count(type) FROM t_user_user WHERE user_uuid=%s AND type=%s) AS following,
        (SELECT count(type) FROM t_user_user WHERE other_user_uuid=%s AND type=%s) AS followed,
        (SELECT count(uuid) FROM t_project WHERE author_uuid=%s) AS myproject,
        (SELECT count(type) FROM  t_project_user WHERE user_uuid=%s AND type=%s) AS joinedProject,
        (SELECT count(type) FROM  t_project_user WHERE user_uuid=%s AND type=%s) AS followedProject
        FROM t_user WHERE t_user.uuid=%s 
    """
    args = [userUUID, str(Config.TYPE_FOR_USER_FOLLOWING),
                userUUID, str(Config.TYPE_FOR_USER_FOLLOWING),
                userUUID, 
                userUUID, str(Config.TYPE_FOR_PROJECT_MEMBER),
                userUUID, str(Config.TYPE_FOR_PROJECT_FOLLOWER), 
                userUUID
                ]

    querySchoolSQL = """
    SELECT school FROM t_user_eduction WHERE user_uuid=%s ORDER BY sorting ASC
    """
    queryUserTagSQL = """
    SELECT content FROM t_tag_user WHERE user_uuid=%s ORDER BY sorting ASC
    """

    dbManager = DB.DBManager.shareInstanced()
    try: 
            dataDict = {}
            rows = dbManager.executeSingleQueryWithArgs(querySQL, args)
            row  = rows[0]
            avatar = row["avatar"].strip()
            if len(avatar) > 0:
                avatar = fullPathForMediasFile(Config.UPLOAD_FILE_FOR_USER, userUUID, avatar)
            dataDict["uuid"] = row["uuid"]
            dataDict["userId"] = row["id"]
            dataDict["nickname"] = row["nickname"]
            dataDict["avatar"] = avatar
            dataDict["gender"] = row["gender"]
            dataDict["location"] = row["area"]
            dataDict["detail"] = row["detail"]
            dataDict["career"] = row["career"]
            dataDict["myAndjoinedProject"] = row["myproject"] + row["joinedProject"]
            dataDict["followedProject"] = row["followedProject"]
            dataDict["following"] = row["following"]
            dataDict["followed"] = row["followed"]

            rows = dbManager.executeSingleQueryWithArgs(querySchoolSQL, [userUUID], False)
            schoolList = []
            for row in rows:
                schoolList.append(row[0])
            dataDict["school"] = schoolList

            rows = dbManager.executeSingleQueryWithArgs(queryUserTagSQL, [userUUID], False)
            tagsList = []
            for row in rows:
                tagsList.append(row[0])
            dataDict["tag"] = tagsList

    except Exception as e:
            Loger.error(e, __file__)

    return dataDict
    

if __name__ == '__main__':
    pass
