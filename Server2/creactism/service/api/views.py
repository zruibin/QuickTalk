#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# views.py
#
# Created by zruibin on 2017/07/24.
# Copyright (c) 2017年 zruibin All rights reserved.
# 

from flask import Flask, Response, request
from . import api
from module.database import DB
from module.cache.RuntimeCache import CacheManager
from module.log.Log import Loger
from dispatch.BackupTask import backup
from dispatch.userPreferenceWork import generateAllUserPreference


@api.route('/')
def index():                         
        #  print'__name__',__name__
        try:
            print request.headers
            print request.user_agent
            print Response()
            DB.test()
            Loger.error("test Log!", __file__)
            CacheManager.shareInstanced().setCache("name", "Ruibin.Chow")
            print CacheManager.shareInstanced().getCache("name")
        except Exception, e:
            Loger.info("info test Log!", __file__)
            Loger.error(e, __file__)

        # Log.test()
        return '<h1>Hello zruibin, From Service API!</h1>'


@api.route('/test_backup_data')
def test_backup_data():                         
        
    backup.delay()
    # Log.test()
    return '<h1>test_backup_data success</h1>'


@api.route('/test_userPreference_task')
def test_userPreference_task():                         
    # 用户偏好
    generateAllUserPreference.delay() 
    # Log.test()
    return '<h1>test_userPreference_task success</h1>'