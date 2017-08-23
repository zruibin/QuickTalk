#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# test-projectUpdate.py
#
# Created by ruibin.chow on 2017/08/23.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""

"""
import requests

def commentAndStart():
    params = {"user_uuid": "f6e996f8-7d83-11e7-889b-8c8590135ddc"}

    r = requests.post(url="http://127.0.0.1:5000/service/message/project_update", params=params) 
    print r.cookies
    print(r.text)



if __name__ == '__main__':
    commentAndStart()
    pass

