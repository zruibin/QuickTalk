#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# test-changeInfoDetail.py
#
# Created by ruibin.chow on 2017/08/11.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""

"""
import requests


detail ="Lottie 是 Airbnb 开源的一个动画渲染库，同时支持 Android、iOS、React Native 平台。Lottie 目前只支持渲染播放 After Effects 动画。 Lottie 使用从 bodymovin (开源的 After Effects 插件)导出的json数据来作为动画数据。所以从动画制作到动画使用的整个工作流程如下"

params = {"user_uuid": "3f05136c7c04def451b764c88fbcb72c", "detail":detail}
r = requests.post(url="http://127.0.0.1:5000/service/account/change_info_detail", params=params)    

print r.cookies
print(r.text)



if __name__ == '__main__':
    pass
