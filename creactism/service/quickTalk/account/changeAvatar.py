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

from service.quickTalk.account import account
import os.path
from module.database import DB
from module.log.Log import Loger
from config import *
from common.code import *
from common.tools import getValueFromRequestByKey, fullPathForMediasFile
from common.file import FileTypeException, uploadPicture


@account.route('/changeAvatar', methods=["POST"])
def changeAvatar():
    userUUID = getValueFromRequestByKey("user_uuid")

    result = __uploadAvatar(userUUID)
    if type(result) != dict:
        return result
    else:
        # 存储图片没问题操作后续更新数据库
        response = __updateStorage(userUUID, result.values())
        return response
        

def __uploadAvatar(userUUID):
    saveNameDict = None
    try:
        saveNameDict = uploadPicture(Config.UPLOAD_FILE_FOR_USER, userUUID)
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
        return saveNameDict


def __updateStorage(userUUID, nameList):
    path = Config.FULL_UPLOAD_FOLDER + Config.UPLOAD_FILE_FOR_USER + "/" + userUUID + "/"
    if len(nameList) > 1:
        __removeFileOnError(path, nameList)
        Loger.error(MESSAGE[CODE_ERROR_IMAGE_NUMBER_TOO_MANY], __file__)
        return RESPONSE_JSON(CODE_ERROR_IMAGE_NUMBER_TOO_MANY)

    querySQL = """SELECT avatar FROM t_quickTalk_user WHERE uuid=%s; """
    updateSQL = """UPDATE t_quickTalk_user SET avatar=%s WHERE uuid=%s; """

    dbManager = DB.DBManager.shareInstanced()
    try:
        rows = dbManager.executeSingleQueryWithArgs(querySQL, [userUUID])
        oldName  = rows[0]["avatar"].strip()
        action = dbManager.executeTransactionDmlWithArgs(updateSQL, [nameList[0], userUUID])
        if action and len(oldName) > 0:
            #删除旧的头像文件
            fullPath = path + oldName
            if os.path.exists(fullPath): os.remove(fullPath)
        fullPathAvatar = fullPathForMediasFile(Config.UPLOAD_FILE_FOR_USER, userUUID, nameList[0])
        return RESPONSE_JSON(CODE_SUCCESS, data={"avatar":fullPathAvatar})
    except Exception as e:
        Loger.error(e, __file__)
        return RESPONSE_JSON(CODE_ERROR_SERVICE)
    

def __removeFileOnError(path, fileList):
    for fileName in fileList:
        fullPath = path + fileName
        os.remove(fullPath)


if __name__ == '__main__':
    pass
