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

import sys, json
from dispatch import celery
from config import *
from module.database import DB
from module.log.Log import Loger
from lib.CreactismPush import pushMessageToList


@celery.task
def dispatchNotificationLikeForUserPost(userUUID, reciveUserUUID):
    """赞，xx赞了你的分享"""
    if Config.DEBUG:
        print "%s赞了你的分享(%s)" % (userUUID, reciveUserUUID)
    dataList = __querySingleData(userUUID, reciveUserUUID, Config.NOTIFICATION_FOR_LIKE)
    if len(dataList) > 0:
        msg = __packageMsg(dataList[0], Config.NOTIFICATION_FOR_LIKE)
        __pushNotification(dataList, msg)
    pass


@celery.task
def dispatchNotificationUserStar(userUUID, reciveUserUUID):
    """关注，xx关注了你"""
    if Config.DEBUG:
        print "%s关注了你(%s)" % (userUUID, reciveUserUUID)
    dataList = __querySingleData(userUUID, reciveUserUUID, Config.NOTIFICATION_FOR_NEW_STAR)
    if len(dataList) > 0:
        msg = __packageMsg(dataList[0], Config.NOTIFICATION_FOR_NEW_STAR)
        __pushNotification(dataList, msg)
    pass


@celery.task
def dispatchNotificationCommentForUserPost(userUUID, reciveUserUUID):
    """评论，xx评论了你"""
    if Config.DEBUG:
        print "%s评论了你(%s)" % (userUUID, reciveUserUUID)
    dataList = __querySingleData(userUUID, reciveUserUUID, Config.NOTIFICATION_FOR_COMMENT)
    if len(dataList) > 0:
        msg = __packageMsg(dataList[0], Config.NOTIFICATION_FOR_COMMENT)
        __pushNotification(dataList, msg)
    pass


@celery.task
def dispatchNotificationNewShare(userUUID):
    """关注的人新的分享，xx发表了新分享"""
    if Config.DEBUG:
        print "%s发表了新分享" % (userUUID)
    dataList = __queryNewShareDataList(userUUID)
    if len(dataList) > 0:
        msg = __packageMsg(dataList[0], Config.NOTIFICATION_FOR_NEW_SHARE)
        __pushNotification(dataList, msg)
    pass



def __querySingleData(userUUID, reciveUserUUID, typeStr):
    querySQL = """
        SELECT t_quickTalk_user.uuid, t_quickTalk_user.id, t_quickTalk_user.nickname,
            t_quickTalk_user_setting.status,
            t_quickTalk_notification_device.deviceId, t_quickTalk_notification_device.type
        FROM t_quickTalk_user, t_quickTalk_user_setting, t_quickTalk_notification_device
        WHERE t_quickTalk_user.uuid='%s'
        AND t_quickTalk_user_setting.user_uuid='%s'
        AND t_quickTalk_user_setting.type=%s
        AND t_quickTalk_notification_device.user_uuid='%s'
    """ % (userUUID, reciveUserUUID, str(typeStr), reciveUserUUID)
    # print querySQL
    dataList = None
    dbManager = DB.DBManager.shareInstanced()
    try: 
        dataList = dbManager.executeSingleQuery(querySQL)
    except Exception as e:
        print e
    return dataList


def __queryNewShareDataList(userUUID):
    querySQL = """
        SELECT t_quickTalk_user_user.user_uuid, 
            t_quickTalk_user.uuid, t_quickTalk_user.id, t_quickTalk_user.nickname,
            t_quickTalk_user_setting.status,
            t_quickTalk_notification_device.deviceId, t_quickTalk_notification_device.type
        FROM t_quickTalk_user_user , t_quickTalk_user, 
            t_quickTalk_user_setting, t_quickTalk_notification_device
        WHERE other_user_uuid='%s'
        AND t_quickTalk_user.uuid=t_quickTalk_user_user.other_user_uuid
        AND t_quickTalk_user_setting.user_uuid=t_quickTalk_user_user.user_uuid
        AND t_quickTalk_user_setting.type=%s
        AND t_quickTalk_notification_device.user_uuid=t_quickTalk_user_user.user_uuid
    """ % (userUUID, Config.NOTIFICATION_FOR_NEW_SHARE)
    # print querySQL
    dataList = []
    dbManager = DB.DBManager.shareInstanced()
    try: 
        dataList = dbManager.executeSingleQuery(querySQL)
    except Exception as e:
        print e
    return dataList


def __pushNotification(dataList, msg):
    deviceIdList = []
    for data in dataList:
        if data["status"] == Config.STATUS_ON: 
            deviceIdList.append(data["deviceId"])
    if len(deviceIdList) > 0:
        pushMessageToList(deviceIdList, msg)
    pass
    


def __packageMsg(dataDict, typeStr):
    userId = dataDict["id"]
    nickname = dataDict["nickname"]

    subMsg = ""
    if typeStr == Config.NOTIFICATION_FOR_LIKE:
        subMsg = "赞了你的分享"
    if typeStr == Config.NOTIFICATION_FOR_NEW_STAR:
        subMsg = "关注了你"
    if typeStr == Config.NOTIFICATION_FOR_COMMENT:
        subMsg = "评论了你的分享"
    if typeStr == Config.NOTIFICATION_FOR_NEW_SHARE:
        subMsg = "发表了新分享"

    msg = "notification..."
    if nickname == None:
        msg = "%s%s" % (("用户"+str(userId)), subMsg)
    else:
        msg = "%s%s" % (nickname, subMsg)

    return msg


def __covertMsg(msg, typeStr):
    msgDict = {}
    if str(typeStr) == "3":
        msgDict = {"title": "", "description": msg}
    else:
        msgDict = {"aps": {"alert": msg, "sound":"default"}}
    msg = json.dumps(msgDict)
    return msg




if __name__ == '__main__':
    pass



