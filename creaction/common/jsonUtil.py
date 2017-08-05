#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# jsonUtil.py
#
# Created by ruibin.chow on 2017/08/05.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""
json 响应包装工具
"""

from flask import jsonify ,current_app
import json


def jsonTool(obj):
    indent = None
    separators = (',', ':')
    jsonStr = json.dumps(obj, indent=indent, separators=separators)
    response = current_app.response_class((jsonStr, '\n'), mimetype=current_app.config['JSONIFY_MIMETYPE'])
    return response


if __name__ == '__main__':
    pass
