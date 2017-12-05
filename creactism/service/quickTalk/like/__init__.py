#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# __init__.py
#
# Created by ruibin.chow on 2017/12/05.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""

"""


from flask import Blueprint
  
like = Blueprint("like", __name__)

from service.quickTalk.like import likeAction


if __name__ == '__main__':
    pass
