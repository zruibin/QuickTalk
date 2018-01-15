#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# __init__.py
#
# Created by ruibin.chow on 2017/08/23.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""

"""
from flask import Blueprint
  
quickTalk = Blueprint("quickTalk", __name__)


from . import version
from . import hidden
