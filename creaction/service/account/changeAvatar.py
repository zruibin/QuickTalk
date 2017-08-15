#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# changeAvatar.py
#
# Created by ruibin.chow on 2017/08/11.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""
修改头像
"""
from service.account import account
from flask import Flask, Response, request
import json, os.path
from module.database import DB
from module.log.Log import Loger
from config import *
from common.code import *
from common.auth import vertifyTokenHandle
from common.tools import getValueFromRequestByKey
from common.file import FileTypeException, uploadPicture
from common.verifyMethods import verifyUserIsExists


@account.route('/change_avatar', methods=["POST"])
@vertifyTokenHandle
def changeAvatar():
    userUUID = getValueFromRequestByKey("user_uuid")

    # 验证用户是否存在
    # result = verifyUserIsExists(userUUID) # 没问题则返回文件名列表
    # if not result:  return RESPONSE_JSON(CODE_ERROR_USER_NOT_EXISTS)

    result = uploadAvatar(userUUID)
    if type(result) != list:
        return result
    else:
        # 存储图片没问题操作后续更新数据库
        response = updateStorage(userUUID, result)
        return response
        

def uploadAvatar(userUUID):
    saveNameList = None
    try:
        saveNameList = uploadPicture(Config.UPLOAD_FILE_FOR_USER, userUUID)
    except FileTypeException as e:
        Loger.error(e, __file__)
        return RESPONSE_JSON(CODE_ERROR_IMAGE_UNSUPPORTED_TYPE)
    except FileTypeException as e:
        Loger.error(e, __file__)
        return RESPONSE_JSON(CODE_ERROR_IMAGE_TOO_LARGE)
    except Exception as e:
        Loger.error(e, __file__)
        return RESPONSE_JSON(CODE_ERROR_IMAGE_SERVICE_ERROR)
    else:
        return saveNameList


def updateStorage(userUUID, nameList):
    path = Config.FULL_UPLOAD_FOLDER + Config.UPLOAD_FILE_FOR_USER + "/" + userUUID + "/"
    if len(nameList) > 1:
        removeFileOnError(path, nameList)
        Loger.error(MESSAGE[CODE_ERROR_IMAGE_NUMBER_TOO_MANY], __file__)
        return RESPONSE_JSON(CODE_ERROR_IMAGE_NUMBER_TOO_MANY)

    querySQL = """SELECT avatar FROM t_user WHERE uuid='%s'; """ % userUUID
    updateSQL = """UPDATE t_user SET avatar='%s' WHERE uuid='%s'; """ % (nameList[0], userUUID)

    dbManager = DB.DBManager.shareInstanced()
    try:
        rows = dbManager.executeSingleQuery(querySQL)
        oldName  = rows[0]["avatar"]
        action = dbManager.executeTransactionDml(updateSQL)
        if action and len(oldName) > 0:
            #删除旧的头像文件
            fullPath = path + oldName
            if os.path.exists(fullPath): os.remove(fullPath)
    except Exception as e:
        Loger.error(e, __file__)
        return RESPONSE_JSON(CODE_ERROR_SERVICE)
    else:
        return RESPONSE_JSON(CODE_SUCCESS)
    

def removeFileOnError(path, fileList):
    for fileName in fileList:
        fullPath = path + fileName
        os.remove(fullPath)


if __name__ == '__main__':
    pass
