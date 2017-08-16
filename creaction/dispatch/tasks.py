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

from celery import Celery
from common.mail import sendEmailForVerifyCodeByCache
from config import *

broker = Config.CACHE_DB + "://:" + Config.CACHE_PASSWORD + "@" + Config.CACHE_HOST + ":" + str(Config.CACHE_PORT) + "/3"

celery = Celery('tasks', broker=broker)


@celery.task
def dispatchSendEmailForVerifyCode(email):
    # print('sending email to %s...' % email)
    sendEmailForVerifyCodeByCache(email)
    # print('email sent.')


if __name__ == '__main__':
    pass
