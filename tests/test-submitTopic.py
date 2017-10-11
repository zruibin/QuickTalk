#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# test-submitTopic.py
#
# Created by ruibin.chow on 2017/10/11.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""

"""

import requests

jsondata = """
[
    {
        "title": "111111",
        "detail": "aaaaaaaaaaaaa",
        "href": "http://www.baidu.com"
    },

    {
        "title": "222222",
        "detail": "bbbbbbbbbbbbbbb",
        "href": "http://www.163.com"
    }
]
"""

params = {"jsondata":jsondata}
r = requests.post(url="http://127.0.0.1:5000/service/quickSay/submitTopic", params=params)    
print(r.text)



if __name__ == '__main__':
    pass

