#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# test-setUserPostTags.py
#
# Created by ruibin.chow on 2018/01/15.
# Copyright (c) 2018年 ruibin.chow All rights reserved.
# 

"""

"""

import requests

tagsString = """
["财经", "科技", "新闻", "艺术", "国际", "军事", "娱乐", 
          "体育", "健康", "历史", "时尚", "社会", "汽车", "科普"]
"""

params = {
    "userPost_uuid":"daa5b2166fa73e4d0069b30a87eff98f",
    "tagsString": tagsString,
    "user_uuid": "bb004ba120ffae3da7a879da82c4b2f6"
}
r = requests.post(url="http://127.0.0.1:5000/service/quickTalk/userPost/setUserPostTags", params=params)    
print(r.text)


if __name__ == '__main__':
    pass
