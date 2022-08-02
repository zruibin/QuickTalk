#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# test-thirdParty.py
#
# Created by ruibin.chow on 2017/08/11.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""

"""
import requests

def getContact():
    params = {"user_uuid": "f6e996f8-7d83-11e7-889b-8c8590135ddc",
        "method":"1",
        "type":"10",
        "openId":"000000",
    }
    r = requests.post(url="http://127.0.0.1:5000/service/account/third_party", params=params) 
    print r.cookies
    print(r.text)



if __name__ == '__main__':
    getContact()
    pass