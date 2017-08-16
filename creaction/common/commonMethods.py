#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# commonMethods.py
#
# Created by ruibin.chow on 2017/08/15.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""
需要用到校验的通用方法
"""
from module.database import DB
from module.log.Log import Loger
from config import *
import datetime


def verifyEmailIsExists(email):
    result  = False
    querySQL = """
            SELECT email FROM t_user WHERE email='%s'; """ % email
    dbManager = DB.DBManager.shareInstanced()
    try: 
        resultData = dbManager.executeSingleQuery(querySQL)
        if len(resultData) > 0: result = True
        # print resultData
    except Exception as e:
        Loger.error(e, __file__)

    return result


def verifyEmailIsExistsForReturnUUID(email):
    result  = None
    querySQL = """
            SELECT uuid FROM t_user WHERE email='%s'; """ % email
    dbManager = DB.DBManager.shareInstanced()
    try: 
        resultData = dbManager.executeSingleQuery(querySQL)
        if len(resultData) > 0:
            result = resultData[0]["uuid"]
    except Exception as e:
        Loger.error(e, __file__)

    return result


def verifyPhoneIsExists(phone):
    result  = False
    querySQL = """
            SELECT phone FROM t_user WHERE phone='%s'; """ % phone
    dbManager = DB.DBManager.shareInstanced()
    try: 
        resultData = dbManager.executeSingleQuery(querySQL)
        if len(resultData) > 0: result = True
    except Exception as e:
        Loger.error(e, __file__)

    return result


def verifyPhoneIsExistsForReturnUUID(phone):
    result  = None
    querySQL = """
            SELECT uuid FROM t_user WHERE phone='%s'; """ % phone
    dbManager = DB.DBManager.shareInstanced()
    try: 
        resultData = dbManager.executeSingleQuery(querySQL)
        if len(resultData) > 0: 
            result = resultData[0]["uuid"]
    except Exception as e:
        Loger.error(e, __file__)
    return result


def verifyUserIsExists(userUUID):
    result  = False
    querySQL = """
        SELECT uuid FROM t_user WHERE uuid='%s'; """ % userUUID
    dbManager = DB.DBManager.shareInstanced()
    try: 
        resultData = dbManager.executeSingleQuery(querySQL)
        if len(resultData) > 0: result = True
    except Exception as e:
        Loger.error(e, __file__)

    return result


def verifyUserPassword(userUUID, password):
    result  = False
    querySQL = """
        SELECT password FROM t_user_auth WHERE user_uuid='%s'; """ % userUUID
    dbManager = DB.DBManager.shareInstanced()
    try: 
        resultData = dbManager.executeSingleQuery(querySQL)
        dataPassword = ""
        dataPassword = resultData[0]["password"]
        if dataPassword == password or  len(dataPassword) == 0: 
                result = True
    except Exception as e:
        Loger.error(e, __file__)

    return result


def queryProjectString(string, index):
    limit = "LIMIT %d,%d" % ((index-1)*Config.PAGE_OF_SIZE, Config.PAGE_OF_SIZE)

    querySQL = """
        SELECT t_project.uuid, t_project.title, t_project.status, t_project.author_uuid, t_project.time, t_project.like,

        (SELECT count(uuid) FROM t_comment WHERE project_uuid=t_project.uuid) AS commentNum,
        (SELECT count(user_uuid) FROM t_project_user WHERE project_uuid=t_project.uuid AND type={follower}) AS followNum,

        (SELECT count(user_uuid) FROM t_project_user WHERE project_uuid=t_project.uuid AND type={member}) AS memberNum,
        (SELECT count(uuid) FROM t_project_journal WHERE project_uuid=t_project.uuid) AS journalNum,

        (SELECT content FROM  t_project_journal  WHERE project_uuid=t_project.uuid GROUP BY  time DESC LIMIT 0,1) AS lastJournal,
        (SELECT medias_count FROM  t_project_journal  WHERE project_uuid=t_project.uuid GROUP BY  time DESC LIMIT 0,1) AS lastJournalMediasCount

        {sql} {limit};
    """.format(follower=Config.TYPE_FOR_PROJECT_FOLLOWER,
                    member=Config.TYPE_FOR_PROJECT_MEMBER, sql=string, limit=limit)
    
    return querySQL


def queryProjectDataFromStorageBySubSQL(sql, index=1):
    dataDict = None

    subSQL = """FROM t_project WHERE t_project.uuid IN ({sql}) ORDER BY t_project.time """.format(sql=sql)
    querySQL = queryProjectString(subSQL, index)

    dbManager = DB.DBManager.shareInstanced()
    try: 
        dataDict = dbManager.executeSingleQuery(querySQL)
        for data in dataDict:
            time = data["time"]
            time = str(time) 
            data["time"] = time
    except Exception as e:
        Loger.error(e, __file__)
        raise e
    else:
        return dataDict
    

if __name__ == '__main__':
    pass

