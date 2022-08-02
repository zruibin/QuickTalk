#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# deleteJournal.py
#
# Created by ruibin.chow on 2017/08/21.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""
删除日志
"""

from service.project import project
from module.database import DB
from module.log.Log import Loger
from config import *
from common.code import *
from common.auth import vertifyTokenHandle
from common.tools import getValueFromRequestByKey
import shutil, os.path


@project.route('/delete_journal', methods=["GET", "POST"])
@vertifyTokenHandle
def deleteJournal():
    userUUID = getValueFromRequestByKey("user_uuid")
    projectUUID = getValueFromRequestByKey("project_uuid")
    journalUUID = getValueFromRequestByKey("journal_uuid")

    if userUUID == None or projectUUID == None or journalUUID == None:
        return RESPONSE_JSON(CODE_ERROR_MISS_PARAM)

    return __deleteJournalInStorage(userUUID, projectUUID, journalUUID)


def __deleteJournalInStorage(userUUID, projectUUID, journalUUID):
    path = Config.FULL_UPLOAD_FOLDER + Config.UPLOAD_FILE_FOR_PROJECT + "/" + projectUUID + "/" + journalUUID + "/"
    sqlList = []
    argsList = []
    
    # 删除日志
    deleteJournalArgs = []
    deleteJournalSQL = """DELETE FROM t_project_journal WHERE uuid=%s 
        AND project_uuid=%s AND user_uuid=%s;"""
    deleteJournalArgs.append(journalUUID)
    deleteJournalArgs.append(projectUUID)
    deleteJournalArgs.append(userUUID)
    sqlList.append(deleteJournalSQL)
    argsList.append(deleteJournalArgs)

    # 删除日志多媒体文件
    deleteJournalMediasArgs = []
    deleteJournalMediasSQL = """
        DELETE FROM t_project_journal_media WHERE journal_uuid=%s 
        AND project_uuid=%s;"""
    deleteJournalMediasArgs.append(journalUUID)
    deleteJournalMediasArgs.append(projectUUID)
    sqlList.append(deleteJournalMediasSQL)
    argsList.append(deleteJournalMediasArgs)

    # 删除日志消息(无论已读或读)
    deleteJournalMessageArgs = []
    deleteJournalMessageSQL = """DELETE FROM t_message_project 
        WHERE content_uuid=%s AND  owner_user_uuid=%s AND type=%s; """
    deleteJournalMessageArgs.append(journalUUID)
    deleteJournalMessageArgs.append(userUUID)
    deleteJournalMessageArgs.append(str(Config.TYPE_FOR_MESSAGE_IN_PROJECT_UPDATE_JOURNAL))
    sqlList.append(deleteJournalMessageSQL)
    argsList.append(deleteJournalMessageArgs)

    dbManager = DB.DBManager.shareInstanced()
    try:
        dbManager.executeTransactionMutltiDmlWithArgsList(sqlList, argsList)
        if os.path.exists(path): shutil.rmtree(path)
    except Exception as e:
        Loger.error(e, __file__)
        return RESPONSE_JSON(CODE_ERROR_SERVICE)
    else:
        return RESPONSE_JSON(CODE_SUCCESS)



if __name__ == '__main__':
    pass
