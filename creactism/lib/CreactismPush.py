#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# CreactismPush.py
#
# Created by ruibin.chow on 2017/12/27.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""
远程推送类(使用个推)
Note: 个推官方提供igt_push.py有bug，已修改，详情见源文件
"""
from igt_push import *
from igetui.template import *
from igetui.template.igt_base_template import *
from igetui.template.igt_transmission_template import *
from igetui.template.igt_link_template import *
from igetui.template.igt_notification_template import *
from igetui.template.igt_notypopload_template import *
from igetui.template.igt_apn_template import *
from igetui.igt_message import *
from igetui.igt_target import *
from igetui.template import *
from BatchImpl import *
from payload.APNPayload import *
from igetui.utils.AppConditions import *

    
HOST = ''
#开发
APPKEY = "jyZbxI4IwJ8Qj3DQkPIZi2"
APPID = "kYv84fJnrV5bv5YFpU6sP"
MASTERSECRET = "oBPnACAomY9VXtuYWJOPM2"
#发布
# APPID = "l0QOBnBOQv5XM1T2nLtNa8"
# APPKEY = "N97fhuONXk9tCgUnuXyg52"
# MASTERSECRET = "j8qIilGpHZ9EZrSXxDXOP9"


def pushMessageToSingle(deviceId, msg):
    """推送单台设备"""
    # 消息模版：
    # 1.TransmissionTemplate:透传功能模板
    # 2.LinkTemplate:通知打开链接功能模板
    # 3.NotificationTemplate：通知透传功能模板
    # 4.NotyPopLoadTemplate：通知弹框下载功能模板

    # template = NotificationTemplateDemo()
    # template = LinkTemplateDemo()
    template = _transmissionTemplate(msg)
    # template = NotyPopLoadTemplateDemo()
    
    message = IGtSingleMessage()
    #是否离线推送
    message.isOffline = True
    #离线有效时间
    message.offlineExpireTime = 1000 * 3600 * 12
    message.data = template
    # 推送的网络类型：(0:不限;1:wifi;2:4G/3G/2G)
    message.pushNetWorkType = 0
    target = Target()
    target.appId = APPID
    target.clientId = deviceId

    push = IGeTui(HOST, APPKEY, MASTERSECRET, True)
    # push.connect()
    try:
        ret = push.pushMessageToSingle(message, target)
        print ret
    except RequestException, e:
        print "pushMessageToSingle error：", e
        requstId = e.getRequestId()
        ret = push.pushMessageToSingle(message, target, requstId)
        print ret
    # push.close()


def pushMessageToList(deviceIdList, msg):
    """推送多台设备"""
    template = _transmissionTemplate(msg)

    message = IGtListMessage()
    message.data = template
    message.isOffline = True
    message.offlineExpireTime = 1000 * 3600 * 12
    message.pushNetWorkType = 0

    array = []
    for deviceId in deviceIdList:
        target = Target()
        target.appId = APPID
        target.clientId = deviceId
        # target.alias = Alias
        array.append(target)

    try:
        push = IGeTui(HOST, APPKEY, MASTERSECRET, True)
        # push.connect()
        contentId = push.getContentId(message, '')
        ret = push.pushMessageToList(contentId, array)
        print ret
        # push.close()
    except RequestException, e:
        print "pushMessageToList error：", e


def pushMessageToApp(msg):
    """推送整个平台"""
    template = _transmissionTemplate(msg)

    message = IGtAppMessage()
    message.data = template
    message.isOffline = True
    message.offlineExpireTime = 1000 * 3600 * 12
    message.appIdList.extend([APPID])

    # conditions = AppConditions()
    # phoneType = ['ANDROID']
    # tags = ['dddd', 'ceshi2']
    # conditions.addCondition('phoneType', phoneType, OptType.OR)
    # conditions.addCondition(AppConditions.TAG, tags, OptType.AND)
    # message.setConditions(conditions)
    # message.phoneTypeList.extend(["ANDROID", "IOS"])
    # message.provinceList.extend(["浙江", "上海"])
    # message.tagList.extend(["开心"])
    # message.pushNetWorkType = 1
    # 控速推送(条/秒)
    # message.setSpeed(10)
    try:
        push = IGeTui(HOST, APPKEY, MASTERSECRET, True)
        # push.connect()
        ret = push.pushMessageToApp(message, '')
        # print message.getSpeed()
        print ret
        # push.close()
    except RequestException, e:
        print "pushMessageToApp error：", e
        



# 透传模板动作内容
def _transmissionTemplate(msg):
    template = TransmissionTemplate()
    template.transmissionType = 1
    template.appId = APPID
    template.appKey = APPKEY
    # template.transmissionContent = '请填入透传内容'
    # iOS 推送需要的PushInfo字段 前三项必填，后四项可以填空字符串
    # template.setPushInfo(actionLocKey, badge, message, sound, payload, locKey, locArgs, launchImage)
#     template.setPushInfo("", 0, "", "com.gexin.ios.silence", "", "", "", "")

# APN简单推送
    alertMsg = SimpleAlertMsg()
    alertMsg.alertMsg = msg
    apn = APNPayload()
    apn.alertMsg = alertMsg
    apn.badge = 1
    apn.sound = "default"
    apn.addCustomMsg("payload", "payload")
#     apn.contentAvailable=1
#     apn.category="ACTIONABLE"
    template.setApnInfo(apn)

    # APN高级推送
    # apnpayload = APNPayload()
    # apnpayload.badge = 4
    # apnpayload.sound = "default"
    # apnpayload.addCustomMsg("payload", "payload")
    # apnpayload.contentAvailable = 1
    # apnpayload.category = "ACTIONABLE"
    # alertMsg = DictionaryAlertMsg()
    # alertMsg.body = msg
    # alertMsg.actionLocKey = 'actionLockey'
    # alertMsg.locKey = 'lockey'
    # alertMsg.locArgs=['locArgs']
    # alertMsg.launchImage = 'launchImage'
    # IOS8.2以上版本支持
    # alertMsg.title = 'Title'
    # alertMsg.titleLocArgs = ['TitleLocArg']
    # alertMsg.titleLocKey = 'TitleLocKey'
    # apnpayload.alertMsg=alertMsg
    # template.setApnInfo(apnpayload)
    
    return template




if __name__ == '__main__':
    pass




