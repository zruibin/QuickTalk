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
# @vertifyTokenHandle
def deleteJournal():
    userUUID = getValueFromRequestByKey("user_uuid")
    projectUUID = getValueFromRequestByKey("project_uuid")
    journalUUID = getValueFromRequestByKey("journal_uuid")

    if userUUID == None or projectUUID == None or journalUUID == None:
        return RESPONSE_JSON(CODE_ERROR_MISS_PARAM)

    return __deleteJournalInStorage(userUUID, projectUUID, journalUUID)


def __deleteJournalInStorage(userUUID, projectUUID, journalUUID):
    path = Config.FULL_UPLOAD_FOLDER + Config.UPLOAD_FILE_FOR_PROJECT + "/" + projectUUID + "/" + journalUUID + "/"
    # 删除日志
    deleteJournalSQL = """DELETE FROM t_project_journal WHERE uuid='{journalUUID}' 
        AND project_uuid='{projectUUID}' 
        AND user_uuid='{userUUID}';""".format(userUUID=userUUID, projectUUID=projectUUID,
                journalUUID=journalUUID)
    # 删除日志多媒体文件
    deleteJournalMediasSQL = """
        DELETE FROM t_project_journal_media WHERE journal_uuid='{journalUUID}' 
        AND project_uuid='{projectUUID}';
    """.format(projectUUID=projectUUID,  journalUUID=journalUUID)
    # 删除日志消息(无论已读或读)
    deleteJournalMessageSQL = """DELETE FROM t_message_project 
        WHERE content_uuid='{journalUUID}' AND  owner_user_uuid='{userUUID}' 
        AND type={typeStr}; 
        """.format(userUUID=userUUID, journalUUID=journalUUID,  
                typeStr=Config.TYPE_FOR_MESSAGE_IN_PROJECT_UPDATE_JOURNAL)

    dbManager = DB.DBManager.shareInstanced()
    try:
        dbManager.executeTransactionMutltiDml([deleteJournalSQL, deleteJournalMediasSQL, 
                                                    deleteJournalMessageSQL])
        if os.path.exists(path): shutil.rmtree(path)
    except Exception as e:
        Loger.error(e, __file__)
        return RESPONSE_JSON(CODE_ERROR_SERVICE)
    else:
        return RESPONSE_JSON(CODE_SUCCESS)



if __name__ == '__main__':
    pass
