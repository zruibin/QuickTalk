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
from service.quickTalk import quickTalk
from service.quickTalk.userPost import userPost
from service.quickTalk.account import account
from service.quickTalk.like import like
from service.quickTalk.collection import collection
from service.quickTalk.star import star
from service.quickTalk.search import search
from service.quickTalk.user import user



def registerBlueprint(app):
    """ 注册蓝图，并指定前缀""" 
    app.register_blueprint(api, url_prefix="/service/api")
    app.register_blueprint(admin, url_prefix='/admin')
    app.register_blueprint(quickTalk, url_prefix="/service/quickTalk") # 发现
    app.register_blueprint(userPost, url_prefix="/service/quickTalk/userPost") # userPost
    app.register_blueprint(account, url_prefix="/service/quickTalk/account") # account
    app.register_blueprint(like, url_prefix="/service/quickTalk/like") # like
    app.register_blueprint(collection, url_prefix="/service/quickTalk/collection") # 收藏
    app.register_blueprint(star, url_prefix="/service/quickTalk/star") # 关注
    app.register_blueprint(search, url_prefix="/service/quickTalk/search") # 搜索
    app.register_blueprint(user, url_prefix="/service/quickTalk/user") # 用户
    

if __name__ == '__main__':
    pass


