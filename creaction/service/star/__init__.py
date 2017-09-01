#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# __init__.py
#
# Created by ruibin.chow on 2017/08/15.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""

"""
from flask import Blueprint
  
star = Blueprint("star", __name__)
  
from service.star import peopleList
from service.star import startAction
from service.star import projectList
