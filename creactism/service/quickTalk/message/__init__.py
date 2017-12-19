#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# __init__.py
#
# Created by ruibin.chow on 2017/12/19.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""

"""


from flask import Blueprint
  
message = Blueprint("message", __name__)

from service.quickTalk.message import messageData



if __name__ == '__main__':
    pass
