#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# file.py
#
# Created by ruibin.chow on 2017/08/07.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""
上传文件处理
"""

import os, os.path, sys, stat
from flask import request, abort
from werkzeug import secure_filename
from werkzeug.exceptions import RequestEntityTooLarge
from config import Config
from module.log.Log import Loger
from common.tools import jsonTool, generateFileName
from common.code import *
import shutil


class FileTypeException(Exception):  
    def __init__(self, err='File Type Not Support!'):  
        Exception.__init__(self,err)  


def allowedFileSuffix(filename):
    """上传文件允许的后缀格式"""
    return '.' in filename and \
    filename.rsplit('.', 1)[1] in Config.ALLOWED_EXTENSIONS


def removeAllUploadFile(fieType, uuid):
    path = Config.FULL_UPLOAD_FOLDER + fieType + "/" + uuid + "/"
    fileList = request.files.lists()
    for uploadFile in fileList:
        key = uploadFile[0]
        files = request.files.getlist(key)
        for file in files:
            if file and allowedFileSuffix(file.filename):
                filename = secure_filename(file.filename)
                fullPath = os.path.join(path, filename)
                if os.path.exists(fullPath):
                    os.remove(fullPath)
    pass


def uploadPicture(fieType, uuid):
    """上传图片(单张或多张)，方式利用表单form的file方式"""
    saveNameDict = {}
    tempPath = Config.FULL_UPLOAD_FOLDER_TEMP + fieType + "/" + uuid + "/"
    path = Config.FULL_UPLOAD_FOLDER + fieType + "/" + uuid + "/"
    try:
        # 取得表单所有file字段
        fileList = request.files.lists()
        for uploadFile in fileList:
            key = uploadFile[0]
            # 文件name可以自定义
            file = request.files.getlist(key)[0]
            if file and allowedFileSuffix(file.filename):
                # 以流的方式读取
                blob = file.read()
                size = len(blob)
                if size > Config.MAX_CONTENT_LENGTH_VERIFY:
                    raise RequestEntityTooLarge()
                
                # 该文件保存的临时目录不存在则创建该目录
                if not os.path.exists(tempPath): os.makedirs(tempPath)

                filename = secure_filename(file.filename)
                suffix = filename.rsplit('.', 1)[1]

                #文件名生产规则
                filename = str(generateFileName()) + "." + suffix

                fullPath = os.path.join(tempPath, filename)
                # 保存文件
                with open(fullPath, 'a' ) as fileHandle:
                    fileHandle.write(blob)
                file.close()
                saveNameDict[key] = filename
            else:
                raise FileTypeException()
    except FileTypeException as e:
        Loger.error(e, __file__)
        raise e
    except FileTypeException as e:
        Loger.error(e, __file__)
        removeAllUploadFile(fieType, uuid)
        raise e
    except Exception as e:
        Loger.error(e, __file__)
        removeAllUploadFile(fieType, uuid)
        raise e
    else:
        # 真实目录不存在则创建
        if not os.path.exists(path): os.makedirs(path)
        # 从临时目录移动到真实目录
        for filename in saveNameDict.values():
            fullPath = os.path.join(path, filename)
            tempFullPath = os.path.join(tempPath, filename)
            shutil.move(tempFullPath, fullPath)      

        return saveNameDict







if __name__ == '__main__':
    pass
