#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# main.py
#
# Created by zruibin on 2017/07/24.
# Copyright (c) 2017年 zruibin All rights reserved.
# 

"""

"""


from flask import Flask
from config import DevConfig
from module.auth import auth

app = Flask(__name__)
app.config.from_object(DevConfig)


@app.errorhandler(404) 
def page_not_found(error): 
    return '<h1>404 not found!</h1>'

@app.route('/')
def home():
    return '<h1>Hello zruibin!</h1>'

app.register_blueprint(auth,url_prefix='/auth')    #注册asset蓝图，并指定前缀。

if __name__ == '__main__':
    app.run(debug=True)