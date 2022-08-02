#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# test-myProject.py
#
# Created by ruibin.chow on 2017/08/17.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""

"""
import requests

def myProjectList():
    params = {"user_uuid": "4fc193b19483091ffd422c964aee50a7",
        "index": "1"
    }
    r = requests.post(url="http://127.0.0.1:5000/service/project/my_project_list", params=params) 
    print r.cookies
    print(r.text)



if __name__ == '__main__':
    myProjectList()
    pass