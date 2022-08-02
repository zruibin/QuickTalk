#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# test-queryStar.py
#
# Created by ruibin.chow on 2017/09/17.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""

"""
import requests

def queryStar():
    params = {"user_uuid": "e16c75b196233cba88a1f33f227c37c3",
        "type": "2", "uuid": "e16c75b196233cba88a1f33f227c37c3"
    }
    r = requests.post(url="http://127.0.0.1:5000/service/star/query_star", params=params) 
    print r.cookies
    print(r.text)



if __name__ == '__main__':
    queryStar()
    pass
