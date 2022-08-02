#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# deleteComment.py
#
# Created by ruibin.chow on 2017/10/26.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""
删除评论
"""

from . import news
from module.database import DB
from module.log.Log import Loger
from config import *
from common.code import *
from common.tools import getValueFromRequestByKey


@news.route('/deleteComment', methods=["GET", "POST"])
def deleteComment():
    topicUUID = getValueFromRequestByKey("topic_uuid")
    uuid = getValueFromRequestByKey("uuid")
    return __deleteAction(uuid, topicUUID)
    

def __deleteAction(uuid, topicUUID):
    deleteCommentSQL = """DELETE FROM t_quickTalk_topic_comment WHERE topic_uuid='%s' AND uuid='%s';""" % (topicUUID, uuid)

    dbManager = DB.DBManager.shareInstanced()
    try: 
            dbManager.executeTransactionDml(deleteCommentSQL)
    except Exception as e:
        Loger.error(e, __file__)
        return RESPONSE_JSON(CODE_ERROR_SERVICE)
    else:
        return RESPONSE_JSON(CODE_SUCCESS)
    



if __name__ == '__main__':
    pass
