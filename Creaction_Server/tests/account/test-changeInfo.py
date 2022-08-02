#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# test-changeInfo.py
#
# Created by ruibin.chow on 2017/08/11.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""

"""
import requests

userdata = """
{
        "nickname":"用户昵称2121212133",
        "gender":0,
        "area":"坐标",
        "detail":"简介",
        "school":["学校1", "学校2", "学校3", "学校244444"],
        "career":"职业"
}
"""
# userdata =""
cookies = {"token": "MTUwMjI2ODE4OS45NjpMVndDZDFodXFMeU9MYUhsSVlsbUpPVDIzSDA9Cg=="}
params = {"user_uuid": "f6e996f8-7d83-11e7-889b-000000", "userdata":userdata}
r = requests.post(url="http://127.0.0.1:5000/service/account/change_info", params=params, cookies=cookies)    

print r.cookies
print(r.text)



if __name__ == '__main__':
    pass
