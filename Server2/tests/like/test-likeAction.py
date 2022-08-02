#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# test-likeAction.py
#
# Created by ruibin.chow on 2017/12/05.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""

    LIKE_ACTION_AGREE = "1"
    LIKE_ACTION_DISAGREE = "2"

    TYPE_MESSAGE_LIKE_TOPIC = "0"
    TYPE_MESSAGE_LIKE_TOPIC_COMMENT = "1"
    TYPE_MESSAGE_LIKE_USERPOST = "2"
    TYPE_MESSAGE_LIKE_USERPOST_COMMENT = "3"
"""


import requests

def likeTopic():
    params = {
        "type":"0",
        "user_uuid": "cea8b1c3aebe31823fa86e069de496b9",
        "content_uuid": "6c104333d4d50a5dd3df1d2dae03e30b",
        "action": "1"
    }
    r = requests.post(url="http://127.0.0.1:5000/service/quickTalk/like/like", params=params)    
    print(r.text)
    

def disLikeTopic():
    params = {
        "type":"0",
        "user_uuid": "cea8b1c3aebe31823fa86e069de496b9",
        "content_uuid": "6c104333d4d50a5dd3df1d2dae03e30b",
        "action": "2"
    }
    r = requests.post(url="http://127.0.0.1:5000/service/quickTalk/like/like", params=params)    
    print(r.text)



def likeTopicComment():
    params = {
        "type":"1",
        "user_uuid": "cea8b1c3aebe31823fa86e069de496b9",
        "content_uuid": "9416e8da98f9080849b1b6de054138a2",
        "action": "1"
    }
    r = requests.post(url="http://127.0.0.1:5000/service/quickTalk/like/like", params=params)    
    print(r.text)
    

def disLikeTopicComment():
    params = {
        "type":"1",
        "user_uuid": "cea8b1c3aebe31823fa86e069de496b9",
        "content_uuid": "9416e8da98f9080849b1b6de054138a2",
        "action": "2"
    }
    r = requests.post(url="http://127.0.0.1:5000/service/quickTalk/like/like", params=params)    
    print(r.text)


def likeUserPost():
    params = {
        "type":"2",
        "user_uuid": "fbd1d63882ff73751accacd39621fa9c",
        "content_uuid": "6e5a1c1668abb448407de389a8792bf0",
        "action": "1"
    }
    r = requests.post(url="http://127.0.0.1:5000/service/quickTalk/like/like", params=params)    
    print(r.text)
    

def disLikeUserPost():
    params = {
        "type":"2",
        "user_uuid": "fbd1d63882ff73751accacd39621fa9c",
        "content_uuid": "6e5a1c1668abb448407de389a8792bf0",
        "action": "2"
    }
    r = requests.post(url="http://127.0.0.1:5000/service/quickTalk/like/like", params=params)    
    print(r.text)


def likeUserPostComment():
    params = {
        "type":"3",
        "user_uuid": "cea8b1c3aebe31823fa86e069de496b9",
        "content_uuid": "10c82a7039a629d184b448a783d76ea9",
        "action": "1"
    }
    r = requests.post(url="http://127.0.0.1:5000/service/quickTalk/like/like", params=params)    
    print(r.text)
    

def disLikeUserPostComment():
    params = {
        "type":"3",
        "user_uuid": "cea8b1c3aebe31823fa86e069de496b9",
        "content_uuid": "10c82a7039a629d184b448a783d76ea9",
        "action": "2"
    }
    r = requests.post(url="http://127.0.0.1:5000/service/quickTalk/like/like", params=params)    
    print(r.text)




if __name__ == '__main__':
    # likeTopic()
    # disLikeTopic()
    
    # likeTopicComment()
    # disLikeTopicComment()

    # likeUserPost()
    disLikeUserPost()

    # likeUserPostComment()
    # disLikeUserPostComment()
    pass

