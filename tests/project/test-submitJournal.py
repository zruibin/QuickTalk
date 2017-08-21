#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# test-submitJournal.py
#
# Created by ruibin.chow on 2017/08/21.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""

"""
import requests

def submitJournal():
    data = {"user_uuid": "f6e996f8-7d83-11e7-889b-8c8590135ddc",
        "project_uuid" : "000000-7d83-11e7-889b-bbbbbb",
        "content": "f122222222000000000032"
    }
    files = {'1': open("../pic/aaa.gif", 'rb'), '2': open("../pic/bbb.jpeg", 'rb')}


    r = requests.post(url="http://127.0.0.1:5000/service/project/submit_journal", 
                data=data)#, files=files) 
    print r.cookies
    print(r.text)



if __name__ == '__main__':
    submitJournal()
    pass

