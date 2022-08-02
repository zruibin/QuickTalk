#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# test-TokenAndCookie.py
#
# Created by ruibin.chow on 2017/08/07.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""

"""
import requests

cookies = {"token": "MTUwMjA5Nzg5Mi42NTpINEsrd1FrMWtMU2xxdXZhRkZHd3N3VnR4U1k9Cg=="}
params = {"user_uuid": "ruibin.chow_zruibin"}
r = requests.get(url="http://127.0.0.1:5000/fsfds", cookies=cookies, params=params)    # 最基本的GET请求
# print(r.status_code)    # 获取返回状态
# r = requests.get(url="http://127.0.0.1:5000/fsfds", params={'wd':'python'}, cookies=cookies)   #带参数的GET请求
print(r.text)

if __name__ == '__main__':
    pass
