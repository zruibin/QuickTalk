#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# test-deleteUserPost.py
#
# Created by ruibin.chow on 2017/12/04.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""

"""
import requests

params = {
    "userPost_uuid":"0ab720fe9652599273f31f2cf11fde49",
    "user_uuid": "bb004ba120ffae3da7a879da82c4b2f6" 
}
r = requests.post(url="http://127.0.0.1:5000/service/quickTalk/userPost/deleteUserPost", params=params)    
print(r.text)


if __name__ == '__main__':
    pass
