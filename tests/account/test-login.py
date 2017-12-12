#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# test-login.py
#
# Created by ruibin.chow on 2017/08/14.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""

"""
import requests

def login():
    # f8f235136f525e39e94f401424954c3a 0928
    #03d49d1570513eedea668cb8421784d1 
    params = {"account": "18588430034", "type":"2", "password":"f8f235136f525e39e94f401424954c3a"}
    r = requests.post(url="http://127.0.0.1:5000/service/quickTalk/account/login", params=params) 
    print r.cookies
    print(r.text)

def loginWithThirdPart():
    params = {"account": "670b14728ad9902aecba32e22fa4f6bd", "type":"10"}
    r = requests.post(url="http://127.0.0.1:5000/service/quickTalk/account/login", params=params) 
    print r.cookies
    print(r.text)

"""
000000 670b14728ad9902aecba32e22fa4f6bd
"""
def loginWithNewThirdPart():
    params = {"account": "670b14728ad9902aecba32e22fa4f6bd", "type":"10"}
    r = requests.post(url="http://127.0.0.1:5000/service/quickTalk/account/login", params=params) 
    print r.cookies
    print(r.text)

if __name__ == '__main__':
    # login()
    loginWithThirdPart()
    # loginWithNewThirdPart()
    pass


"""
{
"message": "请求成功",
"code": 10000,
"data": {
        "qq": "",
        "weibo": "",
        "uuid": "bff61aa8523eadd399fb637f4c86a3b0",
        "gender": 0,
        "detail": null,
        "id": 10027,
        "phone": "18588430034",
        "token": "MTUxMzA1MjQ1NS44NTpmUDNYR0pEdHdIRFdHK2JqeW5ZUW8rLzdFMGc9Cg==",
        "wechat": "",
        "avatar": "",
        "password": "03d49d1570513eedea668cb8421784d1",
        "nickname": "",
        "email": ""
    }
}
"""