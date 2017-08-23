#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# test-queryLike.py
#
# Created by ruibin.chow on 2017/08/23.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""

"""
import requests
import json

def queryLike():
    
    uuidList = ["8e0d9f0a5d56742913f4158d08173132", "4c89d716178beb8a39dea789c4de8f58",
                     "wweweweweewe", "6f443d21-8637-11e7-8132-8c8590135ddc"]
    uuidListStr = json.dumps(uuidList)
    print uuidListStr
    params = {"user_uuid": "f6e996f8-7d83-11e7-889b-8c8590135ddc", "type":"3", 
            "like_uuid_list": uuidListStr}

    r = requests.post(url="http://127.0.0.1:5000/service/like/query_like", params=params) 
    print r.cookies
    print(r.text)



if __name__ == '__main__':
    queryLike()
    pass

