#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# test-modifyProject.py
#
# Created by ruibin.chow on 2017/08/18.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""

"""
import requests
import json

def modifyProject():

    url = "http://127.0.0.1:5000/service/project/modify_project"

    data = {"user_uuid": "f6e996f8-7d83-11e7-889b-222222",
        "nickname": "Ruibin.Chow1111",

        "detail":"gevent.spawn()eeeeeeee",
        "result":"注意，这里与上一篇greenlet中第一个例子运行的结果不一样，greenlet一个协程运行完后，必须显式切换，不然会返回其父协程。而在gevent中，一个协程运行完后，它会自动调度那些未完成的协程。",

        "tagList":["标签101", "标签202", "标签303"],
        "planList":[
            {"startTime":"2017-01-11 12:11:12", "finishTime":"2017-03-15 12:11:44", "content":"基于协程的Python网络库gevent介绍"},
            {"startTime":"2017-04-13 15:11:12", "finishTime":"2017-10-24 17:17:42", "content":"你根本无须像greenlet一样显式的切换，每当一个协程阻塞时，程序将自动调度，gevent处理了所有的底层细节。让我们看个例子来感受下吧。"}
        ],

    }
    
    files = {'1': open("../pic/aaa.gif", 'rb'), '2': open("../pic/bbb.jpeg", 'rb')}

    indent = None
    separators = (',', ':')
    jsonStr = json.dumps(data, indent=indent, separators=separators)
    print jsonStr
    data = {"dataJson": jsonStr, "user_uuid": "f6e996f8-7d83-11e7-889b-222222",
        "project_uuid": "000000-7d83-11e7-889b-bbbbbb"}
    print data

    response = requests.post(url=url, data=data, files=files)    
    print response.text



if __name__ == '__main__':
    modifyProject()
    pass