#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# version.py
#
# Created by ruibin.chow on 2017/11/20.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""
版本更新
"""

from . import quickTalk
from module.database import DB
from module.log.Log import Loger
from config import *
from common.code import *
from common.tools import getValueFromRequestByKey


@quickTalk.route('/version', methods=["GET", "POST"])
def version():
    os = getValueFromRequestByKey("os")
    data = {}
    if os == "iOS": 
        data = {"version": "1.0"}
    if os == "android": 
        data = {"version": "1.0"}
    return RESPONSE_JSON(CODE_SUCCESS, data)




if __name__ == '__main__':
    pass
