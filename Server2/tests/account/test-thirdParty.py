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

def thirdParty():
    params = {"user_uuid": "cea8b1c3aebe31823fa86e069de496b9",
        "method":"1",
        "type":"8",
        "openId":"000000",
    }
    r = requests.post(url="http://127.0.0.1:5000/service/quickTalk/account/thirdParty", params=params) 
    print r.cookies
    print(r.text)



if __name__ == '__main__':
    thirdParty()
    pass