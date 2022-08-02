#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# topicContent.py
#
# Created by ruibin.chow on 2017/11/09.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""
单个话题内容
"""

from . import news
from module.database import DB
from module.log.Log import Loger
from config import *
from common.code import *
from common.tools import getValueFromRequestByKey, parsePageIndex, limit


@news.route('/topicContent', methods=["GET", "POST"])
def topicContent():
    topicUUID = getValueFromRequestByKey("topic_uuid")
    if topicUUID == None:
        return RESPONSE_JSON(CODE_ERROR_MISS_PARAM) 

    return __getTopicContentFromStorage(topicUUID)


def __getTopicContentFromStorage(topicUUID):
    
    querySQL = """
        SELECT content FROM t_quickTalk_topic_content WHERE  uuid='%s';
    """ % topicUUID

    dbManager = DB.DBManager.shareInstanced()
    try: 
        dataList = dbManager.executeSingleQuery(querySQL)
        dic = {}
        if len(dataList) > 0:
            content = dataList[0]["content"]
            content = __convertCharacter(content)
            dic = {"content": content}
        return RESPONSE_JSON(CODE_SUCCESS, dic)
    except Exception as e:
        Loger.error(e, __file__)
        return RESPONSE_JSON(CODE_ERROR_SERVICE)
    

def __convertCharacter(string):
    """用指定的字符替换文本中指定的字符"""
    string = string.replace("<p>&nbsp;</p>", "<br />")
    string = string.replace("<h1>&nbsp;</h1>", "<br />")
    string = string.replace("<h2>&nbsp;</h2>", "<br />")
    string = string.replace("<h3>&nbsp;</h3>", "<br />")
    string = string.replace("<h4>&nbsp;</h4>", "<br />")
    string = string.replace("<h5>&nbsp;</h5>", "<br />")
    string = string.replace("&nbsp;", " ")
    string = string.replace("&quot;", '"')
    string = string.replace("&lt;", "<")
    string = string.replace("&gt;", ">")
    string = string.replace("&rdquo;", "")
    string = string.replace("&ldquo;", "")
    string = string.replace("&mdash;", "—")
    string = string.replace("&hellip;", "…")
    return string



if __name__ == '__main__':
    pass
