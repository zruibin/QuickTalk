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


params = {"user_uuid": "bff61aa8523eadd399fb637f4c86a3b0", 
            "oldpassword":"f8f235136f525e39e94f401424954c3a",
            "newpassword":"670b14728ad9902aecba32e22fa4f6bd"
            }
r = requests.post(url="http://127.0.0.1:5000/service/quickTalk/account/changePassword", params=params)    

print r.cookies
print(r.text)



if __name__ == '__main__':
    pass
