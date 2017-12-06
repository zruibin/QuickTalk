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

from service.quickTalk import topic
from service.quickTalk import topicList
from service.quickTalk import topicContent
from service.quickTalk import changeTopic
from service.quickTalk import comment
from service.quickTalk import commentList
from service.quickTalk import submitTopic
from service.quickTalk import deleteTopic
from service.quickTalk import login
from service.quickTalk import likeAction
from service.quickTalk import hidden
from service.quickTalk import deleteComment
from service.quickTalk import changeAvatar
from service.quickTalk import changeInfo
from service.quickTalk import myCommentList
from service.quickTalk import updateReadCount
from service.quickTalk import version

# circle
from service.quickTalk.circle import circleList
from service.quickTalk.circle import submitCircle
from service.quickTalk.circle import deleteCircle
from service.quickTalk.circle import likeCircle
