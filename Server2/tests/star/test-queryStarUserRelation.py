#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# test-queryStarUserRelation.py
#
# Created by ruibin.chow on 2017/12/18.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""

"""

import requests

uuidList = """
[
    "cea8b1c3aebe31823fa86e069de496b9",
    "bb004ba120ffae3da7a879da82c4b2f6",
    "4ae26100ed5a6ad6990c55d839a5675c"
]
"""

params = {
        "user_uuid": "22908c712545dca68ae6a09383f47bc3",
        "uuidList":uuidList
    }
r = requests.post(url="http://127.0.0.1:5000/service/quickTalk/star/queryStarUserRelation", params=params)    
print(r.text)


if __name__ == '__main__':
    pass
