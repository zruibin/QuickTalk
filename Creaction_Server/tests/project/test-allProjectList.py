#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# test-allProjectList.py
#
# Created by ruibin.chow on 2017/08/17.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""
000000-7d83-11e7-889b-bbbbbb

"""
import requests

def allProjectList():
    params = {"user_uuid": "4fc193b19483091ffd422c964aee50a7",
        "index": "1"
    }
    r = requests.post(url="http://127.0.0.1:5000/service/project/all_project_list", params=params) 
    print r.cookies
    print(r.text)



if __name__ == '__main__':
    allProjectList()
    pass
