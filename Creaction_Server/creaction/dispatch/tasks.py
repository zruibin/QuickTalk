#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# tasks.py
#
# Created by ruibin.chow on 2017/08/11.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""

"""

from dispatch import celery
from config import *
from common.mail import sendEmailForVerifyCodeByCache
import common.notification as notification


@celery.task
def dispatchSendEmailForVerifyCode(email):
    # print('sending email to %s...' % email)
    sendEmailForVerifyCodeByCache(email)
    # print('email sent.')


@celery.task
def dispatchNotificationUserForContent(userUUID, content):
    notification.notificationUserForContent(userUUID, content)




if __name__ == '__main__':
    pass
