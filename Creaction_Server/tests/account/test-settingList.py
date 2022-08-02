#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# test-settingList.py
#
# Created by ruibin.chow on 2017/09/06.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""

"""
import requests


params = {"user_uuid": "3f05136c7c04def451b764c88fbcb72c"}
r = requests.post(url="http://127.0.0.1:5000/service/account/setting_list", params=params)    # 最基本的GET请求

print(r.text)


if __name__ == '__main__':
    pass
