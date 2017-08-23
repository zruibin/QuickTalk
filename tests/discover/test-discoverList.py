#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# test-discoverList.py
#
# Created by ruibin.chow on 2017/08/23.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""

"""

import requests

def discoverList():
    params = {"index": "1"}
    r = requests.post(url="http://127.0.0.1:5000/service/discover/", params=params) 
    print r.cookies
    print(r.text)



if __name__ == '__main__':
    discoverList()
    pass

