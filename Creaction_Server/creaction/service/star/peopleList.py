#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# peopleList.py
#
# Created by ruibin.chow on 2017/08/15.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""
关注的人列表跟粉丝列表
"""

from service.star import star
from module.database import DB
from module.log.Log import Loger
from config import *
from common.code import *
from common.auth import vertifyTokenHandle
from common.tools import getValueFromRequestByKey, fullPathForMediasFile, parsePageIndex
from common.commonMethods import verifyUserIsExists, limit


@star.route('/people_list', methods=["GET", "POST"])
@vertifyTokenHandle
def peopleList():
    userUUID = getValueFromRequestByKey("user_uuid")
    typeStr = getValueFromRequestByKey("type")
    index = getValueFromRequestByKey("index")

    if typeStr == None:
        return RESPONSE_JSON(CODE_ERROR_MISS_PARAM)

    if typeStr not in (Config.TYPE_FOR_USER_QUERY_FOLLOWING, Config.TYPE_FOR_USER_QUERY_FOLLOWED):
        return RESPONSE_JSON(CODE_ERROR_PARAM)

    index = parsePageIndex(index)

    return __getDataListFromStorage(userUUID, typeStr)


def __getDataListFromStorage(userUUID, typeStr, index=1):
    print userUUID, typeStr
    sql = ""
    if typeStr == Config.TYPE_FOR_USER_QUERY_FOLLOWING: # 关注者
        sql = """
            SELECT t_user_user.other_user_uuid FROM t_user_user 
            WHERE t_user_user.user_uuid='%s' AND t_user_user.type=%s ORDER BY t_user_user.time DESC""" % (userUUID, Config.TYPE_FOR_USER_FOLLOWING)
    else: # 粉丝 TYPE_FOR_USER_QUERY_FOLLOWED
        sql = """
            SELECT t_user_user.user_uuid FROM t_user_user 
            WHERE t_user_user.other_user_uuid='%s' AND t_user_user.type=%s ORDER BY t_user_user.time DESC""" % (userUUID, Config.TYPE_FOR_USER_FOLLOWING)

    querySQL = """
        SELECT t_user.uuid, t_user.id, t_user.nickname, t_user.avatar, 
        (SELECT count(t_project.uuid) FROM t_project WHERE t_project.author_uuid=t_user.uuid) AS myproject,
        (SELECT count(t_project_user.type) FROM  t_project_user 
            WHERE t_project_user.user_uuid=t_user.uuid AND type={joinedProject}) AS joinedProject,
        (SELECT count(t_user_user.type) FROM t_user_user 
                WHERE t_user_user.other_user_uuid=t_user.uuid AND type={follow}) AS followed
        FROM t_user 
        WHERE t_user.uuid IN ({sql}) ORDER BY t_user.time DESC {limit};
    """.format(user_uuid=userUUID, joinedProject=Config.TYPE_FOR_PROJECT_MEMBER,
             follow=Config.TYPE_FOR_USER_FOLLOWING, sql=sql, limit=limit(index))

    dbManager = DB.DBManager.shareInstanced()
    try: 
        rows = dbManager.executeSingleQuery(querySQL)
        for row in rows:
            avatar = row["avatar"].strip()
            if len(avatar) > 0:
                row["avatar"] = fullPathForMediasFile(Config.UPLOAD_FILE_FOR_USER, userUUID, avatar)
        return RESPONSE_JSON(CODE_SUCCESS, rows)
    except Exception as e:
        Loger.error(e, __file__)
        return RESPONSE_JSON(CODE_ERROR_SERVICE)


if __name__ == '__main__':
    pass
