#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# test-changeAvatar.py
#
# Created by ruibin.chow on 2017/11/01.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""

"""

import requests

files = {'1': open("./pic/aaa.gif", 'rb')}


url = "http://127.0.0.1:5000/service/quickTalk/change_avatar"
data = {"user_uuid": "22908c712545dca68ae6a09383f47bc3"}

# response = requests.post(url=url, params=params, files=files)

r = requests.post(url=url, data=data, files=files)    

print r.text


if __name__ == '__main__':
    pass
