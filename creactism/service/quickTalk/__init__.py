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

from . import topic
from . import topicList
from . import topicContent
from . import changeTopic
from . import comment
from . import commentList
from . import submitTopic
from . import deleteTopic
from . import login
from . import likeAction
from . import hidden
from . import deleteComment
from . import changeAvatar
from . import changeInfo
from . import myCommentList
from . import updateReadCount
from . import version

