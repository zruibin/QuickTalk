#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# views.py
#
# Created by zruibin on 2017/07/24.
# Copyright (c) 2017年 zruibin All rights reserved.
# 

from . import admin

@admin.route('/')
def index():                         
        #  print'__name__',__name__
         return '<h1>Hello zruibin, From Service Admin!</h1>'
