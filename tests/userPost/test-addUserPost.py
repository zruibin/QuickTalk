#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# test-addUserPost.py
#
# Created by ruibin.chow on 2017/12/04.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""

"""

import requests

tagsString = """
["财经", "科技", "新闻", "艺术", "国际", "军事", "娱乐"]
"""

params = {
    "title":"12324577",
    "content": "http://baidu.com",
    "user_uuid": "bb004ba120ffae3da7a879da82c4b2f6",
    "tagsString":tagsString
}
r = requests.post(url="http://127.0.0.1:5000/service/quickTalk/userPost/addUserPost", params=params)    
print(r.text)


if __name__ == '__main__':
    pass

