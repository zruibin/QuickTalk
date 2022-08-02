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
    "content": "今年腾讯全球合作伙伴大会上发布的《2017 微信数据报告》显示，到 2017 年 9 月，微信日成功通话次数 2.05 亿次，月人均通话时长 139 分钟，月人均通话次数 19 次。无论是通话次数还是通话时长都比去年增加了一倍多，这个增长速度远远高于微信用户量的增长，这与微信多媒体团队在音视频技术上的努力是分不开的。",
    "user_uuid": "bb004ba120ffae3da7a879da82c4b2f6",
    "tagsString":tagsString,
    "type": "0"
}
r = requests.post(url="http://127.0.0.1:5000/service/quickTalk/userPost/addUserPost", params=params)    
print(r.text)


if __name__ == '__main__':
    pass

