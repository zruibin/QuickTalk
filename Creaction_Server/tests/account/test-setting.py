#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# test-setting.py
#
# Created by ruibin.chow on 2017/08/09.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""

"""

import requests

cookies = {"token": "MTUwMjI2NDI4MC4xMjo5aVpnc1puNFkyaXpNMVJaRUtvOStPblFYeFk9Cg=="}
params = {"user_uuid": "497da307-7ccd-11e7-b9f7-8c8590135ddc", "type":"2", "status": "0"}
r = requests.post(url="http://127.0.0.1:5000/service/account/setting", params=params, cookies=cookies)    # 最基本的GET请求
# print(r.status_code)    # 获取返回状态
# r = requests.get(url="http://127.0.0.1:5000/fsfds", params={'wd':'python'}, cookies=cookies)   #带参数的GET请求
print r.cookies
print(r.text)


if __name__ == '__main__':
    pass
