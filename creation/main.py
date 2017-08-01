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
from config import Config
import register

app = Flask(__name__)
# app.config.from_object(DevConfig)


@app.errorhandler(404) 
def page_not_found(error): 
    return '<h1>404 not found!</h1>'

@app.route('/')
def home():
    return '<h1>Hello zruibin!</h1>'

register.register(app)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)