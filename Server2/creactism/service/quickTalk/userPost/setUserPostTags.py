#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# setUserPostTags.py
#
# Created by ruibin.chow on 2018/01/15.
# Copyright (c) 2018年 ruibin.chow All rights reserved.
# 

"""

"""

from . import userPost
from module.database import DB
from module.log.Log import Loger
from config import *
from common.code import *
from common.tools import getValueFromRequestByKey, generateUUID, generateCurrentTime
import json
from .addUserPost import generateUserPostTagsSQL


@userPost.route('/setUserPostTags', methods=["POST"])
def setUserPostTags():
    userPostUUID = getValueFromRequestByKey("userPost_uuid")
    # userUUID = getValueFromRequestByKey("user_uuid")
    tagsString = getValueFromRequestByKey("tagsString")

    if userPostUUID == None or tagsString == None:
        return RESPONSE_JSON(CODE_ERROR_MISS_PARAM)

    tagList = []
    try:
        tagList = json.loads(tagsString)
    except Exception, e:
        Loger.error(e, __file__)
        return RESPONSE_JSON(CODE_ERROR_ILLEGAL_DATA_CONTENT)

    return __storageUserPostTags(userPostUUID, tagList)


def __storageUserPostTags(userPostUUID, tagList):
    sqlList = []
    argsList = []

    sqlList, argsList = generateUserPostTagsSQL(userPostUUID, tagList, sqlList, argsList)
    
    # DLog(sqlList, False)
    # DLog(argsList)
    dbManager = DB.DBManager.shareInstanced()
    try: 
        dbManager.executeTransactionMutltiDmlWithArgsList(sqlList, argsList)
    except Exception as e:
        Loger.error(e, __file__)
        return RESPONSE_JSON(CODE_ERROR_SERVICE)
    return RESPONSE_JSON(CODE_SUCCESS)



if __name__ == '__main__':
    pass
