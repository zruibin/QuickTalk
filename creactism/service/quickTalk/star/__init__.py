#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# __init__.py
#
# Created by ruibin.chow on 2017/12/18.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""

"""

from flask import Blueprint
  
star = Blueprint("star", __name__)

from service.quickTalk.star import userAction
from service.quickTalk.star import queryStarUser
from service.quickTalk.star import queryStarUserRelation
from service.quickTalk.star import queryFans


if __name__ == '__main__':
    pass
