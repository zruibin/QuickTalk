#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# index.py
#
# Created by ruibin.chow on 2017/12/04.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""

"""

from service.quickTalk.userPost import userPost
from common.code import *

@userPost.route('/index', methods=["GET", "POST"])
def index():
    return RESPONSE_JSON(CODE_ERROR_MISS_PARAM)


if __name__ == '__main__':
    pass
