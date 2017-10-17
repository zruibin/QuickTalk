#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# test-login.py
#
# Created by ruibin.chow on 2017/10/12.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""

"""


import requests

files = {'1': open("./pic/aaa.gif", 'rb')}


url = "http://127.0.0.1:5000/service/quickTalk/login"
data = {"openId": "1234567", "type": "8"}

# response = requests.post(url=url, params=params, files=files)

r = requests.post(url=url, data=data, files=files)    

print r.text


if __name__ == '__main__':
    pass
