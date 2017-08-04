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

    pass





