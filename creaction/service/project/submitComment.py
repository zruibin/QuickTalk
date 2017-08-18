#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# submitComment.py
#
# Created by ruibin.chow on 2017/08/18.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""
提交评论
"""
from service.project import project
from flask import Flask, Response, request
from module.database import DB
from module.log.Log import Loger
from config import *
from common.code import *
from common.auth import vertifyTokenHandle
from common.tools import getValueFromRequestByKey, generateUUID
from common.commonMethods import queryProjectString, MemberQueryException
import common.notification as notification
# from dispatch.tasks import dispatchNotificationUserForContent


@project.route('/submit_comment', methods=["GET", "POST"])
@vertifyTokenHandle
def submitComment():
    userUUID = getValueFromRequestByKey("user_uuid")
    projectUUID = getValueFromRequestByKey("project_uuid")
    isReply = getValueFromRequestByKey("is_reply") 
    content = getValueFromRequestByKey("content")
    replyCommentUUID = getValueFromRequestByKey("reply_comment_uuid")

    if projectUUID == None:
        return RESPONSE_JSON(CODE_ERROR_MISS_PARAM)
    if isReply == Config.TYPE_FOR_REPLY_COMMENT:
        if content == None or replyCommentUUID == None:
            return RESPONSE_JSON(CODE_ERROR_MISS_PARAM)
    else:
        replyCommentUUID = ""


    return __submitCommentToStorage(userUUID, projectUUID, isReply, replyCommentUUID, content)
    

def __submitCommentToStorage(userUUID, projectUUID, isReply, replyCommentUUID, content):

    uuid = generateUUID()
    dbManager = DB.DBManager.shareInstanced()
    peopleList = None
    notificationContent = ""
    try:
        sqlList = []
        insertCommentSQL = """
            INSERT INTO t_comment (uuid, project_uuid, user_uuid, content, `like`, is_reply, reply_comment_uuid) VALUES ('%s', '%s', '%s', '%s', 0, %s, '%s')""" % (uuid, projectUUID, userUUID,  content, isReply, replyCommentUUID)
        sqlList.append(insertCommentSQL)

        insertMessageCommentSQL = """INSERT INTO t_message_comment (user_uuid, type,
                content_uuid, owner_user_uuid, status, content) VALUES """
        values = ""
        if isReply == Config.TYPE_FRO_COMMENT: # 只是评论则通知作者与成员
            peopleList = __queryProjectAllPeople(projectUUID)
            #若是作者或成员评论则通知时去除自己
            if userUUID in peopleList: peopleList.remove(userUUID)
            typeStr = Config.TYPE_FOR_MESSAGE_IN_PROJECT_COMMENT
            for people in peopleList:
                values += """('%s', %s, '%s', '%s', %d, '%s'),""" % (people, typeStr, 
                                    uuid, '', Config.TYPE_FOR_MESSAGE_UNREAD, content)
            insertMessageCommentSQL += values[:-1] + ";"
            sqlList.append(insertMessageCommentSQL)
            notificationContent = "收到一条评论"  
        else: # 回复则只通知评论者
            people = __queryCommentUserUUID(replyCommentUUID)
            typeStr = Config.TYPE_FOR_MESSAGE_IN_PROJECT_FOR_REPLY_COMMENT
            values += """('%s', %s, '%s', '%s', %d, '%s')""" % (people, typeStr, 
                                    uuid, '', Config.TYPE_FOR_MESSAGE_UNREAD,
                                    content)
            insertMessageCommentSQL += values + ";"
            peopleList = [people]
            sqlList.append(insertMessageCommentSQL)
            notificationContent = "收到一条回复"  

        dbManager.executeTransactionMutltiDml(sqlList)
    except MemberQueryException, e:
        Loger.error(e, __file__)
        return RESPONSE_JSON(CODE_ERROR_QUERY_PROJECT_MEMBER)
    except Exception, e:
        Loger.error(e, __file__)
        return RESPONSE_JSON(CODE_ERROR_SERVICE)
    else:
        __notificationMessageToPeople(peopleList, notificationContent)
        return RESPONSE_JSON(CODE_SUCCESS)


def __queryProjectAllPeople(projectUUID):
    peopleList = []
    querySQL= """
        SELECT user_uuid FROM t_project_user WHERE project_uuid='{projectUUID}' AND type={typeStr}
        UNION
        SELECT author_uuid AS user_uuid FROM t_project WHERE uuid='{projectUUID}'
    """.format(projectUUID=projectUUID, typeStr=Config.TYPE_FOR_PROJECT_MEMBER)

    dbManager = DB.DBManager.shareInstanced()
    try:
        peopleList = dbManager.executeSingleQuery(querySQL, False)
        peopleList = [people[0] for people in peopleList]
    except Exception, e:
        Loger.error(e, __file__)
        raise MemberQueryException()
    else:
        return peopleList


def __queryCommentUserUUID(replyCommentUUID):
    pepleUUID = None
    queryUserUUIDSQL = """SELECT user_uuid FROM t_comment WHERE uuid='%s'; """ % replyCommentUUID
    dbManager = DB.DBManager.shareInstanced()
    try:
        peopleList = dbManager.executeSingleQuery(queryUserUUIDSQL)
        pepleUUID = peopleList[0]["user_uuid"]
    except Exception, e:
        Loger.error(e, __file__)
        raise MemberQueryException()
    else:
        return pepleUUID

def __notificationMessageToPeople(peopleList, content):
    for people in peopleList:
        notification.notificationUserForContent(people, content)
        # dispatchNotificationUserForContent.delay(people, content)



if __name__ == '__main__':
    pass
