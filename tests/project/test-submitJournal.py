#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# test-submitJournal.py
#
# Created by ruibin.chow on 2017/08/21.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""

"""
import requests

def submitJournal():
    data = {"user_uuid": "f6e996f8-7d83-11e7-889b-111111",
        "project_uuid" : "000000-7d83-11e7-889b-bbbbbb",
        "content": "但是，几十年过去了，我们对于 MVC 这种设计模式真的用得好吗？其实不是的，MVC 这种分层方式虽然清楚，但是如果使用不当，很可能让大量代码都集中在 Controller 之中，让 MVC 模式变成了 Massive View Controller 模式。"
    }
    files = {'1': open("../pic/aaa.gif", 'rb'), '2': open("../pic/bbb.jpeg", 'rb')}


    r = requests.post(url="http://127.0.0.1:5000/service/project/submit_journal", 
                data=data)#, files=files) 
    print r.cookies
    print(r.text)



if __name__ == '__main__':
    submitJournal()
    pass

