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
from lib.BPush.Channel import *

reload(sys)  
sys.setdefaultencoding('utf8')

DEPLOY_STATUS = 1

@celery.task
def dispatchNotificationLikeForUserPost(userUUID, reciveUserUUID):
    """赞，xx赞了你的分享"""
    print "%s赞了你的分享(%s)" % (userUUID, reciveUserUUID)
    dataDict = __querySingleData(userUUID, reciveUserUUID, Config.NOTIFICATION_FOR_LIKE)
    if dataDict != None:
        if dataDict["status"] == Config.STATUS_ON: 
            msg = __packageMsg(dataDict, Config.NOTIFICATION_FOR_LIKE)
            __pushMsgToSingleDevice(dataDict, msg)
    pass


@celery.task
def dispatchNotificationUserStar(userUUID, reciveUserUUID):
    """关注，xx关注了你"""
    print "%s关注了你(%s)" % (userUUID, reciveUserUUID)
    dataDict = __querySingleData(userUUID, reciveUserUUID, Config.NOTIFICATION_FOR_NEW_STAR)
    if dataDict != None:
        if dataDict["status"] == Config.STATUS_ON:
            msg = __packageMsg(dataDict, Config.NOTIFICATION_FOR_NEW_STAR)
            __pushMsgToSingleDevice(dataDict, msg)
    pass


@celery.task
def dispatchNotificationCommentForUserPost(userUUID, reciveUserUUID):
    """评论，xx评论了你"""
    print "%s评论了你(%s)" % (userUUID, reciveUserUUID)
    dataDict = __querySingleData(userUUID, reciveUserUUID, Config.NOTIFICATION_FOR_COMMENT)
    if dataDict != None:
        if dataDict["status"] == Config.STATUS_ON: 
            msg = __packageMsg(dataDict, Config.NOTIFICATION_FOR_COMMENT)
            __pushMsgToSingleDevice(dataDict, msg)
    pass


@celery.task
def dispatchNotificationNewShare(userUUID):
    """关注的人新的分享，xx发表了新分享"""
    print "%s发表了新分享" % (userUUID)
    dataList = __queryNewShareDataList(userUUID)
    if len(dataList) > 0:
        __pushBatchUniMsg(dataList)
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
    dataDict = None
    dbManager = DB.DBManager.shareInstanced()
    try: 
        dataList = dbManager.executeSingleQuery(querySQL)
        if len(dataList) > 0:
            dataDict = dataList[0]
    except Exception as e:
        print e
    return dataDict


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
    dataList = []
    dbManager = DB.DBManager.shareInstanced()
    try: 
        dataList = dbManager.executeSingleQuery(querySQL)
    except Exception as e:
        print e
    return dataList


def __pushMsgToSingleDevice(dataDict, msg):
    """
        根据channel_id，向单个设备推送消息
        参考：http://push.baidu.com/doc/python/api

        msg: 创建消息内容
    """
    # 消息控制选项。
    opts = {'msg_type':1, 'expires':300}
    if str(dataDict["type"]) == "4":
        opts = {'msg_type':1, 'expires':300, 'deploy_status':DEPLOY_STATUS}
    print opts
    # 服务端唯一分配的channel id
    channelId = dataDict["deviceId"]

    msg = __covertMsg(msg, dataDict["type"])

    c = Channel(str(dataDict["type"]))
    # 发送
    try:
        # print channelId, msg
        ret = c.pushMsgToSingleDevice(str(channelId), msg, opts)
        print ret # 将打印出 msg_id 及 send_time 的 timestamp
    except ChannelException as e:
        print e.getLastErrorCode()
        print e.getLastErrorMsg()


def __pushBatchUniMsg(dataList):
    """ 
        批量单播，向一组指定的设备(channel_id)，发送一条消息
        参考：http://push.baidu.com/doc/python/api
    """
    # 创建消息内容
    msg = "发表了新分享"

    userId = dataList[0]["id"]
    nickname = dataList[0]["nickname"]
    if nickname == None:
        msg = "%s发表了新分享" % ("用户"+str(userId))
    else:
        msg = "%s发表了新分享" % nickname

    # channel_id列表
    androidChannelIds = []
    iOSChannelIds = []
    for data in dataList:
        if data["status"] == Config.STATUS_ON: 
            if str(data["type"]) == "3":
                androidChannelIds.append(str(data["deviceId"]))
            else:
                iOSChannelIds.append(str(data["deviceId"]))

    msg = __covertMsg(msg, data["type"])

    # 消息控制选项
    androidOpts = {'msg_type':1, 'expires':300}
    iOSOpts = androidOpts #{'msg_type':1, 'expires':300, 'deploy_status':DEPLOY_STATUS}
    androidChannel = Channel("3")
    iOSChannel = Channel("4")
    # 发送
    try:
        if len(androidChannelIds) > 0:
            androidRet = androidChannel.pushBatchUniMsg(androidChannelIds, msg, androidOpts)
            print androidRet # 将打印出 msg_id 及 send_time 的 timestamp
        if len(iOSChannelIds) > 0:
            iOSRet = iOSChannel.pushBatchUniMsg(iOSChannelIds, msg, iOSOpts)
            print iOSRet # 将打印出 msg_id 及 send_time 的 timestamp
            print iOSChannel.queryMsgStatus(iOSRet["msg_id"])
    except ChannelException as e:
        print e.getLastErrorCode()
        print e.getLastErrorMsg()


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



