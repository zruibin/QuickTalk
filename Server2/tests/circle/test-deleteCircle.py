#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# test-deleteCircle.py
#
# Created by ruibin.chow on 2017/11/07.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""

"""
import requests


params = {"uuid":"9ab440cae358bcea1e9bb17cfb86487e"}
r = requests.post(url="http://127.0.0.1:5000/service/quickTalk/circle/deleteCircle", params=params)    
print(r.text)



if __name__ == '__main__':
    pass
