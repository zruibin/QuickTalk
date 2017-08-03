#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# views.py
#
# Created by zruibin on 2017/07/24.
# Copyright (c) 2017年 zruibin All rights reserved.
# 

from service.api import api
from module.database import DBPool
from module.log.Log import Loger


@api.route('/')
def index():                         
        #  print'__name__',__name__
        try:
            DBPool.test()
            Loger.error("test Log!", __file__)
        except Exception, e:
            Loger.error(e, __file__)

        # Log.test()
        return '<h1>Hello zruibin, From Service API!</h1>'
