#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# test-checkContact.py
#
# Created by ruibin.chow on 2017/08/10.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""

"""
import requests

def getContact():
    params = {"user_uuid": "f6e996f8-7d83-11e7-889b-8c8590135ddc", "check_user_uuid":"f6e996f8-7d83-11e7-889b-000000"}
    r = requests.get(url="http://127.0.0.1:5000/service/account/check_contact", params=params) 
    print r.cookies
    print(r.text)



if __name__ == '__main__':
    getContact()
    pass


