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

from . import userAction
from . import queryStarUser
from . import queryStarUserRelation
from . import queryFans
from . import queryBeStarRelation


if __name__ == '__main__':
    pass
