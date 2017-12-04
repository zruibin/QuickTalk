#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# test-deleteUserPostComment.py
#
# Created by ruibin.chow on 2017/12/04.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""

"""


import requests

params = {
    "userPost_uuid":"61c7b80fecd1c3b6d18d85f6c1fe7d4d",
    "user_uuid": "cea8b1c3aebe31823fa86e069de496b9",
    "comment_uuid": "12f7b54f3cce07bf4d707c97effb8497"
}
r = requests.post(url="http://127.0.0.1:5000/service/quickTalk/userPost/deleteUserPostComment", params=params)    
print(r.text)


if __name__ == '__main__':
    pass
