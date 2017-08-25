#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# logContent.py
#
# Created by ruibin.chow on 2017/08/25.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""
查询日志文件
"""

from service.admin import admin
from config import *
from common.code import *
import os
from common.tools import getValueFromRequestByKey


@admin.route("/log", methods=["GET", "POST"])
def logContent():           
    file = getValueFromRequestByKey("file")
    cleanFile = getValueFromRequestByKey("clean")

    path = Config.LOG_DIR + "/"

    if cleanFile != None:
        return __cleanFile(path + cleanFile)

    try: 
        if file == None:
            fileList = __getAllFileInDir(Config.LOG_DIR)
            return RESPONSE_JSON(CODE_SUCCESS, fileList)
        else:
            fileContentList = __readFile(path + file)

            if "\n" in fileContentList:
                fileContentList.remove("\n")
            
            # 倒序
            fileContentList = list(reversed(fileContentList)) 
            return RESPONSE_JSON(CODE_SUCCESS, fileContentList)
    except Exception as e:
        print e
        return RESPONSE_JSON(CODE_ERROR_SERVICE)
        

def __getAllFileInDir(DIR):
    """返回指定目录下所有文件的集合"""
    array = __getAllFileInDirBeyoundTheDir(DIR, '')
    return array

    
def __getAllFileInDirBeyoundTheDir(DIR, beyoundDir):
    """返回指定目录下所有文件的集合，beyoundDir的目录不包含"""
    array = []
    # print DIR+beyoundDir
    for root, dirs, files in os.walk(DIR):
        if len(beyoundDir) != 0 and os.path.exists(DIR+beyoundDir):
            if beyoundDir not in dirs:
                continue
        for name in files:
            path = os.path.join(root,name)
            basename = os.path.basename(path)
            # array.append(path)
            array.append(basename)
    return array


def __readFile(filePath):
    fileContentList = []
    with open(filePath) as file:
        while 1:
            lines = file.readlines(100000)
            if not lines:
                break
            for line in lines:
                fileContentList.append(line)
    return fileContentList


def __cleanFile(cleanFile):
    try: 
        with open(cleanFile, "w+") as file:
            file.truncate()#清空文件内容
        return RESPONSE_JSON(CODE_SUCCESS)
    except Exception as e:
        print e
        return RESPONSE_JSON(CODE_ERROR_SERVICE)



if __name__ == '__main__':
    pass
