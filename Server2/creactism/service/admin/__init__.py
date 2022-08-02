#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# __init__.py
#
# Created by zruibin on 2017/07/24.
# Copyright (c) 2017年 zruibin All rights reserved.
# 

"""

"""

from flask import Blueprint
  
admin = Blueprint('admin', __name__)
  
from . import views
from . import logContent

