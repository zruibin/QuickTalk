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
  
userPost = Blueprint("userPost", __name__)

from service.quickTalk.userPost import index
from service.quickTalk.userPost import addUserPost
from service.quickTalk.userPost import addUserPostComment
from service.quickTalk.userPost import deleteUserPostComment
from service.quickTalk.userPost import deleteUserPost
from service.quickTalk.userPost import addReadCount
from service.quickTalk.userPost import userPostList
from service.quickTalk.userPost import userPostCommentList


if __name__ == '__main__':
    pass
