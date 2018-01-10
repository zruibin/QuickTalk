#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# likeAction.py
#
# Created by ruibin.chow on 2017/10/12.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""
评论点赞
"""

from . import quickTalk
from module.database import DB
from module.log.Log import Loger
from config import *
from common.code import *
from common.tools import getValueFromRequestByKey, generateUUID, generateCurrentTime


@quickTalk.route('/like', methods=["GET", "POST"])
def likeAction():
    commentUUID = getValueFromRequestByKey("comment_uuid")
    action = getValueFromRequestByKey("action")

    if commentUUID == None or action == None:
        return RESPONSE_JSON(CODE_ERROR_MISS_PARAM)

    return __likeActionInStorage(commentUUID, action)
    

def __likeActionInStorage(commentUUID, action):
    updateSQL = """
        UPDATE t_quickTalk_topic_comment SET `like`=`like`+1 WHERE uuid='%s';
    """ % commentUUID
    if action == Config.LIKE_ACTION_DISAGREE:
        updateSQL = """
            UPDATE t_quickTalk_topic_comment SET `dislike`=`dislike`+1 WHERE uuid='%s';
        """ % commentUUID
            
    dbManager = DB.DBManager.shareInstanced()
    try: 
        dbManager.executeTransactionDml(updateSQL)
        return RESPONSE_JSON(CODE_SUCCESS)
    except Exception as e:
        Loger.error(e, __file__)
        return RESPONSE_JSON(CODE_ERROR_SERVICE)


if __name__ == '__main__':
    pass
