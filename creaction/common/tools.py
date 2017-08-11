#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# tools.py
#
# Created by ruibin.chow on 2017/08/05.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""
json 响应包装工具
"""

from flask import current_app, request
import json, uuid, time, hashlib


def jsonTool(obj):
    indent = None
    separators = (',', ':')
    jsonStr = json.dumps(obj, indent=indent, separators=separators)
    response = current_app.response_class((jsonStr, "\n"), mimetype=current_app.config["JSONIFY_MIMETYPE"])
    return response


def generateUUID():
    """由MAC地址、当前时间戳、随机数生成。可以保证全球范围内的唯一性，
        但MAC的使用同时带来安全性问题，局域网中可以使用IP来代替MAC """
    uuidStr = uuid.uuid1()
    return uuidStr


def generateCurrentTime():
    timeStr = time.strftime('%Y-%m-%d %H:%M:%S', time.localtime(time.time()))
    return timeStr
    

def md5hex(word):  
    """ MD5加密算法，返回32位小写16进制符号 """  
    if len(word) == 0:
        return word
    if isinstance(word, unicode):  
        word = word.encode("utf-8")  
    elif not isinstance(word, str):  
        word = str(word)  
    m = hashlib.md5()  
    m.update(word)  
    return m.hexdigest()


def getValueFromRequestByKey(key):
    """从request中的args或form中取得值"""
    value = request.args.get(key) if request.args.get(key) else request.form.get(key)
    return value
    




if __name__ == '__main__':
    pass
