#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# deleteUserPostComment.py
#
# Created by ruibin.chow on 2017/12/04.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""
删除userPost评论
"""

from service.quickTalk.userPost import userPost
from module.database import DB
from module.log.Log import Loger
from config import *
from common.code import *
from common.tools import getValueFromRequestByKey


@userPost.route('/deleteUserPostComment', methods=["POST"])
def deleteUserPostComment():
    userPostUUID = getValueFromRequestByKey("userPost_uuid")
    userUUID = getValueFromRequestByKey("user_uuid")
    commentUUID = getValueFromRequestByKey("comment_uuid")

    if userPostUUID == None or commentUUID == None or userUUID == None:
        return RESPONSE_JSON(CODE_ERROR_MISS_PARAM)

    return __deleteUserPostCommentInStorage(userPostUUID, commentUUID, userUUID)
    

def __deleteUserPostCommentInStorage(userPostUUID, commentUUID, userUUID):

    deleteSQL = """DELETE FROM t_quickTalk_userPost_comment WHERE uuid='%s' AND user_uuid='%s' AND userPost_uuid='%s'; """ % (commentUUID, userUUID, userPostUUID)
        
    dbManager = DB.DBManager.shareInstanced()
    try: 
        result = dbManager.executeTransactionDml(deleteSQL)
    except Exception as e:
        Loger.error(e, __file__)
        return RESPONSE_JSON(CODE_ERROR_SERVICE)
    return RESPONSE_JSON(CODE_SUCCESS)
    


if __name__ == '__main__':
    pass