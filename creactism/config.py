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
import pprint 


class Config(object):

  DEBUG = True

  WEB_SITE_HOST = "http://creactism.com/"
  LOG_DIR = "logs/"
  WEB_SITE_DIR = "/home/creactism"
  BACKUP_DIR = "/home/creactism_bak" # 数据备份目录
  BACKUP_DAYS = 30 # 备份天数

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

  TOKEN_EXPIRE = CACHE_EXPIRE

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

  STATUS_ON = 1
  STATUS_OFF = 0

  TYPE_FOR_GENDER_MALE = 1
  TYPE_FOR_GENDER_FEMALE = 2

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

  TYPE_FOR_COMMENT_DEFAULT = "0"
  TYPE_FOR_COMMENT_REPLY = "1"

  LIKE_ACTION_AGREE = "1"
  LIKE_ACTION_DISAGREE = "2"

  # 消息已读与未读状态
  TYPE_MESSAGE_READ = 1
  TYPE_MESSAGE_UNREAD = 0

  TYPE_MESSAGE_LIKE_TOPIC = "0"
  TYPE_MESSAGE_LIKE_TOPIC_COMMENT = "1"
  TYPE_MESSAGE_LIKE_USERPOST = "2"
  TYPE_MESSAGE_LIKE_USERPOST_COMMENT = "3"
  TYPE_MESSAGE_USERPOST_COMMENT = "4"
  TYPE_MESSAGE_USERPOST_REPLY_COMMENT = "5"
  TYPE_MESSAGE_NEW_STAR = "6"
  TYPE_MESSAGE_NEW_SHARE = "7"

  NOTIFICATION_TYPE_FOR_Android = 3
  NOTIFICATION_TYPE_FOR_iOS = 4

  # 赞(第一次赞就有通知)
  NOTIFICATION_FOR_LIKE = 1 
  # 评论
  NOTIFICATION_FOR_COMMENT = 2
  # 加关注的
  NOTIFICATION_FOR_NEW_STAR = 3
  # 关注的好友的发表的分享
  NOTIFICATION_FOR_NEW_SHARE = 4

  TYPE_FOR_AUTH_ACTION_ON = "1" # 绑定
  TYPE_FOR_AUTH_ACTION_OFF = "2" #解绑

  # 收藏与取消收藏
  COLLECTION_ACTION_ON = "1"
  COLLECTION_ACTION_OFF = "2"

  # 收藏类型
  TYPE_FOR_COLLECTION_ALL = "0"
  TYPE_FOR_COLLECTION_USERPOST = "1"

  # 关注与取消关注
  STAR_ACTION_FOR_STAR = "1"
  STAR_ACTION_FOR_UNSTAR = "2"

  # 关注类型
  TYPE_STAR_FOR_USER_RELATION = "0"

  # 阅读类型
  TYPE_READ_FOR_USERPOST = "1"

  # userPost类型
  TYPE_USERPOST_FOR_REPOST = "0" # 转载
  TYPE_USERPOST_FOR_ORIGINAL = "1" # 原创


  CACHE_PREFIX_userPost = "userPost"
  CACHE_PREFIX_userPost_tag = "userPost_tag"
  CACHE_PREFIX_userPost_add = "userPost_"
  CACHE_PREFIX_liked = "liked_"
  CACHE_PREFIX_comment = "comment_"
  CACHE_PREFIX_collection = "collection_"
  CACHE_PREFIX_reading = "reading_"
  CACHE_PREFIX_reading_cache = "reading_cache_"

  pass



def DLog(data, format=True):
  if Config.DEBUG:
    if format:
      pprint.pprint(data)
    else:
        print data    
  pass


