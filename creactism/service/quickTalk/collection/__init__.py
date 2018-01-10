#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# __init__.py
#
# Created by ruibin.chow on 2017/12/15.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""

"""
from flask import Blueprint
  
collection = Blueprint("collection", __name__)

from . import action
from . import collectionList


if __name__ == '__main__':
    pass
