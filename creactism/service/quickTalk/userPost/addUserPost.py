#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# addUserPost.py
#
# Created by ruibin.chow on 2017/12/04.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""
新增userPost
"""

from service.quickTalk.userPost import userPost
from module.database import DB
from module.log.Log import Loger
from config import *
from common.code import *
from common.tools import getValueFromRequestByKey, generateUUID, generateCurrentTime
from dispatch.notification import dispatchNotificationNewShare


@userPost.route('/addUserPost', methods=["POST"])
def addUserPost():
    title = getValueFromRequestByKey("title")
    content = getValueFromRequestByKey("content")
    txt = getValueFromRequestByKey("txt")
    userUUID = getValueFromRequestByKey("user_uuid")

    if title == None or content == None or userUUID == None:
        return RESPONSE_JSON(CODE_ERROR_MISS_PARAM)

    return __storageUserPost(title, content, userUUID, txt)
    

def __storageUserPost(title, content, userUUID, txt):
    uuid = generateUUID()
    time = generateCurrentTime()
    insertSQL = "INSERT INTO t_quickTalk_userPost (uuid, user_uuid, title, txt, content, time) VALUES (%s, %s, %s, %s, %s, %s)"
    args = [uuid, userUUID, title, txt, content, time]
        
    dbManager = DB.DBManager.shareInstanced()
    try: 
        result = dbManager.executeTransactionDmlWithArgs(insertSQL, args)
        # 远程通知
        dispatchNotificationNewShare.delay(userUUID)
    except Exception as e:
        Loger.error(e, __file__)
        return RESPONSE_JSON(CODE_ERROR_SERVICE)
    return RESPONSE_JSON(CODE_SUCCESS)
    



if __name__ == '__main__':
    pass
