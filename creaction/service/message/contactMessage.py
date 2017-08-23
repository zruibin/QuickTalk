#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# contactMessage.py
#
# Created by ruibin.chow on 2017/08/20.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""
查看申请联系的消息，并将未读更新为已读
"""

from service.message import message
from module.database import DB
from module.log.Log import Loger
from config import *
from common.code import *
from common.auth import vertifyTokenHandle
from common.tools import getValueFromRequestByKey, fullPathForMediasFile, parsePageIndex


@message.route('/contact', methods=["GET", "POST"])
@vertifyTokenHandle
def contactMessage():
    userUUID = getValueFromRequestByKey("user_uuid")

    return __queryContactMessageFromStorage(userUUID)


def __queryContactMessageFromStorage(userUUID):
    dataList = None
    querySQL = """
        SELECT uuid, nickname, avatar, 
        t_message_contact.content, t_message_contact.action, t_message_contact.time
        FROM t_user INNER JOIN t_message_contact
        ON t_user.uuid=t_message_contact.content_uuid 
        AND t_message_contact.user_uuid='{userUUID}'
        AND t_message_contact.type={typeStr} AND t_message_contact.status={status}
        ORDER BY time DESC;
    """.format(userUUID=userUUID, typeStr=Config.NOTIFICATION_FOR_CONTACT, 
                    status=Config.TYPE_FOR_MESSAGE_UNREAD)

    updataSQL = """UPDATE t_message_contact SET status=%s WHERE user_uuid='%s' """ % (Config.TYPE_FOR_MESSAGE_READ, userUUID)

    dbManager = DB.DBManager.shareInstanced()
    try: 
        dataList = dbManager.executeSingleQuery(querySQL)
        for data in dataList:
            data["time"] = str(data["time"])
            data["avatar"] = fullPathForMediasFile(Config.UPLOAD_FILE_FOR_USER, 
                                                    data["uuid"], data["avatar"])
        dbManager.executeTransactionDml(updataSQL)
    except Exception as e:
        Loger.error(e, __file__)
        return RESPONSE_JSON(CODE_ERROR_SERVICE)
    else:
        return RESPONSE_JSON(CODE_SUCCESS, dataList)



if __name__ == '__main__':
    pass
