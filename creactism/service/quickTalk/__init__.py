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

from service.quickTalk import topicList
from service.quickTalk import comment
from service.quickTalk import commentList
from service.quickTalk import submitTopic
from service.quickTalk import deleteTopic
from service.quickTalk import like
from service.quickTalk import loginWithAvatar
from service.quickTalk import hidden
from service.quickTalk import deleteComment
