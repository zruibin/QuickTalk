#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# __init__.py
#
# Created by ruibin.chow on 2017/08/08.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""

"""

from flask import Blueprint
  
account = Blueprint("account", __name__)
  
from service.account import register, verifyEmailOrPhone



