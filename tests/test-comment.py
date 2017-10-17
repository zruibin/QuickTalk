#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# test-comment.py
#
# Created by ruibin.chow on 2017/10/12.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""

"""
import requests

params = {
    "topic_uuid":"dc506162825620e0517426001fce8615",
    "content": "An architectural pattern is a general, reusable solution to a commonly occurring problem in software architecture within a given context. Architectural patterns are similar to software design pattern but have a broader scope. The architectural patterns address various issues in software engineering, such as computer hardware performance limitations, high availability and minimization of a business risk. Some architectural patterns have been implemented within software frameworks."
}
r = requests.post(url="http://127.0.0.1:5000/service/quickTalk/comment", params=params)    
print(r.text)



if __name__ == '__main__':
    pass
