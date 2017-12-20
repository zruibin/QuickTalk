#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# test-queryLikeRelation.py
#
# Created by ruibin.chow on 2017/12/20.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""

"""

import requests

uuidList = """
[
    "6e5a1c1668abb448407de389a8792bf0",
    "6e5a1c1668abb448407de389a8792bf0",
    "8e230a7326941939a6266ec955be45c1",
    "366c21affef697ee4c0b937f5bbed45e"
]
"""

params = {
        "user_uuid": "fbd1d63882ff73751accacd39621fa9c",
        "uuidList":uuidList
    }
r = requests.post(url="http://127.0.0.1:5000/service/quickTalk/like/queryLikeRelation", params=params)    
print(r.text)


if __name__ == '__main__':
    pass


if __name__ == '__main__':
    pass
