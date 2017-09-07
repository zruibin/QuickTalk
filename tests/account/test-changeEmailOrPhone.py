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


params = {"user_uuid": "3f05136c7c04def451b764c88fbcb72c", 
    "account":"328437740@qq.com", "type": "1"
    }

r = requests.post(url="http://127.0.0.1:5000/service/account/change_email_or_phone", params=params)    

print r.cookies
print(r.text)



if __name__ == '__main__':
    pass
