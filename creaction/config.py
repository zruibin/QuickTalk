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
import os
from functools import wraps
from flask import  request, Response,make_response
from common.jsonUtil import jsonTool

def otherHandle(func):
    @wraps(func)
    def wrapper(*args, **kwargs):
        print request.args
        print request.args.get("test")
        print request.form
        result = {"user": "Ruibin.Chow"}
        temp = True

        if temp:
            response = make_response(func(*args, **kwargs))
            # response.headers["Access-Control-Allow-Origin"] = "*"
            response.headers["Access-Control-Allow-Methods"] = "GET,POST"
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

    MAX_CONTENT_LENGTH = 16 * 1024 * 1024 # 上传文件限制，程序限制大小为其一半
    MAX_CONTENT_LENGTH_VERIFY = MAX_CONTENT_LENGTH / 2 # 上传文件的真实要求大小
    UPLOAD_FOLDER = "medias/"
    FULL_UPLOAD_FOLDER = os.getcwd() + "/" + UPLOAD_FOLDER
    ALLOWED_EXTENSIONS = set(["txt", "pdf", "png", "jpg", "jpeg", "gif"])

    MAIL_HOST = "smtp.126.com"  #设置服务器
    MAIL_USER = "creaction"    #用户名
    MAIL_PASSWORD = "creaction362436"   #口令 
    MAIL_POSTFIX = "126.com"  #发件箱的后缀
    pass





