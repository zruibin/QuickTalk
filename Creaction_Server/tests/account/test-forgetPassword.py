#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# test-forgetPassword.py
#
# Created by ruibin.chow on 2017/08/14.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""

"""
import requests

def forgetPassword():
    params = {"account": "18588430034", "code":"112112", "type":"2", "newpassword":"232323"}
    r = requests.post(url="http://127.0.0.1:5000/service/account/forget_password", params=params) 
    print r.cookies
    print(r.text)

if __name__ == '__main__':
    forgetPassword()
    pass
