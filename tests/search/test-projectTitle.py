#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# test-projectTitle.py
#
# Created by ruibin.chow on 2017/08/16.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""

"""
import requests

def projectTitle():
    params = {"searchText": "java",
        "index": "1"
    }
    r = requests.post(url="http://127.0.0.1:5000/service/search/project_title", params=params) 
    print r.cookies
    print(r.text)



if __name__ == '__main__':
    projectTitle()
    pass

