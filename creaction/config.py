#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# config.py
#
# Created by zruibin on 2017/07/24.
# Copyright (c) 2017年 zruibin All rights reserved.
# 

"""
个人详细信息与兴趣标签
"""
import os


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

    NOTIFICATION_STATUS_ON = 1
    NOTIFICATION_STATUS_OFF = 0

    # 赞(第一次赞就有通知)
    NOTIFICATION_FOR_LIKE = 1 
    # 评论
    NOTIFICATION_FOR_COMMENT = 2
    # 日志更新
    NOTIFICATION_FOR_JOURNAL = 3
    # 关注的可行(1、日志更新；2、可行项目更改；3、邀请加入；4、申请加入；5、踢人；6、主动退出)
    NOTIFICATION_FOR_START_PROJECT = 4
    # 关注的人(被关注是否有消息通知)
    NOTIFICATION_FOR_START_PEOPLE = 5
    # 联系人消息
    NOTIFICATION_FOR_CONTACT = 6

    TYPE_FOR_USER_FOLLOWING = "0" # 关注的人
    TYPE_FOR_USER_FOLLOWED = "1" # 粉丝
    TYPE_FOR_USER_CONTACT = "2" # 已交换联系方式的人

    TYPE_FOR_PROJECT_MEMBER = "0" # 项目成员
    TYPE_FOR_PROJECT_FOLLOWER = "1" # 项目的关注者，项目成员加入时默认关注该项目
    
    pass





