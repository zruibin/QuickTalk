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

files = {'1': open("./pic/default.png", 'rb')}


url = "http://127.0.0.1:5000/service/quickTalk/loginWithAvatar"
data = {"openId": "1012121", "type": "8", "avatar": "http://upload.jianshu.io/users/upload_avatars/1284665/9d18b920-5a4c-4b37-bd82-aba48066f39d.JPG?imageMogr2/auto-orient/strip|imageView2/1/w/96/h/96"}

# response = requests.post(url=url, params=params, files=files)

r = requests.post(url=url, data=data)    

print r.text


if __name__ == '__main__':
    pass
