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

import sys, os
reload(sys) # Python2.5 初始化后会删除 sys.setdefaultencoding 这个方法，我们需要重新载入 
sys.setdefaultencoding('utf-8') 

# 第三方库
# sys.path.append(sys.path[0] + "/lib/pygetui")
sys.path.append("./lib")
sys.path.append("./lib/pygetui")

from flask import Flask, make_response, request, redirect
from flask_cors import CORS, cross_origin
from config import *
import register
from common.tools import jsonTool


app = Flask(__name__)
# CORS(app)
app.config['MAX_CONTENT_LENGTH'] = Config.MAX_CONTENT_LENGTH
app.config['ALLOWED_EXTENSIONS'] = Config.ALLOWED_EXTENSIONS
app.config["JSONIFY_MIMETYPE"] = Config.JSONIFY_MIMETYPE
# app.config['JSON_AS_ASCII'] = False
app.config['DEBUG'] = Config.DEBUG

# 注册模块
register.registerBlueprint(app)


@app.errorhandler(404)
def page_not_found(error):
    return make_response(jsonTool({"code":1, 'error': 'Not found'}), 404)

@app.route('/')
def home():
    return app.send_static_file('index.html')


""""
@app.before_request  
def beforeRequest():  
    print "beforeRequest..."
    ip = request.remote_addr  
    url = request.url
    real_ip = request.headers.get('X-Real-Ip', request.remote_addr)
    print real_ip
    # print ip,  
    # print url
    print request.headers
    return make_response(jsonTool({"code":1, "message": "break..."}))

@app.after_request
def afterRequest(response):
    print "afterRequest..."
    return response
#"""




if __name__ == '__main__':
    app.run(host='127.0.0.1', port=5000, debug=True)






