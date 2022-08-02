#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# test-startAction.py
#
# Created by ruibin.chow on 2017/08/15.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""
000000-7d83-11e7-889b-aaaaaa       f6e996f8-7d83-11e7-889b-222222
f6e996f8-7d83-11e7-889b-8c8590135ddc
"""
import requests

def startProjectAction():
    params = {"user_uuid": "f6e996f8-7d83-11e7-889b-8c8590135ddc",
        "type": "1", "action":"1", "other_uuid":"000000-7d83-11e7-889b-aaaaaa"
    }
    r = requests.post(url="http://127.0.0.1:5000/service/star/star_action", params=params) 
    print r.cookies
    print(r.text)

def unStartProjectAction():
    params = {"user_uuid": "f6e996f8-7d83-11e7-889b-8c8590135ddc",
        "type": "1", "action":"2", "other_uuid":"000000-7d83-11e7-889b-aaaaaa"
    }
    r = requests.post(url="http://127.0.0.1:5000/service/start/start_action", params=params) 
    print r.cookies
    print(r.text)

def startUserAction():
    params = {"user_uuid": "f6e996f8-7d83-11e7-889b-8c8590135ddc",
        "type": "2", "action":"1", "other_uuid":"f6e996f8-7d83-11e7-889b-222222",
        "nickname": "Ruibin.Chow"
    }
    r = requests.post(url="http://127.0.0.1:5000/service/start/start_action", params=params) 
    print r.cookies
    print(r.text)

def unStartUserAction():
    params = {"user_uuid": "f6e996f8-7d83-11e7-889b-8c8590135ddc",
        "type": "2", "action":"2", "other_uuid":"f6e996f8-7d83-11e7-889b-000000",
        "nickname": "Ruibin.Chow"
    }
    r = requests.post(url="http://127.0.0.1:5000/service/start/start_action", params=params) 
    print r.cookies
    print(r.text)


if __name__ == '__main__':
    # startProjectAction()
    # unStartProjectAction()
    startUserAction()
    # unStartUserAction()
    pass

