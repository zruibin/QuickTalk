#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# test-submitTopic.py
#
# Created by ruibin.chow on 2017/10/11.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""

"""

import requests


params = {"uuid":"3d24c4e70a35b0c64545197114dfc0fa"}
r = requests.post(url="http://127.0.0.1:5000/service/quickSay/deleteTopic", params=params)    
print(r.text)



if __name__ == '__main__':
    pass

