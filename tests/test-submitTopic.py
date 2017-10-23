#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# test-submitTopic.py
#
# Created by ruibin.chow on 2017/10/11.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""

"""

import requests

jsondata = """
[
    {
        "title": "回退栈的内部实现、Fragment通信",
        "detail": "导语 Fragment作为Android最基本，最重要的基础概念之一，在开发中经常会和他打交道。本文从为什么出现Fragment开始，介绍了Fragment相关的方方面面，包括Fragment的基本定义及使用、回退栈的内部实现、Fragment通信、DialogFragment、ViewPager+Fragment的使用、嵌套Fragment、懒加载等。",
        "href": "http://www.baidu.com"
    },

    {
        "title": "222222",
        "detail": "bbbbbbbbbbbbbbb",
        "href": "http://www.163.com"
    }
]
"""

params = {"jsondata":jsondata}
r = requests.post(url="http://127.0.0.1:5000/service/quickTalk/submitTopic", params=params)    
print(r.text)



if __name__ == '__main__':
    pass

