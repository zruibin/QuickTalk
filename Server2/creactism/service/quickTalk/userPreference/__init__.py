#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# __init__.py
#
# Created by ruibin.chow on 2018/02/06.
# Copyright (c) 2018年 ruibin.chow All rights reserved.
# 

"""

"""

from flask import Blueprint
  
userPreference = Blueprint("userPreference", __name__)

from . import generateAll


if __name__ == '__main__':
    pass
