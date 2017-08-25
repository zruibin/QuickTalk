#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# addAndDeleteAnnounce.py
#
# Created by ruibin.chow on 2017/08/22.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""
新增或删除项目公告
"""

from service.project import project
from module.database import DB
from module.log.Log import Loger
from config import *
from common.code import *
from common.auth import vertifyTokenHandle
from common.tools import getValueFromRequestByKey, generateUUID, generateCurrentTime


@project.route('/add_and_delete_announce', methods=["GET", "POST"])
@vertifyTokenHandle
def addAndDeleteAnnounce():
    projectUUID = getValueFromRequestByKey("project_uuid")
    action = int(getValueFromRequestByKey("action")) # 新增或删除(1、新增，2删除)
    authorUUID = getValueFromRequestByKey("author_uuid")
    uuid = getValueFromRequestByKey("uuid")
    content = getValueFromRequestByKey("content")

    if action == 1:
        return __addAnnounce(projectUUID, content)
    elif action == 2:
        return __deleteAnnounce(uuid, projectUUID)
    else:
        return RESPONSE_JSON(CODE_ERROR_MISS_PARAM)


def __addAnnounce(projectUUID, content):
    if projectUUID==None or content==None:
        return RESPONSE_JSON(CODE_ERROR_MISS_PARAM) 
    uuid = generateUUID()
    time = generateCurrentTime()
    insertSQL = """
        INSERT INTO t_project_announce (uuid, project_uuid, content, time)
        VALUES ('%s', '%s', '%s', '%s');
    """ % (uuid, projectUUID, content, time)

    dbManager = DB.DBManager.shareInstanced()
    try:
        dbManager.executeTransactionDml(insertSQL)
    except Exception as e:
        Loger.error(e, __file__)
        return RESPONSE_JSON(CODE_ERROR_SERVICE)
    else:
        return RESPONSE_JSON(CODE_SUCCESS)
    

def __deleteAnnounce(uuid, projectUUID):
    if uuid==None or projectUUID==None:
        return RESPONSE_JSON(CODE_ERROR_MISS_PARAM) 

    deleteSQL = """
        DELETE FROM t_project_announce WHERE uuid='%s' AND project_uuid='%s';
    """ % (uuid, projectUUID)
    
    dbManager = DB.DBManager.shareInstanced()
    try:
        dbManager.executeTransactionDml(deleteSQL)
    except Exception as e:
        Loger.error(e, __file__)
        return RESPONSE_JSON(CODE_ERROR_SERVICE)
    else:
        return RESPONSE_JSON(CODE_SUCCESS)
    

if __name__ == '__main__':
    pass
