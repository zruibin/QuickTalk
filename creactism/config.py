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


class Config(object):

    DEBUG = True

    WEB_SITE_HOST = "http://creactism.com/"
    LOG_DIR = "logs/"
    WEB_SITE_DIR = "/home/creactism"
    BACKUP_DIR = "/home/creactism" # 数据备份目录

    DBHOST = "localhost"
    DBPORT = 3306
    DBUSER = "root"
    DBPWD = "0928"
    DBNAME = "creactism"
    DBCHAR = "utf8"
    DBPOOLSIZE = 10

    CACHE_DB = "redis"
    CACHE_HOST = DBHOST
    CACHE_PORT = 6379
    CACHE_PASSWORD = DBPWD
    CACHE_EXPIRE = 3600 #一个小时

    TOKEN_EXPIRE = 3600

    MAX_CONTENT_LENGTH = 16 * 1024 * 1024 # 上传文件限制，程序限制大小为其一半
    MAX_CONTENT_LENGTH_VERIFY = MAX_CONTENT_LENGTH / 2 # 上传文件的真实要求大小
    UPLOAD_FOLDER = "medias/" # 多媒体存放的目录，必须加上/
    FULL_UPLOAD_FOLDER = os.getcwd() + "/" + UPLOAD_FOLDER
    FULL_UPLOAD_FOLDER_TEMP = FULL_UPLOAD_FOLDER + "tmp/"
    ALLOWED_EXTENSIONS = set(["png", "jpg", "jpeg", "gif"])
    JSONIFY_MIMETYPE = "application/json"

    MAIL_HOST = "smtp.exmail.qq.com"  #设置服务器
    MAIL_USER = "auto.mail"    #用户名
    MAIL_PASSWORD = "CreAction1"   #口令 
    MAIL_POSTFIX = "creactism.com"  #发件箱的后缀

    PAGE_OF_SIZE = 10 # 分页每页数量

    pass





