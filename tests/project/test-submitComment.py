#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# test-submitComment.py
#
# Created by ruibin.chow on 2017/08/18.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""

"""
import requests

def changeProjectStatus():
    params = {"user_uuid": "f6e996f8-7d83-11e7-889b-222222",
        "project_uuid" : "000000-7d83-11e7-889b-aaaaaa",
        "is_reply": "0", "content": "19999999999999999",
        "reply_comment_uuid":""
    }

    replyParams = {"user_uuid": "f6e996f8-7d83-11e7-889b-111111",
        "project_uuid" : "000000-7d83-11e7-889b-bbbbbb",
        "is_reply": "1", "content": "qqqeqeqqeqwsdfdsfsf",
        "reply_comment_uuid" : "746c7c68-84a7-11e7-8492-8c8590135ddc"
    }
    r = requests.post(url="http://127.0.0.1:5000/service/project/submit_comment", params=replyParams) 
    print r.cookies
    print(r.text)



if __name__ == '__main__':
    changeProjectStatus()
    pass
