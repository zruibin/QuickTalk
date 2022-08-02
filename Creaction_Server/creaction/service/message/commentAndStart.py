#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# commentAndStart.py
#
# Created by ruibin.chow on 2017/08/22.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""
评论与关注消息
"""

from service.message import message
from module.database import DB
from module.log.Log import Loger
from config import *
from common.code import *
from common.auth import vertifyTokenHandle
from common.tools import getValueFromRequestByKey, fullPathForMediasFile, parsePageIndex
from common.commonMethods import limit


@message.route('/comment_and_start', methods=["GET", "POST"])
@vertifyTokenHandle
def commentAndStart():
    userUUID = getValueFromRequestByKey("user_uuid")
    noUpdate = getValueFromRequestByKey("no_update")

    return __queryCommentAndStartMessageFromStorage(userUUID, noUpdate)


def __queryCommentAndStartMessageFromStorage(userUUID, noUpdate):
    dataList = None
    querySQL = """
    SELECT t_message_comment.user_uuid, t_message_comment.type,
            t_message_comment.content_uuid,
            t_message_comment.content, t_message_comment.time,
            (SELECT title FROM t_project WHERE t_project.uuid IN (SELECT project_uuid FROM t_comment WHERE t_comment.uuid=t_message_comment.content_uuid)
            ) AS title,
            t_user.uuid, t_user.nickname, t_user.avatar
        FROM t_message_comment INNER JOIN t_user
            ON t_message_comment.user_uuid=%s
            AND t_user.uuid=t_message_comment.owner_user_uuid
            AND t_message_comment.status=%s
        UNION
        SELECT t_message_start.user_uuid, t_message_start.type,
                t_message_start.content_uuid,
                t_message_start.content, t_message_start.time,
                '' AS title,
                t_user.uuid, t_user.nickname, t_user.avatar
            FROM t_message_start INNER JOIN t_user
                ON t_message_start.user_uuid=%s
                AND t_user.uuid=t_message_start.owner_user_uuid
                AND t_message_start.status=%s
        ORDER BY time DESC
    """
    queryArgs = [userUUID, str(Config.TYPE_FOR_MESSAGE_IN_PROJECT_COMMENT),
                        userUUID, str(Config.TYPE_FOR_MESSAGE_IN_PROJECT_COMMENT)]

    if noUpdate == None:
        updataCommentMessageSQL = """UPDATE t_message_comment SET status=%s WHERE user_uuid=%s """
        updataStartMessageSQL = """UPDATE t_message_start SET status=%s WHERE user_uuid=%s """
        updateSQLList = [updataCommentMessageSQL, updataStartMessageSQL]
        updateArgsList = [[Config.TYPE_FOR_MESSAGE_READ, userUUID], [Config.TYPE_FOR_MESSAGE_READ, userUUID]]

    dbManager = DB.DBManager.shareInstanced()
    try: 
        dataList = dbManager.executeSingleQueryWithArgs(querySQL, queryArgs)
        for data in dataList:
            data["time"] = str(data["time"])
            data["avatar"] = fullPathForMediasFile(Config.UPLOAD_FILE_FOR_USER, data["uuid"], data["avatar"])
        dataList = __queryReplyComment(dataList)

        dbManager.executeTransactionMutltiDmlWithArgsList(updateSQLList, updateArgsList)
    except Exception as e:
        Loger.error(e, __file__)
        return RESPONSE_JSON(CODE_ERROR_SERVICE)
    else:
        return RESPONSE_JSON(CODE_SUCCESS, dataList)
    

def __queryReplyComment(dataList):
    
    replyCommentKeyList = []
    for data in dataList:
        if data["type"] == int(Config.TYPE_FOR_MESSAGE_IN_PROJECT_FOR_REPLY_COMMENT):
            replyCommentKeyList.append(data["content_uuid"])

    if len(replyCommentKeyList) == 0: return dataList

    inString = "'" + "','".join(replyCommentKeyList) + "'"
    queryReplyKeySQL = """
        SELECT uuid, reply_comment_uuid FROM t_comment WHERE uuid IN (%s);
    """ % inString

    dbManager = DB.DBManager.shareInstanced()
    try: 
        keyList = dbManager.executeSingleQuery(queryReplyKeySQL)
        
        # 所有回复的评论的uuid
        replyCommentValueList = []
        for data in keyList: replyCommentValueList.append(data["reply_comment_uuid"])

        # 所有原评论的uuid及原评论的内容
        ValueInString = "'" + "','".join(replyCommentValueList) + "'"
        queryReplyValueSQL = """
            SELECT uuid AS reply_comment_uuid, content FROM t_comment WHERE uuid IN (%s);
        """ % ValueInString
        valueList = dbManager.executeSingleQuery(queryReplyValueSQL)
        
        dataList = __packageData(keyList, valueList, dataList)
    except Exception as e:
        Loger.error(e, __file__)
        raise e
    
    return dataList
    

def __packageData(keyList, valueList, dataList):
    # print keyList
    # print valueList

    # 包装整理的数据，即回复的评论的uuid为键，原评论的content为值，
    dataDict = {}
    for data in keyList:
        for tempValue in valueList:
            if tempValue["reply_comment_uuid"] == data["reply_comment_uuid"]:
                dataDict[data["uuid"]] = tempValue["content"]
    
    # 在dataList中查到有回复的则加入原评论的内容
    for key, value in dataDict.items():
        for resultDict in dataList:
            if resultDict["content_uuid"] == key:
                resultDict["originContent"] = value

    return dataList


if __name__ == '__main__':
    pass
