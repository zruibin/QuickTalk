#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# file.py
#
# Created by ruibin.chow on 2017/08/07.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""

"""

import os, os.path
from flask import request, abort
from werkzeug import secure_filename
from werkzeug.exceptions import RequestEntityTooLarge
from config import Config
from module.log.Log import Loger
from common.jsonUtil import jsonTool
from common.code import *

def allowed_file(filename):
      return '.' in filename and \
      filename.rsplit('.', 1)[1] in Config.ALLOWED_EXTENSIONS

def uploadFile(type, uuid):
    try:
        path = Config.FULL_UPLOAD_FOLDER + type + "/" + uuid + "/"
        fileList = request.files.lists()
        for uploadFile in fileList:
            key = uploadFile[0]
            files = request.files.getlist(key)

            for file in files:
                if file and allowed_file(file.filename):
                    # with file.read() as blob:
                    blob = file.read()
                    size = len(blob)
                    if size > Config.MAX_CONTENT_LENGTH_VERIFY:
                        print "too large..."
                        raise RequestEntityTooLarge()

                    filename = secure_filename(file.filename)
                    if not os.path.exists(path): os.makedirs(path)
                    fullPath = os.path.join(path, filename)
                    # file.save(fullPath)
                    with open(fullPath, 'a' ) as fileHandle:
                        fileHandle.write(blob)
                    file.close()
    except RequestEntityTooLarge as e:
        Loger.error(e, __file__)
        removeAllUploadFile(type, uuid)
        return PACKAGE_CODE(CODE_ERROR_IMAGE_TOO_LARGE, MESSAGE[CODE_ERROR_IMAGE_TOO_LARGE])
    except Exception as e:
        Loger.error(e, __file__)
        removeAllUploadFile(type, uuid)
        return PACKAGE_CODE(CODE_ERROR_IMAGE_SERVICE_ERROR, MESSAGE[CODE_ERROR_IMAGE_SERVICE_ERROR])
    else:
        return PACKAGE_CODE(CODE_SUCCESS, MESSAGE[CODE_SUCCESS])


def removeAllUploadFile(type, uuid):
    path = Config.FULL_UPLOAD_FOLDER + type + "/" + uuid + "/"
    fileList = request.files.lists()
    for uploadFile in fileList:
        key = uploadFile[0]
        files = request.files.getlist(key)
        for file in files:
            if file and allowed_file(file.filename):
                filename = secure_filename(file.filename)
                fullPath = os.path.join(path, filename)
                if os.path.exists(fullPath):
                    os.remove(fullPath)
    pass





if __name__ == '__main__':
    pass
