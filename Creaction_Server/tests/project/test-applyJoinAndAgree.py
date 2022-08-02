#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# test-applyJoinAndAgree.py
#
# Created by ruibin.chow on 2017/08/22.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""

"""
import requests

def applyJoinProject():
    params = {
        "project_uuid": "000000-7d83-11e7-889b-cccccc", 
        "author_uuid": "f6e996f8-7d83-11e7-889b-8c8590135ddc",
        "type":"4",
        "user_uuid": "e0596682-80dc-11e7-aedb-8c8590135ddc"
    }
    r = requests.post(url="http://127.0.0.1:5000/service/project/apply_join_and_agree", params=params) 
    print r.cookies
    print(r.text)


def agreeJoinIntoProject():
    params = {
        "project_uuid": "000000-7d83-11e7-889b-cccccc", 
        "author_uuid": "f6e996f8-7d83-11e7-889b-8c8590135ddc",
        "type":"8",
        "user_uuid": "e0596682-80dc-11e7-aedb-8c8590135ddc"
    }
    r = requests.post(url="http://127.0.0.1:5000/service/project/apply_join_and_agree", params=params) 
    print r.cookies
    print(r.text)



if __name__ == '__main__':
    agreeJoinIntoProject()
    pass

