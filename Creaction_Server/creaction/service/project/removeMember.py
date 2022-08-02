#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# removeMember.py
#
# Created by ruibin.chow on 2017/08/21.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""
作者移除成员
"""

from service.project import project
from module.database import DB
from module.log.Log import Loger
from config import *
from common.code import *
from common.auth import vertifyTokenHandle
from common.tools import getValueFromRequestByKey
from common.commonMethods import verifyProjectMember


@project.route('/remove_member', methods=["GET", "POST"])
@vertifyTokenHandle
def removeMember():
    projectUUID = getValueFromRequestByKey("project_uuid")
    memberUUID = getValueFromRequestByKey("member_uuid")

    if projectUUID == None or memberUUID== None:
        return RESPONSE_JSON(CODE_ERROR_MISS_PARAM)

    if verifyProjectMember(memberUUID, projectUUID) == False:
        return RESPONSE_JSON(CODE_ERROR_QUERY_PROJECT_MEMBER)

    return __removeMemberInStorage(projectUUID, memberUUID)


def __removeMemberInStorage(projectUUID, memberUUID):
    deleteSQL = """
        DELETE FROM t_project_user WHERE project_uuid=%s AND user_uuid=%s AND type=%s
    """
    deleteArgs = [projectUUID, memberUUID, Config.TYPE_FOR_PROJECT_MEMBER]

    dbManager = DB.DBManager.shareInstanced()
    try:
        dbManager.executeTransactionDmlWithArgs(deleteSQL, deleteArgs)
    except Exception as e:
        Loger.error(e, __file__)
        return RESPONSE_JSON(CODE_ERROR_SERVICE)
    else:
        return RESPONSE_JSON(CODE_SUCCESS)



if __name__ == '__main__':
    pass
