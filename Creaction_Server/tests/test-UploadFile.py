#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# test-UploadFile.py
#
# Created by ruibin.chow on 2017/08/07.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""

"""

import requests

files = {'file1': open("aaa.mp4", 'rb')}
url = "http://127.0.0.1:5000/upload"
response = requests.post(url, files=files)

print response.text


if __name__ == '__main__':
    pass
