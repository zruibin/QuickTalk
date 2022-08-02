#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# test-inviteAndAgreeJoinProject.py
#
# Created by ruibin.chow on 2017/08/21.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""

"""
import requests

def invitePeopleIntoProject():
    params = {"project_uuid": "000000-7d83-11e7-889b-bbbbbb", 
        "type":"3",
        "user_uuid": "f6e996f8-7d83-11e7-889b-8c8590135ddc",
        "member_uuid": "f6e996f8-7d83-11e7-889b-111111"
    }
    r = requests.post(url="http://127.0.0.1:5000/service/project/project_invite_and_agree", params=params) 
    print r.cookies
    print(r.text)


def agreeIntoProject():
    params = {"project_uuid": "000000-7d83-11e7-889b-bbbbbb", 
        "type":"7",
        "user_uuid": "f6e996f8-7d83-11e7-889b-111111"
    }
    r = requests.post(url="http://127.0.0.1:5000/service/project/project_invite_and_agree", params=params) 
    print r.cookies
    print(r.text)



if __name__ == '__main__':
    agreeIntoProject()
    pass
