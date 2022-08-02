#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# test-announceList.py
#
# Created by ruibin.chow on 2017/08/22.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""

"""
import requests

def announceList():
    params = {"project_uuid": "000000-7d83-11e7-889b-bbbbbb",
        "index": "1"
    }
    r = requests.post(url="http://127.0.0.1:5000/service/project/announce", params=params) 
    print r.cookies
    print(r.text)



if __name__ == '__main__':
    announceList()
    pass
