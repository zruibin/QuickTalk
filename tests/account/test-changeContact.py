#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# test-changeContact.py
#
# Created by ruibin.chow on 2017/08/09.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""

"""
import requests

""" 
TYPE_FOR_WECHAT = “3”
TYPE_FOR_QQ = “4”
TYPE_FOR_WEIBO = “5”
TYPE_FOR_CONTACT_PHONE = “6”
TYPE_FOR_CONTACT_EMAIL = “7”
"""

taglist = """["listData", "strData", "test python", "listData2", "strData3", "test python44"]"""
taglist ="[]"
cookies = {"token": "MTUwMjI3MTM2Ni4xNjpmbEcrTGEvT21nNnFhWkJFNkI4bUVGcml4NmM9Cg=="}
params = {"user_uuid": "c9197c3a-7cdd-11e7-8ddc-8c8590135ddc", "type":"3", "content":"ruibin.chow"}
r = requests.post(url="http://127.0.0.1:5000/service/account/change_contact", params=params, cookies=cookies)    

print r.cookies
print(r.text)


if __name__ == '__main__':
    pass
