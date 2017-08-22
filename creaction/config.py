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

    WEB_SITE_HOST = "http://creactism.com/"
    LOG_DIR = "./logs/"

    DBHOST = "localhost"
    DBPORT = 3306
    DBUSER = "root"
    DBPWD = "0928"
    DBNAME = "creaction"
    DBCHAR = "utf8"
    DBPOOLSIZE = 10
    DB_BACKUP_DIR = "/home/mysqlbak" # 数据库备份目录

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
    ALLOWED_EXTENSIONS = set(["png", "jpg", "jpeg", "gif"])

    MAIL_HOST = "smtp.exmail.qq.com"  #设置服务器
    MAIL_USER = "auto.mail"    #用户名
    MAIL_PASSWORD = "CreAction1"   #口令 
    MAIL_POSTFIX = "creactism.com"  #发件箱的后缀

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

    TYPE_FOR_AUTH_ACTION_ON = "1" # 绑定
    TYPE_FOR_AUTH_ACTION_OFF = "2" #解绑

    # 上传文件的所属类型，分别为用户与项目
    UPLOAD_FILE_FOR_USER = "u"
    UPLOAD_FILE_FOR_PROJECT = "p"

    # 上传图片最大数量
    UPLOAD_FILE_FOR_PROJECT_MEDIAS_COUNT = 9
    UPLOAD_FILE_FOR_JOURNAL_MEDIAS_COUNT = 9

    PAGE_OF_SIZE = 10 # 分页每页数量

    STATUS_ON = 1
    STATUS_OFF = 0

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

    TYPE_FOR_USER_FOLLOWING = "1" # 关注的人与粉丝
    TYPE_FOR_USER_CONTACT = "2" # 已交换联系方式的人

    TYPE_FOR_USER_QUERY_FOLLOWING = "1" # 查询关注人
    TYPE_FOR_USER_QUERY_FOLLOWED = "2" # 查询粉丝

    # 项目成员与关注者
    TYPE_FOR_PROJECT_MEMBER = "1" # 项目成员
    TYPE_FOR_PROJECT_FOLLOWER = "2" # 项目的关注者，项目成员加入时默认关注该项目

    # 项目状态
    TYPE_FOR_PROJECT_STATUS_PROGRESSING = 0 # 进行中
    TYPE_FOR_PROJECT_STATUS_COMPLETE = 1 # 完成
    TYPE_FOR_PROJECT_STATUS_GIVEUP = 2 # 放弃

    # 项目多媒体类型
    TYPE_FOR_PROJECT_MEDIAS_PICTURE = 1 # 项目图片多媒体
    TYPE_FOR_PROJECT_MEDIAS_VOICE = 2 # 项目声音多媒体
    TYPE_FOR_PROJECT_MEDIAS_VIDEO = 3 # 项目视频多媒体
    
    # 消息已读与未读状态
    TYPE_FOR_MESSAGE_READ = 1
    TYPE_FOR_MESSAGE_UNREAD = 0

    # 请求消息中已执行与未执行状态
    TYPE_FOR_MESSAGE_ACTION_ON = 1 # 已执行
    TYPE_FOR_MESSAGE_ACTION_OFF = 0 # 未执行

    # 项目相关的消息类型,
    TYPE_FOR_MESSAGE_IN_PROJECT_UPDATE_JOURNAL = 1 # 日志更新
    TYPE_FOR_MESSAGE_IN_PROJECT_UPDATE_PROJECT = 2 # 可行项目更改
    TYPE_FOR_MESSAGE_IN_PROJECT_FOR_INVITE = 3 # 邀请加入
    TYPE_FOR_MESSAGE_IN_PROJECT_TO_APPLY = 4 # 申请加入
    TYPE_FOR_MESSAGE_IN_PROJECT_TO_REMOVE = 5 # 踢人
    TYPE_FOR_MESSAGE_IN_PROJECT_TO_WITHDRAW = 6 # 主动退出
    TYPE_FOR_MESSAGE_IN_PROJECT_INVITE_AGREE = 7 # 同意邀请加入
    TYPE_FOR_MESSAGE_IN_PROJECT_APPLY_AGREE = 8 # 作者同意加入

    # 评论类型与消息
    TYPE_FRO_COMMENT = "0"
    TYPE_FOR_REPLY_COMMENT = "1"
    TYPE_FOR_MESSAGE_IN_PROJECT_COMMENT = TYPE_FRO_COMMENT
    TYPE_FOR_MESSAGE_IN_PROJECT_FOR_REPLY_COMMENT = TYPE_FOR_REPLY_COMMENT

    TYPE_FOR_START_PROJECT = "1" # 关注或取消关注项目
    TYPE_FOR_START_USER = "2" # 关注或取消关注用户
    TYPE_FOR_START_ACTION_STARTING = "1" # 关注
    TYPE_FOR_START_ACTION_UNSTART = "2" # 取消

    

    pass





