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
  
quickChat = Blueprint("quickChat", __name__)

from service.quickChat import topicList
from service.quickChat import comment
from service.quickChat import commentList
from service.quickChat import submitTopic
from service.quickChat import deleteTopic
from service.quickChat import like
from service.quickChat import loginWithAvatar
