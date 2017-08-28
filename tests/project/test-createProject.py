#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# test-createProject.py
#
# Created by ruibin.chow on 2017/08/17.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""

"""
import requests
import json

def createProject():

    url = "http://127.0.0.1:5000/service/project/create"

    data = {"user_uuid": "f6e996f8-7d83-11e7-889b-8c8590135ddc",
        "nickname": "Ruibin.Chow",
        "title":"python文件复制移动shutil模块",
        "detail":"shutil.copyfile( src, dst) 从源src复制到dst中去。当然前提是目标地址是具备可写权限。抛出的异常信息为",
        "result":"预期结果",
        "resultMedias":["预期结果多媒体1(多媒体异步提交，名称使用数字标识1.png)", "预期结果多媒体2", "预期结果多媒体3"],
        "tagList":["标签1", "标签2", "标签3"],
        "planList":[
            {"startTime":"2017-03-12 12:11:12", "finishTime":"2017-03-25 12:11:44", "content":"之前讲到几个常用的CALayer的子类"},
            {"startTime":"2017-04-13 15:11:12", "finishTime":"2017-10-24 17:17:42", "content":"那我们今天就从一个比较酷炫的开始"}
        ],
        "memberList":["f6e996f8-7d83-11e7-889b-111111", "f6e996f8-7d83-11e7-889b-333333"]
    }
    
    files = {'1': open("../pic/aaa.gif", 'rb'), '2': open("../pic/bbb.jpeg", 'rb')}

    indent = None
    separators = (',', ':')
    jsonStr = json.dumps(data, indent=indent, separators=separators)
    print jsonStr
    data = {"dataJson": jsonStr, "user_uuid": "f6e996f8-7d83-11e7-889b-8c8590135ddc"}
    print data

    response = requests.post(url=url, data=data, files=files)    
    print response.text



if __name__ == '__main__':
    createProject()
    pass
