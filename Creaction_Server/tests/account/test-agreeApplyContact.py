#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# test-agreeApplyContact.py
#
# Created by ruibin.chow on 2017/08/15.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""

"""
import requests

def agreeApplyContact():
    params = {"apply_user_uuid": "f6e996f8-7d83-11e7-889b-8c8590135ddc",
        "user_uuid": "f6e996f8-7d83-11e7-889b-111111"
    }
    r = requests.post(url="http://127.0.0.1:5000/service/account/agree_apply_contact", params=params) 
    print r.cookies
    print(r.text)



if __name__ == '__main__':
    agreeApplyContact()
    pass
