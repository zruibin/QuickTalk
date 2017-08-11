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
  
from service.account import register
from service.account import verifyEmailOrPhone
from service.account import token
from service.account import setting
from service.account import changeTag
from service.account import changeContact
from service.account import info
from service.account import contact
from service.account import checkContact
from service.account import changeInfo

