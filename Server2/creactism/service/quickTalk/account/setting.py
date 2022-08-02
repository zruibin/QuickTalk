#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# setting.py
#
# Created by ruibin.chow on 2017/12/21.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""
个人设置(初步为4种消息通知)

PS:是否要走APNS(手机通知栏的显示)的通知，默认(除了好友的发表的分享)全部都开
# 赞(第一次赞就有通知)
NOTIFICATION_FOR_LIKE = 1 
# 评论
NOTIFICATION_FOR_COMMENT = 2
# 加关注的
NOTIFICATION_FOR_NEW_STAR = 3
# 关注的好友的发表的分享
NOTIFICATION_FOR_NEW_SHARE = 4
"""

from . import account
from module.database import DB
from module.log.Log import Loger
from config import *
from common.code import *
from common.auth import vertifyTokenHandle
from common.tools import getValueFromRequestByKey


@account.route('/setting', methods=["POST"])
@vertifyTokenHandle
def setting():
    userUUID = getValueFromRequestByKey("user_uuid")
    typeStr = getValueFromRequestByKey("type")
    status = getValueFromRequestByKey("status")

    # 参数没有直接报错返回
    if userUUID == None or typeStr == None or status == None:
        return RESPONSE_JSON(CODE_ERROR_MISS_PARAM)

    if __changeSettingStatus(userUUID, typeStr, status):
        return RESPONSE_JSON(CODE_SUCCESS)
    else:
        return RESPONSE_JSON(CODE_ERROR_SERVICE)
    

def __changeSettingStatus(userUUID, typeStr, status):
    result  = False
    querySQL = """
        UPDATE t_quickTalk_user_setting SET status=%s WHERE user_uuid=%s AND type=%s; """
    dbManager = DB.DBManager.shareInstanced()
    try: 
            result = dbManager.executeSingleDmlWithArgs(querySQL, [status, userUUID, typeStr])
    except Exception as e:
            Loger.error(e, __file__)
    return result


if __name__ == '__main__':
    pass
