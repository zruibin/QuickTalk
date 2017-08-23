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
    data = {"user_uuid": "f6e996f8-7d83-11e7-889b-222222",
        "project_uuid" : "000000-7d83-11e7-889b-bbbbbb",
        "content": "对于 View 来说，你如果抽象得好，那么一个 App 的动画效果可以很方便地移植到别的 App 上，而 Github 上也有很多 UI 控件，这些控件都是在 View 层做了很好的封装设计，使得它能够方便地开源给大家复用。"
    }
    files = {'1': open("../pic/aaa.gif", 'rb'), '2': open("../pic/bbb.jpeg", 'rb')}


    r = requests.post(url="http://127.0.0.1:5000/service/project/submit_journal", 
                data=data)#, files=files) 
    print r.cookies
    print(r.text)



if __name__ == '__main__':
    submitJournal()
    pass

