#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# test-getVerifyCode.py
#
# Created by ruibin.chow on 2017/08/11.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""

"""
import requests

params = {"account": "creaction@126.com", "type":"1"}
r = requests.get(url="http://127.0.0.1:5000/service/account/get_verify_code", params=params)   # 最基本的GET请求
# r = requests.get(url="http://mljl8.com/service/account/get_verify_code", params=params)
# print(r.status_code)    # 获取返回状态
# r = requests.get(url="http://127.0.0.1:5000/fsfds", params={'wd':'python'}, cookies=cookies)   #带参数的GET请求
print r.cookies
print(r.text)



if __name__ == '__main__':
    pass
