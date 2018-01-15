#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# deleteTopic.py
#
# Created by ruibin.chow on 2017/10/11.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""
删除话题
"""

from . import news
from module.database import DB
from module.log.Log import Loger
from config import *
from common.code import *
from common.tools import getValueFromRequestByKey


@news.route('/deleteTopic', methods=["GET", "POST"])
def deleteTopic():
    uuid = getValueFromRequestByKey("uuid")
    return __deleteAction(uuid)
    

def __deleteAction(uuid):
    deleteTopicSQL = """DELETE FROM t_quickTalk_topic WHERE uuid='%s';""" % (uuid)

    deleteCommentSQL = """DELETE FROM t_quickTalk_topic_comment WHERE topic_uuid='%s';""" % (uuid)

    dbManager = DB.DBManager.shareInstanced()
    try: 
            dbManager.executeTransactionMutltiDml([deleteTopicSQL, deleteCommentSQL])
    except Exception as e:
        Loger.error(e, __file__)
        return RESPONSE_JSON(CODE_ERROR_SERVICE)
    else:
        return RESPONSE_JSON(CODE_SUCCESS)
    


if __name__ == '__main__':
    pass
