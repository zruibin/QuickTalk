#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# test-submitCircle.py
#
# Created by ruibin.chow on 2017/11/07.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""

"""
import requests



params = {
    "user_uuid": "cea8b1c3aebe31823fa86e069de496b9",
    "content": "未经我的同意，请不要随便转载或者以其他方式使用这些教程。因为其中的每一句话，除了特别引用的“名句”，都是我自己的，我保留所有的权利。我不希望读者转载的另一大原因在于：转载后的拷贝版本是死的，我就不能再同步更新了。而我经常会按照读者的反馈，对已发表的老文章进行了大面积的修订。"
}
r = requests.post(url="http://127.0.0.1:5000/service/quickTalk/circle/submitCircle", params=params)    
print(r.text)



if __name__ == '__main__':
    pass

