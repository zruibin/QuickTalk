#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# projectUpdate.py
#
# Created by ruibin.chow on 2017/08/23.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""
可行成员、日志更新(包含申请通知、邀请通知、踢人与自主退出等消息记录)、可行项目内容更改
"""

from service.message import message
from module.database import DB
from module.log.Log import Loger
from config import *
from common.code import *
from common.auth import vertifyTokenHandle
from common.tools import getValueFromRequestByKey, fullPathForMediasFile


@message.route('/project_update', methods=["GET", "POST"])
@vertifyTokenHandle
def projectUpdate():
    userUUID = getValueFromRequestByKey("user_uuid")

    return __queryProjectMessageFromStorage(userUUID)


"""
    # 项目相关的消息类型,
    TYPE_FOR_MESSAGE_IN_PROJECT_UPDATE_JOURNAL = 1 # 日志更新

    TYPE_FOR_MESSAGE_IN_PROJECT_UPDATE_PROJECT = 2 # 可行项目更改

    TYPE_FOR_MESSAGE_IN_PROJECT_FOR_INVITE = 3 # 邀请加入
    TYPE_FOR_MESSAGE_IN_PROJECT_TO_APPLY = 4 # 申请加入
    TYPE_FOR_MESSAGE_IN_PROJECT_TO_REMOVE = 5 # 踢人
    TYPE_FOR_MESSAGE_IN_PROJECT_TO_WITHDRAW = 6 # 主动退出
    TYPE_FOR_MESSAGE_IN_PROJECT_INVITE_AGREE = 7 # 同意邀请加入
    TYPE_FOR_MESSAGE_IN_PROJECT_APPLY_AGREE = 8 # 作者同意加入
"""

def __queryProjectMessageFromStorage(userUUID):
    dataList = []
    querySQL = """
        SELECT user_uuid, type, content_uuid AS project_uuid,  t_message_project.time,
            owner_user_uuid, t_message_project.status, content, action,
            t_user.nickname, t_user.avatar, t_project.title
        FROM t_message_project INNER JOIN t_user INNER JOIN t_project
        ON t_message_project.user_uuid='%s' AND t_message_project.status=%d
            AND t_user.uuid=t_message_project.owner_user_uuid
            AND t_project.uuid=t_message_project.content_uuid;
    """ % (userUUID, Config.TYPE_FOR_MESSAGE_UNREAD)

    updataMessageSQL = """UPDATE t_message_project SET status=%s WHERE user_uuid='%s' """ % (Config.TYPE_FOR_MESSAGE_READ, userUUID)

    dbManager = DB.DBManager.shareInstanced()
    try: 
        dataList = dbManager.executeSingleQuery(querySQL)
        for data in dataList:
            data["time"] = str(data["time"])
            data["avatar"] = fullPathForMediasFile(Config.UPLOAD_FILE_FOR_USER, 
                                                    data["owner_user_uuid"], data["avatar"])

        dbManager.executeTransactionDml(updataMessageSQL)
    except Exception as e:
        Loger.error(e, __file__)
        return RESPONSE_JSON(CODE_ERROR_SERVICE)
    else:
        return RESPONSE_JSON(CODE_SUCCESS, dataList)



if __name__ == '__main__':
    pass
