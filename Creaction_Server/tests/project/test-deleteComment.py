#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# test-deleteComment.py
#
# Created by ruibin.chow on 2017/08/19.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""

"""
import requests

def deleteComment():
    params = {"comment_uuid": "746c7c68-84a7-11e7-8492-8c8590135ddc", 
        "project_uuid": "000000-7d83-11e7-889b-aaaaaa", 
        "user_uuid": "f6e996f8-7d83-11e7-889b-22222"
    }
    r = requests.post(url="http://127.0.0.1:5000/service/project/delete_comment", params=params) 
    print r.cookies
    print(r.text)



if __name__ == '__main__':
    deleteComment()
    pass
