#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# views.py
#
# Created by zruibin on 2017/07/24.
# Copyright (c) 2017年 zruibin All rights reserved.
# 

from flask import Flask, Response, request
from service.api import api
from module.database import DB
from module.cache.RuntimeCache import CacheManager
from module.log.Log import Loger


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
            Loger.error(e, __file__)

        # Log.test()
        return '<h1>Hello zruibin, From Service API!</h1>'
