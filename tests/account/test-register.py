#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# test-register.py
#
# Created by ruibin.chow on 2017/08/08.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""

"""
import requests

def baseRegister():
    params = {"account": "18588430034", "type":"2", "password": "1234fsdfddsdfsfknmms"}
    r = requests.post(url="http://127.0.0.1:5000/service/account/register", params=params)    # 最基本的GET请求
    # print(r.status_code)    # 获取返回状态
    # r = requests.get(url="http://127.0.0.1:5000/fsfds", params={'wd':'python'}, cookies=cookies)   #带参数的GET请求
    print r.cookies
    print(r.text)

def authRegister():
    params = {"account": "18588430034", "type":"2", "password": "1234fsdfddsdfsfknmms",
        "authOpenId": "121212",
        "authType" : "8"
    }
    r = requests.post(url="http://127.0.0.1:5000/service/account/register", params=params)    # 最基本的GET请求
    # print(r.status_code)    # 获取返回状态
    # r = requests.get(url="http://127.0.0.1:5000/fsfds", params={'wd':'python'}, cookies=cookies)   #带参数的GET请求
    print r.cookies
    print(r.text)


if __name__ == '__main__':
    # baseRegister()
    authRegister()
    pass
