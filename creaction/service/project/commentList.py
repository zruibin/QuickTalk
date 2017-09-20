#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# commentList.py
#
# Created by ruibin.chow on 2017/08/18.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""
查看项目评论
"""

from service.project import project
from module.database import DB
from module.log.Log import Loger
from config import *
from common.code import *
from common.tools import getValueFromRequestByKey, fullPathForMediasFile, parsePageIndex
from common.commonMethods import limit


@project.route('/comment', methods=["GET", "POST"])
def comment():
    projectUUID = getValueFromRequestByKey("project_uuid")
    index = getValueFromRequestByKey("index")
    userUUID = getValueFromRequestByKey("user_uuid")

    index = parsePageIndex(index)
    if projectUUID == None:
        return RESPONSE_JSON(CODE_ERROR_MISS_PARAM)
    
    return __getCommentFromStorage(projectUUID, index, userUUID)


def __getCommentFromStorage(projectUUID, index, userUUID):
    limitSQL = limit(index)

    querySQL = ""
    if userUUID == None:
        querySQL = """
            SELECT t_comment.uuid, project_uuid, user_uuid, content, t_comment.time, `like`,
            is_reply AS isReply, t_user.nickname, t_user.avatar,
            reply_comment_uuid
            FROM t_comment LEFT JOIN t_user
            ON project_uuid='{projectUUID}' AND t_user.uuid=t_comment.user_uuid
            ORDER BY t_comment.time DESC {limitSQL}
            """.format(projectUUID=projectUUID, limitSQL=limitSQL)
    else:
        querySQL = """
            SELECT t_comment.uuid, project_uuid, user_uuid, content, t_comment.time, `like`,
            is_reply AS isReply, t_user.nickname, t_user.avatar,
            (SELECT count(content_uuid) FROM t_like WHERE       
                    content_uuid=t_comment.uuid AND user_uuid='{userUUID}
' AND type='{likeType}') AS likeStatus,
            reply_comment_uuid
            FROM t_comment LEFT JOIN t_user
            ON project_uuid='{projectUUID}' AND t_user.uuid=t_comment.user_uuid
            ORDER BY t_comment.time DESC {limitSQL}
            """.format(projectUUID=projectUUID, limitSQL=limitSQL, userUUID=userUUID, likeType=Config.TYPE_FOR_LIKE_IN_COMMENT)

    dbManager = DB.DBManager.shareInstanced()
    try:
        dataDict = dbManager.executeSingleQuery(querySQL)
        for data in dataDict:
            data["time"] = str(data["time"])
            data["avatar"] = fullPathForMediasFile(Config.UPLOAD_FILE_FOR_USER, data["user_uuid"], data["avatar"])

        dataDict = __queryReplyCommentUserInfo(dataDict)        
            
        return RESPONSE_JSON(CODE_SUCCESS, dataDict)
    except Exception as e:
        Loger.error(e, __file__)
        return RESPONSE_JSON(CODE_ERROR_SERVICE)
    
def __queryReplyCommentUserInfo(dataDict):
    inList = [data["reply_comment_uuid"] for data in dataDict if len(data["reply_comment_uuid"])>0]

    inString = "'" + "','".join(inList) + "'"
    querySQL = """
        SELECT t_comment.uuid, t_user.nickname, t_user.avatar, t_user.uuid AS user_uuid
        FROM t_comment INNER JOIN t_user
        ON t_comment.uuid IN ({inString}) AND t_user.uuid=t_comment.user_uuid
    """.format(inString=inString)

    dbManager = DB.DBManager.shareInstanced()
    try:
        dataReplyDict = dbManager.executeSingleQuery(querySQL)
        for replyDict in dataReplyDict:
            for data in dataDict:
                if replyDict["uuid"] == data["reply_comment_uuid"]:
                    data["reply_user_uuid"] = replyDict["user_uuid"]
                    data["reply_user_nickname"] = replyDict["nickname"]
    except Exception as e:
        Loger.error(e, __file__)
        raise e
    else:
        return dataDict
    


if __name__ == '__main__':
    pass
