#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# __init__.py
#
# Created by ruibin.chow on 2018/01/15.
# Copyright (c) 2018年 ruibin.chow All rights reserved.
# 

"""

"""
from flask import Blueprint
  
news = Blueprint("news", __name__)

from . import topic
from . import topicList
from . import topicContent
from . import changeTopic
from . import comment
from . import commentList
from . import submitTopic
from . import deleteTopic
from . import likeAction
from . import deleteComment
from . import myCommentList
from . import updateReadCount


if __name__ == '__main__':
    pass
