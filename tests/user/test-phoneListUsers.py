#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# test-phoneListUsers.py
#
# Created by ruibin.chow on 2017/12/18.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""

"""


import requests

phoneList = """
[
    "13113324024",
    "18588430034",
    "13316449950",
    "18402017862",
    "13631241771",
    "13818209557"
]
"""

params = {
        # "user_uuid": "cea8b1c3aebe31823fa86e069de496b9",
        "phoneList":phoneList
    }
r = requests.post(url="http://127.0.0.1:5000/service/quickTalk/user/phoneListUsers", params=params)    
print(r.text)


if __name__ == '__main__':
    pass
