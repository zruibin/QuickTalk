#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# test-addUserPostComment.py
#
# Created by ruibin.chow on 2017/12/04.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""

"""

import requests

params = {
    "userPost_uuid":"ac52eb6078759dc410068794f9156462",

    "content": "虽然最近频频出现在电视剧和电影里，还有一档量身定制般的喜剧网络剧《深井食堂》。不过小白最惯用的还是用文案打动人心。别看小瓶子的包装不如国内大部分白酒看着金贵，段子一出手便知有没有！ ",

    "user_uuid": "cea8b1c3aebe31823fa86e069de496b9",
    "isReply": "1",
    "reply_uuid": "57e9b0a766f89d30f038502b3c1f0435"
}
r = requests.post(url="http://127.0.0.1:5000/service/quickTalk/userPost/addUserPostComment", params=params)    
print(r.text)


if __name__ == '__main__':
    pass
