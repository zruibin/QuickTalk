#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# test-changeInfo.py
#
# Created by ruibin.chow on 2017/11/01.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""

"""

import requests

url = "http://127.0.0.1:5000/service/quickTalk/change_info"
data = {"user_uuid": "4b27723beb7d9eb85c7a127d4c8967eb", "nickname":"坏坏的小笨熊"}

# response = requests.post(url=url, params=params, files=files)

r = requests.post(url=url, data=data)    

print r.text


if __name__ == '__main__':
    pass

