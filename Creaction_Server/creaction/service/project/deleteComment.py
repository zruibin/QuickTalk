#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# deleteComment.py
#
# Created by ruibin.chow on 2017/08/19.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""
删除评论
"""

from service.project import project
from module.database import DB
from module.log.Log import Loger
from config import *
from common.code import *
from common.auth import vertifyTokenHandle
from common.tools import getValueFromRequestByKey


@project.route('/delete_comment', methods=["GET", "POST"])
@vertifyTokenHandle
def deleteComment():
    userUUID = getValueFromRequestByKey("user_uuid")
    projectUUID = getValueFromRequestByKey("project_uuid")
    commentUUID = getValueFromRequestByKey("comment_uuid")

    if userUUID == None or projectUUID == None or commentUUID == None:
        return RESPONSE_JSON(CODE_ERROR_MISS_PARAM)

    return __deleteCommentInStorage(userUUID, projectUUID, commentUUID) 


def __deleteCommentInStorage(userUUID, projectUUID, commentUUID):
    deleteCommentSQL = """DELETE FROM t_comment WHERE uuid='{commentUUID}' 
        AND project_uuid='{projectUUID}' 
        AND user_uuid='{userUUID}';""".format(userUUID=userUUID, projectUUID=projectUUID,
        commentUUID=commentUUID)
    # 删除评论消息(无论已读或读)
    deleteCommentMessageSQL = """DELETE FROM t_message_comment 
        WHERE content_uuid='{commentUUID}' AND  owner_user_uuid='{userUUID}'; 
        """.format(userUUID=userUUID, commentUUID=commentUUID)

    dbManager = DB.DBManager.shareInstanced()
    try:
        dbManager.executeTransactionMutltiDml([deleteCommentSQL, deleteCommentMessageSQL])
    except Exception as e:
        Loger.error(e, __file__)
        return RESPONSE_JSON(CODE_ERROR_SERVICE)
    else:
        return RESPONSE_JSON(CODE_SUCCESS)


if __name__ == '__main__':
    pass
