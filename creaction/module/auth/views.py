#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# views.py
#
# Created by zruibin on 2017/07/24.
# Copyright (c) 2017年 zruibin All rights reserved.
# 

from module.auth import auth

@auth.route('/')       #指定路由为/，因为run.py中指定了前缀，浏览器访问时，路径为http://IP/auth/
def index():                         
        #  print'__name__',__name__
         return '<h1>Hello zruibin, From authenticate!</h1>'
