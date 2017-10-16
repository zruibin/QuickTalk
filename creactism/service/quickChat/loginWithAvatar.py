#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# loginWithAvatar.py
#
# Created by ruibin.chow on 2017/10/12.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""
登录
"""

from service.quickChat import quickChat
from module.database import DB
from module.log.Log import Loger
from config import *
from common.code import *
from common.tools import getValueFromRequestByKey, generateUUID, generateCurrentTime, fullPathForMediasFile
from common.file import FileTypeException, uploadPicture


@quickChat.route('/loginWithAvatar', methods=["GET", "POST"])
def loginWithAvatar():
    openId = getValueFromRequestByKey("openId")
    typeStr = getValueFromRequestByKey("type")

    if openId == None or typeStr == None:
        return RESPONSE_JSON(CODE_ERROR_MISS_PARAM)

    return __loginAction(openId, typeStr)


def __loginAction(openId, typeStr):
    typeData = __typeData(typeStr)
    
    querySQL = """
        SELECT uuid, avatar FROM t_quickChat_user WHERE %s=%s; 
    """ % (typeData, openId)
       
    dbManager = DB.DBManager.shareInstanced()
    try: 
        result = dbManager.executeSingleQuery(querySQL)
        if len(result) > 0:
            data = result[0]
            data["avatar"] = fullPathForMediasFile(Config.UPLOAD_FILE_FOR_USER, data["uuid"], data["avatar"])
            return RESPONSE_JSON(CODE_SUCCESS, data)
        else:
            return __registerUser(openId, typeStr)
    except Exception as e:
        Loger.error(e, __file__)
        return RESPONSE_JSON(CODE_ERROR_SERVICE)


def __registerUser(openId, typeStr):
    uuid = generateUUID()
    result = __uploadAvatar(uuid)
    if type(result) != dict:
        return result
    else:
        # 存储图片没问题操作后续更新数据库
        response = __registerUserInStorage(uuid, openId, typeStr, result.values())
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


def __registerUserInStorage(userUUID, openId, typeStr, nameList):
    time = generateCurrentTime()
    path = Config.FULL_UPLOAD_FOLDER + Config.UPLOAD_FILE_FOR_USER + "/" + userUUID + "/"
    if len(nameList) > 1:
        __removeFileOnError(path, nameList)
        Loger.error(MESSAGE[CODE_ERROR_IMAGE_NUMBER_TOO_MANY], __file__)
        return RESPONSE_JSON(CODE_ERROR_IMAGE_NUMBER_TOO_MANY)

    typeData = __typeData(typeStr)

    insertSQL = """
        INSERT INTO t_quickChat_user (uuid, avatar, time, %s) VALUES ('%s', '%s', '%s', '%s')
    """ % (typeData, userUUID, nameList[0], time, openId)

    dbManager = DB.DBManager.shareInstanced()
    try:
        result = dbManager.executeTransactionDml(insertSQL)
        if result:
            data = {}
            data["uuid"] = userUUID
            fullPathAvatar = fullPathForMediasFile(Config.UPLOAD_FILE_FOR_USER, userUUID, nameList[0])
            data["avatar"] = fullPathAvatar
            return RESPONSE_JSON(CODE_SUCCESS, data)
        else:
            return RESPONSE_JSON(CODE_ERROR_SERVICE)
    except Exception as e:
        Loger.error(e, __file__)
        return RESPONSE_JSON(CODE_ERROR_SERVICE)
    

def __typeData(typeStr):
    typeDict = {
        Config.TYPE_FOR_AUTH_WECHAT : "wechat",
        Config.TYPE_FOR_AUTH_QQ : "qq",
        Config.TYPE_FOR_AUTH_WEIBO : "weibo",
    }
    return typeDict[typeStr]


def __removeFileOnError(path, fileList):
    for fileName in fileList:
        fullPath = path + fileName
        os.remove(fullPath)


if __name__ == '__main__':
    pass
