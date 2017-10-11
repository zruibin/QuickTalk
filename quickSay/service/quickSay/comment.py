#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# comment.py
#
# Created by ruibin.chow on 2017/10/11.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""

"""


from service.quickSay import quickSay
from module.database import DB
from module.log.Log import Loger
from config import *
from common.code import *


@quickSay.route('/comment', methods=["GET", "POST"])
def comment():
    return RESPONSE_JSON(CODE_SUCCESS)
    


if __name__ == '__main__':
    pass
