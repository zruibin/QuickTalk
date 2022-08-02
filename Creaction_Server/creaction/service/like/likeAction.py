#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# likeAction.py
#
# Created by ruibin.chow on 2017/08/23.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""
点赞与取消点赞项目、评论、日志

# 点赞相关的类型
TYPE_FOR_LIKE_IN_PROJECT = "1" # 项目
TYPE_FOR_LIKE_IN_COMMENT = "2" # 评论
TYPE_FOR_LIKE_IN_JOURNAL = "3" # 日志

#点赞行为
TYPE_FOR_LIKE_ACTION_ON = 1 # 点赞
TYPE_FOR_LIKE_ACTION_OFF = 0 # 取消点赞
"""

from service.like import like
from module.database import DB
from module.log.Log import Loger
from config import *
from common.code import *
from common.auth import vertifyTokenHandle
from common.tools import getValueFromRequestByKey, generateCurrentTime
import common.notification as notification
# from dispatch.tasks import dispatchNotificationUserForContent


@like.route('/like', methods=["GET", "POST"])
@vertifyTokenHandle
def likeAction():
    userUUID = getValueFromRequestByKey("user_uuid")
    typeStr = getValueFromRequestByKey("type")
    action = int(getValueFromRequestByKey("action"))
    likeUUID = getValueFromRequestByKey("liked_uuid")

    if userUUID == None or typeStr == None or action == None or likeUUID == None:
        return RESPONSE_JSON(CODE_ERROR_MISS_PARAM)

    if typeStr == Config.TYPE_FOR_LIKE_IN_PROJECT:
        return __likeActionForProject(userUUID, action, likeUUID)
    elif typeStr == Config.TYPE_FOR_LIKE_IN_COMMENT:
        return __likeActionForComment(userUUID, action, likeUUID)
    elif typeStr == Config.TYPE_FOR_LIKE_IN_JOURNAL:
        return __likeActionForJournal(userUUID, action, likeUUID)
    else:
        return RESPONSE_JSON(CODE_ERROR_PARAM) 


def __likeActionForProject(userUUID, action, likeUUID):
    dbManager = DB.DBManager.shareInstanced()
    time = generateCurrentTime()
    try:
        querySQL = """SELECT author_uuid FROM t_project WHERE uuid='%s'; """ % likeUUID
        resultList = dbManager.executeSingleQuery(querySQL)
        authorUUID = resultList[0]["author_uuid"]

        updateProjectSQL = None
        projectMessageSQL = None
        likeSQL = None
        if action == Config.TYPE_FOR_LIKE_ACTION_ON:
            if __queryWhetherLike(likeUUID, Config.TYPE_FOR_LIKE_IN_PROJECT, userUUID):
                return RESPONSE_JSON(CODE_ERROR_ALREADY_LIKE) 
            updateProjectSQL = """UPDATE t_project SET `like`=`like`+1 WHERE uuid='%s'; """ % likeUUID
            projectMessageSQL = """INSERT INTO t_message_like (user_uuid, type,
                 content_uuid, owner_user_uuid, status, content, time) 
                 VALUES ('%s', %s, '%s', '%s', 0, '%s', '%s');""" % (authorUUID, 
                 Config.TYPE_FOR_LIKE_IN_PROJECT, likeUUID, userUUID, "赞了该项目", time)
            likeSQL = __likeSQLMethod(likeUUID, Config.TYPE_FOR_LIKE_IN_PROJECT, userUUID, action, time)
        elif action == Config.TYPE_FOR_LIKE_ACTION_OFF:
            updateProjectSQL = """UPDATE t_project SET `like`=`like`-1 WHERE uuid='%s'; """ % likeUUID
            projectMessageSQL = """DELETE FROM t_message_like WHERE user_uuid='%s' 
                AND type=%s AND content_uuid='%s' AND owner_user_uuid='%s';
                """% (authorUUID, Config.TYPE_FOR_LIKE_IN_PROJECT, likeUUID, userUUID)
            likeSQL = __likeSQLMethod(likeUUID, Config.TYPE_FOR_LIKE_IN_PROJECT, userUUID, action, time)
        else:
            return RESPONSE_JSON(CODE_ERROR_PARAM) 

        dbManager.executeTransactionMutltiDml([likeSQL, updateProjectSQL, projectMessageSQL])
        
        if action == Config.TYPE_FOR_LIKE_ACTION_ON:
            # 发送通知
            notification.notificationUserForContent(authorUUID, "赞了该项目")
    except Exception as e:
        Loger.error(e, __file__)
        return RESPONSE_JSON(CODE_ERROR_SERVICE)
    else:
        return RESPONSE_JSON(CODE_SUCCESS) 
    

def __likeActionForComment(userUUID, action, likeUUID):
    dbManager = DB.DBManager.shareInstanced()
    time = generateCurrentTime()
    try:
        querySQL = """SELECT user_uuid FROM t_comment WHERE uuid='%s';""" % likeUUID
        resultList = dbManager.executeSingleQuery(querySQL)
        notifyUserUUID = resultList[0]["user_uuid"]

        updateProjectSQL = None
        projectMessageSQL = None
        likeSQL = None
        if action == Config.TYPE_FOR_LIKE_ACTION_ON:
            if __queryWhetherLike(likeUUID, Config.TYPE_FOR_LIKE_IN_COMMENT, userUUID):
                return RESPONSE_JSON(CODE_ERROR_ALREADY_LIKE) 
            updateProjectSQL = """UPDATE t_comment SET `like`=`like`+1 WHERE uuid='%s'; """ % likeUUID
            projectMessageSQL = """INSERT INTO t_message_like (user_uuid, type,
                 content_uuid, owner_user_uuid, status, content, time) 
                 VALUES ('%s', %s, '%s', '%s', 0, '%s', '%s');""" % (notifyUserUUID, 
                 Config.TYPE_FOR_LIKE_IN_COMMENT, likeUUID, userUUID, "赞了该评论", time)
            likeSQL = __likeSQLMethod(likeUUID, Config.TYPE_FOR_LIKE_IN_COMMENT, userUUID, action, time)
        elif action == Config.TYPE_FOR_LIKE_ACTION_OFF:
            updateProjectSQL = """UPDATE t_comment SET `like`=`like`-1 WHERE uuid='%s'; """ % likeUUID
            projectMessageSQL = """DELETE FROM t_message_like WHERE user_uuid='%s' 
                AND type=%s AND content_uuid='%s' AND owner_user_uuid='%s';
                """% (notifyUserUUID, Config.TYPE_FOR_LIKE_IN_COMMENT, 
                likeUUID, userUUID)
            likeSQL = __likeSQLMethod(likeUUID, Config.TYPE_FOR_LIKE_IN_COMMENT, userUUID, action, time)
        else:
            return RESPONSE_JSON(CODE_ERROR_PARAM) 

        dbManager.executeTransactionMutltiDml([likeSQL, updateProjectSQL, projectMessageSQL])
        
        if action == Config.TYPE_FOR_LIKE_ACTION_ON:
            # 发送通知
            notification.notificationUserForContent(notifyUserUUID, "赞了该评论")
    except Exception as e:
        Loger.error(e, __file__)
        return RESPONSE_JSON(CODE_ERROR_SERVICE)
    else:
        return RESPONSE_JSON(CODE_SUCCESS) 


def __likeActionForJournal(userUUID, action, likeUUID):
    dbManager = DB.DBManager.shareInstanced()
    time = generateCurrentTime()
    try:
        querySQL = """SELECT user_uuid FROM t_project_journal WHERE uuid='%s';""" % likeUUID
        resultList = dbManager.executeSingleQuery(querySQL)
        journalUserUUID = resultList[0]["user_uuid"]

        updateProjectSQL = None
        projectMessageSQL = None
        likeSQL = None
        if action == Config.TYPE_FOR_LIKE_ACTION_ON:
            if __queryWhetherLike(likeUUID, Config.TYPE_FOR_LIKE_IN_JOURNAL, userUUID):
                return RESPONSE_JSON(CODE_ERROR_ALREADY_LIKE) 
            updateProjectSQL = """UPDATE t_project_journal SET `like`=`like`+1 WHERE uuid='%s'; """ % likeUUID
            projectMessageSQL = """INSERT INTO t_message_like (user_uuid, type,
                 content_uuid, owner_user_uuid, status, content, time) 
                 VALUES ('%s', %s, '%s', '%s', 0, '%s', '%s');""" % (journalUserUUID, 
                 Config.TYPE_FOR_LIKE_IN_JOURNAL, likeUUID, userUUID, "赞了该日志", time)
            likeSQL = __likeSQLMethod(likeUUID, Config.TYPE_FOR_LIKE_IN_JOURNAL, userUUID, action, time)
        elif action == Config.TYPE_FOR_LIKE_ACTION_OFF:
            updateProjectSQL = """UPDATE t_project_journal SET `like`=`like`-1 WHERE uuid='%s'; """ % likeUUID
            projectMessageSQL = """DELETE FROM t_message_like WHERE user_uuid='%s' 
                AND type=%s AND content_uuid='%s' AND owner_user_uuid='%s';
                """% (journalUserUUID, Config.TYPE_FOR_LIKE_IN_JOURNAL, likeUUID, userUUID)
            likeSQL = __likeSQLMethod(likeUUID, Config.TYPE_FOR_LIKE_IN_JOURNAL, userUUID, action, time)
        else:
            return RESPONSE_JSON(CODE_ERROR_PARAM) 

        dbManager.executeTransactionMutltiDml([likeSQL, updateProjectSQL, projectMessageSQL])
        
        if action == Config.TYPE_FOR_LIKE_ACTION_ON:
            # 发送通知
            notification.notificationUserForContent(journalUserUUID, "赞了该日志")
    except Exception as e:
        Loger.error(e, __file__)
        return RESPONSE_JSON(CODE_ERROR_SERVICE)
    else:
        return RESPONSE_JSON(CODE_SUCCESS) 


def __likeSQLMethod(contentUUID, typeStr, userUUID, action, time):
    if action == Config.TYPE_FOR_LIKE_ACTION_ON:
        insertLikeSQL = """
            INSERT INTO t_like (content_uuid, type, user_uuid, time) VALUES ('%s', %s, '%s');
        """ % (contentUUID, typeStr, userUUID, time)
        return insertLikeSQL
    else:
        deleteLikeSQL = """
            DELETE FROM t_like WHERE content_uuid='%s' AND type=%s AND user_uuid='%s';
        """ % (contentUUID, typeStr, userUUID)
        return deleteLikeSQL
    

def __queryWhetherLike(likeUUID, typeStr, userUUID):
    querySQL = """SELECT user_uuid FROM t_like WHERE content_uuid='%s' AND type=%s AND user_uuid='%s'; """ % (likeUUID, typeStr, userUUID)
    dbManager = DB.DBManager.shareInstanced()
    try:
        resultList = dbManager.executeSingleQuery(querySQL)
        if len(resultList) > 0: return True
    except Exception as e:
        Loger.error(e, __file__)
        raise e



if __name__ == '__main__':
    pass
