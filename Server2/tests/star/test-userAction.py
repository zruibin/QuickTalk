#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# test-userAction.py
#
# Created by ruibin.chow on 2017/12/05.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""
  # 关注与取消关注
  STAR_ACTION_ON = "1"
  STAR_ACTION_OFF = "2"

  # 关注类型
  TYPE_STAR_FOR_USER_RELATION = "0"
"""


import requests

def starUser():
    params = {
        "type":"0",
        "user_uuid": "cea8b1c3aebe31823fa86e069de496b9",
        "content_uuid": "22908c712545dca68ae6a09383f47bc3",
        "action": "1"
    }
    r = requests.post(url="http://127.0.0.1:5000/service/quickTalk/star/userAction", params=params)    
    print(r.text)
    

def unStarUser():
    params = {
        "type":"0",
        "user_uuid": "cea8b1c3aebe31823fa86e069de496b9",
        "content_uuid": "22908c712545dca68ae6a09383f47bc3",
        "action": "2"
    }
    r = requests.post(url="http://127.0.0.1:5000/service/quickTalk/star/userAction", params=params)    
    print(r.text)




if __name__ == '__main__':
    starUser()
    # unStarUser()
    pass

