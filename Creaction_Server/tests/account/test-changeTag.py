#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# test-changeTag.py
#
# Created by ruibin.chow on 2017/08/09.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""

"""
import requests

taglist = """["listData", "strData", "test python", "listData2", "strData3", "test python44"]"""
taglist ="[]"
cookies = {"token": "MTUwMjI2ODE4OS45NjpMVndDZDFodXFMeU9MYUhsSVlsbUpPVDIzSDA9Cg=="}
params = {"user_uuid": "63f003e3-7cd6-11e7-b407-8c8590135ddc", "taglist":taglist}
r = requests.post(url="http://127.0.0.1:5000/service/account/change_tag", params=params, cookies=cookies)    

print r.cookies
print(r.text)

if __name__ == '__main__':
    pass
