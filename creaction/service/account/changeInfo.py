#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# changeInfo.py
#
# Created by ruibin.chow on 2017/08/11.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""

"""
from service.account import account
from flask import Flask, Response, request
import json
from module.database import DB
from module.log.Log import Loger
from config import *
from common.code import *
from common.auth import vertifyTokenHandle
from common.tools import getValueFromRequestByKey


@account.route('/change_info', methods=["POST"])
# @vertifyTokenHandle
def changeInfo():
    pass




if __name__ == '__main__':
    pass
