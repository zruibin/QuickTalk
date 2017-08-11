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

from flask import Flask, make_response, request
from config import *
import register
from module.log.Log import LogHandle
from common.tools import jsonTool
from common.auth import vertifyTokenHandle

from common.code import *
from common.file import uploadFile
from common.mail import sendEmailForVerifyCodeByCache

app = Flask(__name__)
app.config['MAX_CONTENT_LENGTH'] = Config.MAX_CONTENT_LENGTH
app.config['ALLOWED_EXTENSIONS'] = Config.ALLOWED_EXTENSIONS
app.config['DEBUG'] = Config.DEBUG


@app.errorhandler(404)
# @vertifyTokenHandle
def page_not_found(error):
    # return app.send_static_file('404.html')
    return make_response(jsonTool({"code":1, 'error': 'Not found'}), 404)

@app.route('/')
def home():
    return app.send_static_file('index.html')

# @app.route("/media/u/<user_uuid>/<imageid>")
# def index(imageid):
#     image = file("media/user/{}/{}".format(user_uuid, imageid))
#     resp = Response(image, mimetype="image/jpeg")
#     return resp

@app.route('/upload', methods=['POST'])
def upload():
    return uploadFile("user", "zruibin")
    pass


register.registerBlueprint(app)

if __name__ == '__main__':
    app.run(host='127.0.0.1', port=5000, debug=True)






