#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# test-searchProjectByTag.py
#
# Created by ruibin.chow on 2017/08/16.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""

"""
import requests

def searchProjectByTag():
    params = {"searchText": "物理"
    }
    r = requests.post(url="http://127.0.0.1:5000/service/search/search_project_by_tag", params=params) 
    print r.cookies
    print(r.text)



if __name__ == '__main__':
    searchProjectByTag()
    pass
