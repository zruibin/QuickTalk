#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# __init__.py
#
# Created by ruibin.chow on 2017/12/04.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""

"""

from flask import Blueprint
  
account = Blueprint("account", __name__)

from service.quickTalk.account import changeArea
from service.quickTalk.account import changeGender
from service.quickTalk.account import changeDetail
from service.quickTalk.account import register
from service.quickTalk.account import login


if __name__ == '__main__':
    pass
