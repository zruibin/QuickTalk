#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# test-changePassword.py
#
# Created by ruibin.chow on 2017/08/12.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""

"""

import requests


params = {"user_uuid": "f6e996f8-7d83-11e7-889b-000000", 
            "oldpassword":"1234567",
            "newpassword":"0928"
            }
r = requests.post(url="http://127.0.0.1:5000/service/account/change_password", params=params)    

print r.cookies
print(r.text)



if __name__ == '__main__':
    pass
