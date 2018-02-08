#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# __init__.py
#
# Created by ruibin.chow on 2018/02/08.
# Copyright (c) 2018年 ruibin.chow All rights reserved.
# 

"""

"""

from flask import Blueprint
import requests
from module.log.Log import Loger
from config import *
from common.code import *
from common.tools import getValueFromRequestByKey
import demjson

blog = Blueprint("blog", __name__)



def get_header():
    return {  
        'User-Agent': 'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/45.0.2454.101 Safari/537.36',
        'Content-Type': 'application/json',
        'Accept': '*/*',
        'Accept-Encoding': 'gzip, deflate',
        'Accept-Language': 'zh-CN,zh;q=0.8',
    }  

@blog.route('/', methods=["GET", "POST"])
def blogAction():
    params = getValueFromRequestByKey("params")
    if params == None:
        return RESPONSE_JSON(CODE_ERROR_MISS_PARAM)
        
    try:
        r = requests.get(url="http://zruibin.cc/api/"+params, headers=get_header(), timeout=5) 
        jsonText = r.text
        jsonDict = demjson.decode(jsonText)
        data = jsonDict["data"]
        return RESPONSE_JSON(CODE_SUCCESS, data)
    except Exception as e:
        Loger.error(e, __file__)
        return RESPONSE_JSON(CODE_ERROR_SERVICE)




if __name__ == '__main__':
    pass
