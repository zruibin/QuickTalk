#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# test-statusChange.py
#
# Created by ruibin.chow on 2017/08/18.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""

"""
import requests

def changeProjectStatus():
    params = {"user_uuid": "f6e996f8-7d83-11e7-889b-222222",
        "project_uuid" : "000000-7d83-11e7-889b-aaaaaa",
        "status": "1"
    }
    r = requests.post(url="http://127.0.0.1:5000/service/project/status_change", params=params) 
    print r.cookies
    print(r.text)



if __name__ == '__main__':
    changeProjectStatus()
    pass
