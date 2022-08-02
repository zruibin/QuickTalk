#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# test-contactMessage.py
#
# Created by ruibin.chow on 2017/08/20.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""

"""
import requests

def contact():
    params = {"user_uuid": "f6e996f8-7d83-11e7-889b-111111"}

    r = requests.post(url="http://127.0.0.1:5000/service/message/contact", params=params) 
    print r.cookies
    print(r.text)



if __name__ == '__main__':
    contact()
    pass