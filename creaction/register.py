#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# register.py
#
# Created by zruibin on 2017/07/24.
# Copyright (c) 2017年 zruibin All rights reserved.
# 

"""

"""

from service.api import api
from service.admin import admin

from service.account import account
from service.start import start
from service.search import search
from service.project import project
from service.user import user
from service.message import message
from service.like import like


def registerBlueprint(app):
    """ 注册蓝图，并指定前缀""" 
    app.register_blueprint(api, url_prefix="/service/api")
    app.register_blueprint(admin, url_prefix='/admin')

    app.register_blueprint(account, url_prefix="/service/account") # 帐号
    app.register_blueprint(start, url_prefix="/service/start") # 关注
    app.register_blueprint(search, url_prefix="/service/search") # 搜索
    app.register_blueprint(project, url_prefix="/service/project") # 项目
    app.register_blueprint(user, url_prefix="/service/user") # 用户
    app.register_blueprint(message, url_prefix="/service/message") # 用户消息
    app.register_blueprint(like, url_prefix="/service/like") # 点赞
    

if __name__ == '__main__':
    pass


