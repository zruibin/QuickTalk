#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# app.py
#
# Created by ruibin.chow on 2017/07/24.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""

"""
 
from flask import Flask, Response, Request
from config import Config
import register

app = Flask(__name__)
# app.config.from_object(DevConfig)


@app.errorhandler(404) 
def page_not_found(error): 
    return app.send_static_file('404.html')

@app.route('/')
def home():
    return app.send_static_file('index.html')

# @app.route("/media/u/<user_uuid>/<imageid>")
# def index(imageid):
#     image = file("media/user/{}/{}".format(user_uuid, imageid))
#     resp = Response(image, mimetype="image/jpeg")
#     return resp



register.register(app)

if __name__ == '__main__':
    app.run(host='127.0.0.1', port=5000, debug=True)






