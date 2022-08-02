#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# memberList.py
#
# Created by ruibin.chow on 2017/08/21.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""
查看项目成员
"""

from service.project import project
from module.database import DB
from module.log.Log import Loger
from config import *
from common.code import *
from common.tools import getValueFromRequestByKey, fullPathForMediasFile


@project.route('/member_list', methods=["GET", "POST"])
def memberList():
    projectUUID = getValueFromRequestByKey("project_uuid")

    if projectUUID == None:
        return RESPONSE_JSON(CODE_ERROR_MISS_PARAM)

    return __queryMemberInStorage(projectUUID)


def __queryMemberInStorage(projectUUID):
    memberList = None
    queryMemberSQL = """
        SELECT uuid, avatar, nickname FROM t_user WHERE uuid IN 
        (
            SELECT  user_uuid FROM t_project_user WHERE project_uuid='%s' AND type=%s ORDER BY time ASC
        )
    """ % (projectUUID, Config.TYPE_FOR_PROJECT_MEMBER)
    dbManager = DB.DBManager.shareInstanced()
    try:
        memberList = dbManager.executeSingleQuery(queryMemberSQL)
        for member in memberList:
            member["avatar"] = fullPathForMediasFile(Config.UPLOAD_FILE_FOR_USER, member["uuid"], member["avatar"])
    except Exception as e:
        Loger.error(e, __file__)
        return RESPONSE_JSON(CODE_ERROR_SERVICE)
    else:
        return RESPONSE_JSON(CODE_SUCCESS, memberList) 
    


if __name__ == '__main__':
    pass
