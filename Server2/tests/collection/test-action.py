#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# test-action.py
#
# Created by ruibin.chow on 2017/12/15.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""

"""

import requests

def on():
    params = {
        "type":"1",
        "user_uuid": "cea8b1c3aebe31823fa86e069de496b9",
        "content_uuid": "6e5a1c1668abb448407de389a8792bf0",
        "action": "1"
    }
    r = requests.post(url="http://127.0.0.1:5000/service/quickTalk/collection/action", params=params)    
    print(r.text)
    

def off():
    params = {
        "type":"1",
        "user_uuid": "cea8b1c3aebe31823fa86e069de496b9",
        "content_uuid": "6e5a1c1668abb448407de389a8792bf0",
        "action": "2"
    }
    r = requests.post(url="http://127.0.0.1:5000/service/quickTalk/collection/action", params=params)    
    print(r.text)




if __name__ == '__main__':
    on()
    # off()
    pass
