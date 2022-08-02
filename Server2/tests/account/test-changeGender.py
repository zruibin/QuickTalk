#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# test-changeGender.py
#
# Created by ruibin.chow on 2017/12/04.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""

"""
import requests

url = "http://127.0.0.1:5000/service/quickTalk/account/change_gender"
data = {"user_uuid": "cea8b1c3aebe31823fa86e069de496b9", "gender":"2"}

# response = requests.post(url=url, params=params, files=files)

r = requests.post(url=url, data=data)    

print r.text


if __name__ == '__main__':
    pass
