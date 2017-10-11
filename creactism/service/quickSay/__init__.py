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
  
quickSay = Blueprint("quickSay", __name__)

from service.quickSay import topicList
from service.quickSay import comment
from service.quickSay import commentList
from service.quickSay import submitTopic
from service.quickSay import deleteTopic
