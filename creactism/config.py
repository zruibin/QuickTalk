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

      # 数据类型
    TYPE_FOR_EMAIL = "1" # 只用于登录，区别于联系的
    TYPE_FOR_PHONE = "2" # 只用于登录，区别于联系的
    
    TYPE_FOR_WECHAT = "3" # 用于信息显示，方便联系
    TYPE_FOR_QQ = "4" #  用于信息显示，方便联系
    TYPE_FOR_WEIBO = "5" #  用于信息显示，方便联系
    TYPE_FOR_CONTACT_PHONE = "6" #  用于信息显示，方便联系
    TYPE_FOR_CONTACT_EMAIL = "7" #  用于信息显示，方便联系

    # 第三方授权的类型 
    TYPE_FOR_AUTH_WECHAT = "8"
    TYPE_FOR_AUTH_QQ = "9"
    TYPE_FOR_AUTH_WEIBO = "10"

    # 上传文件的所属类型，分别为用户与项目
    UPLOAD_FILE_FOR_USER = "u"
    UPLOAD_FILE_FOR_PROJECT = "p"

    LIKE_ACTION_AGREE = "1"
    LIKE_ACTION_DISAGREE = "2"

    pass





