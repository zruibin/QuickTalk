#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# likeCircle.py
#
# Created by ruibin.chow on 2017/11/07.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""
点赞圈子
"""

from service.quickTalk import quickTalk
from module.database import DB
from module.log.Log import Loger
from config import *
from common.code import *
from common.tools import getValueFromRequestByKey, generateUUID, generateCurrentTime


@quickTalk.route('/circle/like', methods=["GET", "POST"])
def likeCircleAction():
    circleUUID = getValueFromRequestByKey("circle_uuid")

    if circleUUID == None:
        return RESPONSE_JSON(CODE_ERROR_MISS_PARAM)

    return __likeActionInStorage(circleUUID)


def __likeActionInStorage(circleUUID):
    updateSQL = """
        UPDATE t_quickTalk_circle SET `like`=`like`+1 WHERE uuid='%s';
    """ % circleUUID
            
    dbManager = DB.DBManager.shareInstanced()
    try: 
        dbManager.executeTransactionDml(updateSQL)
        return RESPONSE_JSON(CODE_SUCCESS)
    except Exception as e:
        Loger.error(e, __file__)
        return RESPONSE_JSON(CODE_ERROR_SERVICE)



if __name__ == '__main__':
    pass
