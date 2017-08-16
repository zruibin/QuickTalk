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
  
start = Blueprint("start", __name__)
  
from service.start import peopleList
from service.start import startAction
from service.start import projectList
