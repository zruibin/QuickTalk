#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# test-comment.py
#
# Created by ruibin.chow on 2017/10/12.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""

"""
import requests

params = {
    "user_uuid": "22908c712545dca68ae6a09383f47bc3",
    "topic_uuid":"26dd884ce5f45f1651750e937484156e",
    "content": "Android 3.0系"
}
r = requests.post(url="http://127.0.0.1:5000/service/quickTalk/comment", params=params)    
print(r.text)



if __name__ == '__main__':
    pass
