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
    "userPost_uuid":"6e5a1c1668abb448407de389a8792bf0",
    "user_uuid": "cea8b1c3aebe31823fa86e069de496b9",
    "comment_uuid": "37b9839472b3ec61adabb92204fe3c90",

    "isReply": "0",
    "reply_uuid": "05fdd943d1d2994e67b10b0cc1f1707b"
}
r = requests.post(url="http://127.0.0.1:5000/service/quickTalk/userPost/deleteUserPostComment", params=params)    
print(r.text)


if __name__ == '__main__':
    pass
