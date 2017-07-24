#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# __init__.py
#
# Created by zruibin on 2017/07/24.
# Copyright (c) 2017年 zruibin All rights reserved.
# 

from flask import Blueprint
  
auth = Blueprint('auth', __name__,
        #template_folder='/opt/auras/templates/',   #指定模板路径
         #static_folder='/opt/auras/flask_bootstrap/static/',#指定静态文件路径
        )
  
from module.auth import views





