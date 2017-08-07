#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# config.py
#
# Created by zruibin on 2017/07/24.
# Copyright (c) 2017年 zruibin All rights reserved.
# 

"""

"""

from functools import wraps
from flask import  request, Response,make_response
from common.jsonUtil import jsonTool

def otherHandle(func):
    @wraps(func)
    def wrapper(*args, **kwargs):
        print request.args
        print request.args.get('test')
        print request.form
        result = {'user': "Ruibin.Chow"}
        temp = True

        if temp:
            response = make_response(func(*args, **kwargs))
            # response.headers['Access-Control-Allow-Origin'] = '*'
            response.headers["Access-Control-Allow-Methods"] = 'GET,POST'
            response.headers["Access-Control-Allow-Headers"] = "Referer,Accept,Origin,User-Agent"
            response.headers["WWW-Authenticate"] = "Authentication Required"
            return response
        else:
            return jsonTool(result)
    return wrapper

class Config(object):

    DEBUG = True

    DBHOST = "localhost"
    DBPORT = 3306
    DBUSER = "root"
    DBPWD = "0928"
    DBNAME = "creaction"
    DBCHAR = "utf8"
    DBPOOLSIZE = 10

    CACHE_HOST = DBHOST
    CACHE_PORT = 6379
    CACHE_EXPIRE = 3600 #一个小时

    TOKEN_EXPIRE = 3600
    pass





