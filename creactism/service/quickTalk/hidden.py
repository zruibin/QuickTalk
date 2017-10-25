#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# hidden.py
#
# Created by ruibin.chow on 2017/10/25.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""

"""

from service.quickTalk import quickTalk
from module.database import DB
from module.log.Log import Loger
from config import *
from common.code import *
from common.tools import getValueFromRequestByKey


@quickTalk.route('/hidden', methods=["GET", "POST"])
def hidden():
    os = getValueFromRequestByKey("os")
    data = {}
    if os == "iOS": 
        data = {"hidden":0}
    if os == "android": 
        data = {"hidden":0}
    return RESPONSE_JSON(CODE_SUCCESS, data)


if __name__ == '__main__':
    pass
