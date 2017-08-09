#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# test-token.py
#
# Created by ruibin.chow on 2017/08/09.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""

"""
import requests

params = {"user_uuid": "0f114ee3-7cb5-11e7-8a94-8c8590135ddc", "password": "1234fsdfddsdfsfknmms"}
r = requests.get(url="http://127.0.0.1:5000/service/account/token", params=params)    # 最基本的GET请求
# print(r.status_code)    # 获取返回状态
# r = requests.get(url="http://127.0.0.1:5000/fsfds", params={'wd':'python'}, cookies=cookies)   #带参数的GET请求
print r.cookies
print(r.text)

if __name__ == '__main__':
    pass
