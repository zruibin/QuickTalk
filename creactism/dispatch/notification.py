#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# notification.py
#
# Created by ruibin.chow on 2017/12/26.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""
远程推送通知
"""

from dispatch import celery
from config import *
from module.database import DB
from module.log.Log import Loger


@celery.task
def dispatchNotificationLikeForUserPost(userUUID, reciveUserUUID):
    """赞，xx赞了你的分享"""
    print "%s赞了你的分享(%s)" % (userUUID, reciveUserUUID)
    dataDict = __querySingleData(userUUID, reciveUserUUID, Config.NOTIFICATION_FOR_LIKE)
    pass


@celery.task
def dispatchNotificationUserStar(userUUID, reciveUserUUID):
    """关注，xx关注了你"""
    print "%s关注了你(%s)" % (userUUID, reciveUserUUID)
    dataDict = __querySingleData(userUUID, reciveUserUUID, Config.NOTIFICATION_FOR_NEW_STAR)
    pass


@celery.task
def dispatchNotificationCommentForUserPost(userUUID, reciveUserUUID):
    """评论，xx评论了你"""
    print "%s评论了你(%s)" % (userUUID, reciveUserUUID)
    dataDict = __querySingleData(userUUID, reciveUserUUID, Config.NOTIFICATION_FOR_COMMENT)
    pass


@celery.task
def dispatchNotificationNewShare(userUUID):
    """关注的人新的分享，xx发表了新分享"""
    print "%s发表了新分享" % (userUUID)
    dataList = __queryNewShareDataList(userUUID)

    pass


def __querySingleData(userUUID, reciveUserUUID, typeStr):
    querySQL = """
        SELECT t_quickTalk_user.uuid, t_quickTalk_user.id, t_quickTalk_user.nickname,
            t_quickTalk_user_setting.status,
            t_quickTalk_notification_device.deviceId
        FROM t_quickTalk_user, t_quickTalk_user_setting, t_quickTalk_notification_device
        WHERE t_quickTalk_user.uuid='%s'
        AND t_quickTalk_user_setting.user_uuid='%s'
        AND t_quickTalk_user_setting.type=%s
        AND t_quickTalk_notification_device.user_uuid='%s'
    """ % (userUUID, reciveUserUUID, str(typeStr), reciveUserUUID)
    dataDict = {}
    dbManager = DB.DBManager.shareInstanced()
    try: 
        dataList = dbManager.executeSingleQuery(querySQL)
        if len(dataList) > 0:
            dataDict = dataList[0]
    except Exception as e:
        Loger.error(e, __file__)
    return dataDict


def __queryNewShareDataList(userUUID):
    querySQL = """
        SELECT t_quickTalk_user_user.user_uuid, 
            t_quickTalk_user.uuid, t_quickTalk_user.id, t_quickTalk_user.nickname,
            t_quickTalk_user_setting.status,
            t_quickTalk_notification_device.deviceId
        FROM t_quickTalk_user_user , t_quickTalk_user, 
            t_quickTalk_user_setting, t_quickTalk_notification_device
        WHERE other_user_uuid='%s'
        AND t_quickTalk_user.uuid=t_quickTalk_user_user.other_user_uuid
        AND t_quickTalk_user_setting.user_uuid=t_quickTalk_user_user.user_uuid
        AND t_quickTalk_user_setting.type=%s
        AND t_quickTalk_notification_device.user_uuid=t_quickTalk_user_user.user_uuid
    """ % (userUUID, Config.NOTIFICATION_FOR_NEW_SHARE)
    dataList = []
    dbManager = DB.DBManager.shareInstanced()
    try: 
        dataList = dbManager.executeSingleQuery(querySQL)
    except Exception as e:
        Loger.error(e, __file__)
    return dataList







if __name__ == '__main__':
    pass



