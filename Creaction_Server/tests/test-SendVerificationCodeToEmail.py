#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# test-SendVerificationCodeToEmail.py
#
# Created by ruibin.chow on 2017/08/08.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""

"""
import requests

cookies = {"token": "MTUwMjA5Nzg5Mi42NTpINEsrd1FrMWtMU2xxdXZhRkZHd3N3VnR4U1k9Cg=="}
params = {"email": "ruibin.chow@qq.com"}
r = requests.get(url="http://127.0.0.1:5000/sendcode", cookies=cookies, params=params)    # 最基本的GET请求
# print(r.status_code)    # 获取返回状态
# r = requests.get(url="http://127.0.0.1:5000/fsfds", params={'wd':'python'}, cookies=cookies)   #带参数的GET请求
print(r.text)

if __name__ == '__main__':
    pass
