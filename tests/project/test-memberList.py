#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# test-memberList.py
#
# Created by ruibin.chow on 2017/08/21.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""

"""
import requests

def memberList():
    params = {"project_uuid": "000000-7d83-11e7-889b-bbbbbb",
    }
    r = requests.post(url="http://127.0.0.1:5000/service/project/member_list", params=params) 
    print r.cookies
    print(r.text)



if __name__ == '__main__':
    memberList()
    pass

