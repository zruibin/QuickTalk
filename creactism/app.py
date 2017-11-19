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
from flask_cors import CORS, cross_origin
from config import *
import register
from common.tools import jsonTool

import sys 
reload(sys) # Python2.5 初始化后会删除 sys.setdefaultencoding 这个方法，我们需要重新载入 
sys.setdefaultencoding('utf-8') 


app = Flask(__name__)
# CORS(app)
app.config['MAX_CONTENT_LENGTH'] = Config.MAX_CONTENT_LENGTH
app.config['ALLOWED_EXTENSIONS'] = Config.ALLOWED_EXTENSIONS
app.config["JSONIFY_MIMETYPE"] = Config.JSONIFY_MIMETYPE
# app.config['JSON_AS_ASCII'] = False
app.config['DEBUG'] = Config.DEBUG


@app.errorhandler(404)
def page_not_found(error):
    return make_response(jsonTool({"code":1, 'error': 'Not found'}), 404)

@app.route('/')
def home():
    return app.send_static_file('index.html')


register.registerBlueprint(app)

if __name__ == '__main__':
    app.run(host='127.0.0.1', port=5000, debug=True)






