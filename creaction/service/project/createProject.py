#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# createProject.py
#
# Created by ruibin.chow on 2017/08/17.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""
提交创建的项目
"""
from service.project import project
from flask import Flask, Response, request
from module.database import DB
from module.log.Log import Loger
from config import *
from common.code import *
from common.auth import vertifyTokenHandle
from common.tools import getValueFromRequestByKey, generateUUID
from common.file import FileTypeException, uploadPicture
import json, os
import common.notification as notification


@project.route('/create', methods=["GET", "POST"])
@vertifyTokenHandle
def createProject():
    userUUID = getValueFromRequestByKey("user_uuid")
    dataJson = getValueFromRequestByKey("dataJson")

    if dataJson == None: return RESPONSE_JSON(CODE_ERROR_SERVICE)

    dataJsonDict = None
    try:
        dataJsonDict = json.loads(dataJson)
    except Exception as e:
        Loger.error(e, __file__)
        return RESPONSE_JSON(CODE_ERROR_ILLEGAL_CREATE_PROJECT_JSON_CONTENT)

    projectUUID = generateUUID()

    mediasDict = uploadMedias(projectUUID)
    if type(mediasDict) != dict:
        return mediasDict
    else:
        # 存储图片没问题操作后续更新数据库
        response = insertProjectStorage(userUUID, projectUUID, dataJsonDict, mediasDict)
        return response


def uploadMedias(projectUUID):
    saveNameDict = None
    try:
        saveNameDict = uploadPicture(Config.UPLOAD_FILE_FOR_PROJECT, projectUUID)
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


def insertProjectStorage(userUUID, projectUUID, dataJsonDict, mediasDict):
    path = Config.FULL_UPLOAD_FOLDER + Config.UPLOAD_FILE_FOR_PROJECT + "/" + projectUUID + "/"
    if len(mediasDict) > 9:
        removeFileOnError(path, mediasDict.values())
        Loger.error(MESSAGE[CODE_ERROR_IMAGE_NUMBER_TOO_MANY], __file__)
        return RESPONSE_JSON(CODE_ERROR_IMAGE_NUMBER_TOO_MANY)
    
    sqlList = packageSQL(userUUID, projectUUID, dataJsonDict, mediasDict)

    dbManager = DB.DBManager.shareInstanced()
    try:
        dbManager.executeTransactionMutltiDml(sqlList)
    except Exception as e:
        Loger.error(e, __file__)
        removeFileOnError(path, mediasDict.values())
        return RESPONSE_JSON(CODE_ERROR_SERVICE)
    else:
        notificationMember(dataJsonDict)
        return RESPONSE_JSON(CODE_SUCCESS)
    

def packageSQL(userUUID, projectUUID, dataJsonDict, mediasDict):
    sqlList = []

    # 项目多媒体内容
    medias_count = len(mediasDict)
    if medias_count > 0:
        insertMediasSQL = """INSERT INTO t_project_media (project_uuid, sorting, type, media_name) VALUES """
        values = ""
        typeInt = Config.TYPE_FOR_PROJECT_MEDIAS_PICTURE
        for key, value in mediasDict.items():
            values += """('%s', %s, %d, '%s'),""" % (projectUUID, key, typeInt, value)
        insertMediasSQL += values[:-1] + ";"
        sqlList.append(insertMediasSQL)
    
    # 项目计划列表
    have_plan = 0
    planList = dataJsonDict["planList"]
    planListLen = len(planList)
    if planListLen > 0 :
        have_plan = 1
        insertPlanSQL = """INSERT INTO t_project_plan (project_uuid, sorting, content, start_time, finish_time, medias_count) VALUES """
        values = ""
        for x in range(planListLen):
            data = planList[x]
            content = data["content"]
            startTime = data["startTime"]
            finishTime = data["finishTime"]
            values += """('%s', %d, '%s', '%s', '%s', 0),""" % (projectUUID, x, content, startTime, finishTime)
        insertPlanSQL += values[:-1] + ";"
        sqlList.append(insertPlanSQL)

    # 项目标签列表
    tagList = dataJsonDict["tagList"]
    tagListLen = len(tagList)
    if tagListLen > 0 :
        insertTagSQL = """INSERT INTO t_tag_project (project_uuid, sorting, type, content) VALUES """
        values = ""
        for i in range(tagListLen):
            values += """('%s', %d, %d, '%s'),""" % (projectUUID, i, i, tagList[i])
        insertTagSQL += values[:-1] + ";"
        sqlList.append(insertTagSQL)

    # 项目邀请成员 消息
    memberList = dataJsonDict["memberList"]
    memberListLen = len(memberList)
    if memberListLen > 0:
        insertMessageProjectSQL = """INSERT INTO t_message_project (user_uuid, type, content_uuid, owner_user_uuid, status, content, action) VALUES """
        values = ""
        for i in range(memberListLen):
            content = dataJsonDict["nickname"] + "邀请你加入" + dataJsonDict["title"]
            values += """('%s', %d, '%s', '%s', %d, '%s', %d),""" % (memberList[i], 
            Config.TYPE_FOR_MESSAGE_IN_PROJECT_FOR_INVITE, projectUUID,
            dataJsonDict["user_uuid"], Config.TYPE_FOR_MESSAGE_UNREAD, content,
            Config.TYPE_FOR_MESSAGE_ACTION_OFF)
        insertMessageProjectSQL += values[:-1] + ";"
        sqlList.append(insertMessageProjectSQL)

    # 主项目
    insertProjectSQL = """INSERT INTO t_project (uuid, title, detail, result, author_uuid,   status, have_plan, medias_count) VALUES ('{uuid}', '{title}', '{detail}', '{result}', '{author_uuid}', 0, {have_plan}, {medias_count});""".format(uuid=projectUUID, 
         title=dataJsonDict["title"], detail=dataJsonDict["detail"], 
         result=dataJsonDict["result"], author_uuid=dataJsonDict["user_uuid"],
         have_plan=have_plan, medias_count=medias_count)
    sqlList.append(insertProjectSQL)

    return sqlList
    

def removeFileOnError(path, fileList):
    for fileName in fileList:
        fullPath = path + fileName
        os.remove(fullPath)
        

def notificationMember(dataJsonDict):
    memberList = dataJsonDict["memberList"]
    for uuid in memberList:
        content = dataJsonDict["nickname"] + "邀请你加入" + dataJsonDict["title"]
        notification.notificationUserForContent(uuid, content)


        
if __name__ == '__main__':
    pass