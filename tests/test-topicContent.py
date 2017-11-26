#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# test-topicContent.py
#
# Created by ruibin.chow on 2017/11/26.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""

"""

import requests

params = {
    "topic_uuid":"aef0a0b100222b265b814b7865136be3"
}
r = requests.post(url="http://127.0.0.1:5000/service/quickTalk/topicContent", params=params)    
print(r.text)


if __name__ == '__main__':
    pass
