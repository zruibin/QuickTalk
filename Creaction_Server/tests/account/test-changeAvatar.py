#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# test-changeAvatar.py
#
# Created by ruibin.chow on 2017/08/11.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""

"""

import requests

files = {'1': open("../pic/aaa.gif", 'rb')}


url = "http://127.0.0.1:5000/service/account/change_avatar"
data = {"user_uuid": "3f05136c7c04def451b764c88fbcb72c"}

# response = requests.post(url=url, params=params, files=files)

r = requests.post(url=url, data=data, files=files)    

print r.text


if __name__ == '__main__':
    pass


if __name__ == '__main__':
    pass
