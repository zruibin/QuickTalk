#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# test-likeAction.py
#
# Created by ruibin.chow on 2017/08/23.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""

"""
import requests

def likeProjectAction():
    params = {
        "user_uuid": "f6e996f8-7d83-11e7-889b-8c8590135ddc",
        "type": "1", 
        "action":"1", 
        "liked_uuid":"000000-7d83-11e7-889b-aaaaaa"
    }
    return params

def unLikeProjectAction():
    params = {
        "user_uuid": "f6e996f8-7d83-11e7-889b-8c8590135ddc",
        "type": "1", 
        "action":"0", 
        "liked_uuid":"000000-7d83-11e7-889b-aaaaaa"
    }
    return params

def likeCommentAction():
    params = {
        "user_uuid": "f6e996f8-7d83-11e7-889b-8c8590135ddc",
        "type": "2", 
        "action":"1", 
        "liked_uuid":"3f6823d3b1e29e7ae8a74c0d1178d50e"
    }
    return params

def unLikeCommentAction():
    params = {
        "user_uuid": "f6e996f8-7d83-11e7-889b-8c8590135ddc",
        "type": "2", 
        "action":"0", 
        "liked_uuid":"3f6823d3b1e29e7ae8a74c0d1178d50e"
    }
    return params

def likeJournalAction():
    params = {
        "user_uuid": "f6e996f8-7d83-11e7-889b-8c8590135ddc",
        "type": "3", 
        "action":"1", 
        "liked_uuid":"4c89d716178beb8a39dea789c4de8f58"
    }
    return params

def unLikeJournalAction():
    params = {
        "user_uuid": "f6e996f8-7d83-11e7-889b-8c8590135ddc",
        "type": "3", 
        "action":"0", 
        "liked_uuid":"4c89d716178beb8a39dea789c4de8f58"
    }
    return params


if __name__ == '__main__':
    # params = likeProjectAction()
    # params = unLikeProjectAction()

    # params = likeCommentAction()
    # params = unLikeCommentAction()

    params = likeJournalAction()
    # params = unLikeJournalAction()

    r = requests.post(url="http://127.0.0.1:5000/service/like/like", params=params) 
    print r.cookies
    print(r.text)
    pass
