#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# test-addAndDeleteAnnounce.py
#
# Created by ruibin.chow on 2017/08/22.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""

"""
import requests

def addAnounce():
    params = {"project_uuid": "000000-7d83-11e7-889b-bbbbbb", 
        "action":"1",
        "user_uuid": "f6e996f8-7d83-11e7-889b-222222",
        "content": "MVC 已经成为主流的客户端编程框架，在 iOS 开发中，系统为我们实现好了公共的视图类：UIView，和控制器类：UIViewController。大多数时候，我们都需要继承这些类来实现我们的程序逻辑，因此，我们几乎逃避不开 MVC 这种设计模式。"
    }
    r = requests.post(url="http://127.0.0.1:5000/service/project/add_and_delete_announce", params=params) 
    print r.cookies
    print(r.text)


def deleteAnnounce():
    params = {"project_uuid": "000000-7d83-11e7-889b-bbbbbb", 
        "action":"2",
        "user_uuid": "f6e996f8-7d83-11e7-889b-222222",
        "uuid":"ae90b66df0fde2a1e4536e12b085a75c"
    }
    r = requests.post(url="http://127.0.0.1:5000/service/project/add_and_delete_announce", params=params) 
    print r.cookies
    print(r.text)



if __name__ == '__main__':
    addAnounce()
    pass
