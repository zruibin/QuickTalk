#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# searchUser.py
#
# Created by ruibin.chow on 2017/08/16.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""
根据昵称搜索用户
"""

from service.search import search
from module.database import DB
from module.log.Log import Loger
from config import *
from common.code import *
from common.tools import getValueFromRequestByKey, fullPathForMediasFile, parsePageIndex
from common.commonMethods import verifyUserIsExists, limit


@search.route('/search_user', methods=["GET", "POST"])
def searchUser():
    searchText = getValueFromRequestByKey("searchText")
    userUUID = getValueFromRequestByKey("user_uuid")
    index = getValueFromRequestByKey("index")

    if searchText == None:
        return RESPONSE_JSON(CODE_ERROR_MISS_PARAM)

    index = parsePageIndex(index)

    return __searchUserByNickName(searchText, userUUID, index)


def __searchUserByNickName(searchText, userUUID, index):
    dataList = None

    isFollowingSQL = ""
    subWhereSQL = ""
    if userUUID is not None:
        isFollowingSQL = " AND t_user_user.user_uuid='%s' " % userUUID
        subWhereSQL = " AND t_user.uuid!='%s' " % userUUID
        
    querySQL = """
    SELECT id, uuid, nickname, avatar,
    (SELECT count(user_uuid) FROM t_user_user WHERE t_user_user.other_user_uuid=t_user.uuid AND t_user_user.other_user_uuid={following}) AS fansNum,

    SUM(
    (SELECT COUNT(project_uuid) FROM t_project_user WHERE t_project_user.user_uuid=t_user.uuid AND t_project_user.type={member})
    + 
    (SELECT count(t_project.uuid) FROM t_project WHERE t_project.author_uuid=t_user.uuid)
    ) AS projectNum,

    (SELECT COUNT(user_uuid) FROM t_user_user 
    WHERE t_user_user.other_user_uuid=t_user.uuid 
    AND t_user_user.type=1 
    {isFollowingSQL}
    ) AS isFollowing

    FROM t_user WHERE t_user.nickname LIKE '%{searchText}%' 
    {subWhereSQL} ORDER BY t_user.time DESC  {limit} 
    """.format(following=Config.TYPE_FOR_USER_FOLLOWING,
        member=Config.TYPE_FOR_PROJECT_MEMBER, isFollowingSQL=isFollowingSQL,
        searchText=searchText, subWhereSQL=subWhereSQL, limit=limit(index))

    dbManager = DB.DBManager.shareInstanced()
    try: 
        dataList = dbManager.executeSingleQuery(querySQL)
        for data in dataList:
            if userUUID is not None: data["isFollowing"] = 0
            data["projectNum"] = int(data["projectNum"])
            avatar = data["avatar"].strip()
            if len(avatar) > 0:
                avatar = fullPathForMediasFile(Config.UPLOAD_FILE_FOR_USER, data["uuid"], avatar)
                data["avatar"] = avatar
    except Exception as e:
        Loger.error(e, __file__)
        return RESPONSE_JSON(CODE_ERROR_SERVICE)
    else:
        return RESPONSE_JSON(CODE_SUCCESS, dataList)


if __name__ == '__main__':
    pass
