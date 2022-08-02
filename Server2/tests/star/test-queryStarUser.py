#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# test-queryStarUser.py
#
# Created by ruibin.chow on 2017/12/18.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""

"""

import requests

params = {
        "user_uuid": "cea8b1c3aebe31823fa86e069de496b9"
    }
r = requests.post(url="http://127.0.0.1:5000/service/quickTalk/star/queryStarUser", params=params)    
print(r.text)


if __name__ == '__main__':
    pass
