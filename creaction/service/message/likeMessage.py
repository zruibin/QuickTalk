#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# likeMessage.py
#
# Created by ruibin.chow on 2017/08/23.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""
别人赞的消息

TYPE_FOR_LIKE_IN_PROJECT = "1" # 项目
TYPE_FOR_LIKE_IN_COMMENT = "2" # 评论
TYPE_FOR_LIKE_IN_JOURNAL = "3" # 日志
"""

from service.message import message
from module.database import DB
from module.log.Log import Loger
from config import *
from common.code import *
from common.auth import vertifyTokenHandle
from common.tools import getValueFromRequestByKey, fullPathForMediasFile, parsePageIndex
from common.commonMethods import limit


@message.route('/like', methods=["GET", "POST"])
@vertifyTokenHandle
def likeMessage():
    userUUID = getValueFromRequestByKey("user_uuid")
    noUpdate = getValueFromRequestByKey("no_update")
    return __queryLikeFromStorage(userUUID, noUpdate)


def __queryLikeFromStorage(userUUID, noUpdate):
    dataList = None
    querySQL = """
        SELECT uuid, nickname, avatar, 
            t_message_like.content, t_message_like.time, t_message_like.content_uuid,
            t_message_like.type,

            (CASE  
                WHEN t_message_like.type=1 THEN (SELECT title FROM t_project 
                                WHERE t_project.uuid=t_message_like.content_uuid) 
                WHEN t_message_like.type=2 THEN (SELECT t_comment.content FROM t_comment    
                                WHERE t_comment.uuid=t_message_like.content_uuid)
                WHEN t_message_like.type=3 THEN (SELECT t_project_journal.content FROM
                                     t_project_journal 
                                WHERE t_project_journal.uuid=t_message_like.content_uuid) 
                ELSE ' '  
            END) AS tip

        FROM t_user INNER JOIN t_message_like
            ON t_user.uuid=t_message_like.owner_user_uuid 
            AND t_message_like.user_uuid='{userUUID}'
            AND t_message_like.status={status}
        ORDER BY t_message_like.time DESC;
    """.format(userUUID=userUUID, typeStr=Config.NOTIFICATION_FOR_CONTACT, 
                    status=Config.TYPE_FOR_MESSAGE_UNREAD)

    updataSQL = """UPDATE t_message_like SET status=%s WHERE user_uuid='%s' """ % (Config.TYPE_FOR_MESSAGE_READ, userUUID)

    dbManager = DB.DBManager.shareInstanced()
    try: 
        dataList = dbManager.executeSingleQuery(querySQL)
        for data in dataList:
            data["time"] = str(data["time"])
            data["avatar"] = fullPathForMediasFile(Config.UPLOAD_FILE_FOR_USER, 
                                                    data["uuid"], data["avatar"])

        if noUpdate == None:
            dbManager.executeTransactionDml(updataSQL)
    except Exception as e:
        Loger.error(e, __file__)
        return RESPONSE_JSON(CODE_ERROR_SERVICE)
    else:
        return RESPONSE_JSON(CODE_SUCCESS, dataList)
    




if __name__ == '__main__':
    pass
