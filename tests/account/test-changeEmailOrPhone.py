#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# test-changeEmailOrPhone.py
#
# Created by ruibin.chow on 2017/08/11.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""

"""
import requests

cookie = {"token": "MTUwNDkyOTg3MS44NDo3VXRET1c0TzB3R3RVTmxTM3JxTFRNOEdnZEU9Cg=="}

params = {"user_uuid": "e16c75b196233cba88a1f33f227c37c3", 
    "account":"328437740@qq.com", "type": "1"
    }

r = requests.post(url="http://127.0.0.1:5000/service/account/change_email_or_phone", params=params, cookies=cookie)    

print r.cookies
print(r.text)



if __name__ == '__main__':
    pass
