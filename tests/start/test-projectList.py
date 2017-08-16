#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# test-projectList.py
#
# Created by ruibin.chow on 2017/08/16.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""
f6e996f8-7d83-11e7-889b-8c8590135ddc
000000-7d83-11e7-889b-aaaaaa     f6e996f8-7d83-11e7-889b-222222
000000-7d83-11e7-889b-bbbbbb

"""
import requests

def startProjectList():
    params = {"user_uuid": "f6e996f8-7d83-11e7-889b-8c8590135ddc",
        "index": "1"
    }
    r = requests.post(url="http://127.0.0.1:5000/service/start/project_list", params=params) 
    print r.cookies
    print(r.text)



if __name__ == '__main__':
    startProjectList()
    pass


if __name__ == '__main__':
    pass
