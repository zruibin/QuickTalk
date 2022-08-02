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
    #5dc2d9374b5f433df4447aa796f5b18c
    params = {"account": "18588430034", "code":"112112", "type":"2", "password":"e10adc3949ba59abbe56e057f20f883e"}
    r = requests.post(url="http://127.0.0.1:5000/service/account/login", params=params) 
    print r.cookies
    print(r.text)

def loginWithThirdPart():
    params = {"authOpenId": "123123", "type":"9"}
    r = requests.post(url="http://127.0.0.1:5000/service/account/login", params=params) 
    print r.cookies
    print(r.text)

def loginWithNewThirdPart():
    params = {"authOpenId": "000000", "type":"10"}
    r = requests.post(url="http://127.0.0.1:5000/service/account/login", params=params) 
    print r.cookies
    print(r.text)

if __name__ == '__main__':
    login()
    # loginWithThirdPart()
    # loginWithNewThirdPart()
    pass


