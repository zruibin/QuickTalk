#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# test-DB.py
#
# Created by ruibin.chow on 2017/08/10.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""

"""

import mysql.connector.pooling
# import MySQLdb

uuid = "f6e996f8-7d83-11e7-889b-8c8590135ddc"

dbconfig = {
          "user":"root",
          "password":"0928",
          "host":"localhost",
          "port":"3306",
          "database":"creaction",
          "charset":"utf8"
        }

__cnxpool = None
try:  
    __cnxpool = mysql.connector.pooling.MySQLConnectionPool(pool_size=4, pool_reset_session=True, **dbconfig)  
except Exception as e:  
    Loger.error(e, __file__)
    raise e



def queryAll():
    strsql = """ 
    SELECT t_user.uuid, t_user.id, t_user.nickname, t_user.avatar, t_user.phone, t_user.email,
    t_user.contact_phone, t_user.contact_email, t_user.qq, t_user.weibo, t_user.wechat,
    t_user_auth.password, t_user_auth.qq AS authQQ, t_user_auth.wechat AS authWechat, t_user_auth.weibo AS authWeibo
    FROM t_user, t_user_auth WHERE t_user.uuid = '{user_uuid}' AND t_user_auth.user_uuid = '{user_uuid}'
    """.format(user_uuid=uuid)
    cnx = __cnxpool.get_connection()  
    cursor = cnx.cursor(dictionary=True)  
    cursor.execute(strsql)  
    results = cursor.fetchall()
    print results
    tupleData  = results[0]

    print tupleData

    user_uuid = tupleData["uuid"]
    user_id = str(tupleData["id"])
    userName = tupleData["nickname"]
    avatar = tupleData["avatar"]
    phone = tupleData["phone"]
    email = tupleData["email"]
    contactPhone = tupleData["contact_phone"]
    contactEmail = tupleData["contact_email"]
    contactQQ = tupleData["qq"]
    contactWeibo = tupleData["weibo"]
    contactWechat = tupleData["wechat"]
    password = tupleData["password"]
    authQQ = tupleData["authQQ"]
    authWechat = tupleData["authWechat"]
    authWeibo = tupleData["authWeibo"]

    dataDict = {
                "user_uuid" : user_uuid,
                "user_id" : user_id,
                "userName" : userName,
                "avatar" : avatar,
                "phone" : phone,
                "email" : email,
                "password" : password,
                "authQQ" : authQQ,
                "authWechat" : authWechat,
                "authWeibo" : authWeibo,
                "contactPhone" : contactPhone,
                "contactEmail" : contactEmail,
                "contactQQ" : contactQQ,
                "contactWeibo" : contactWeibo,
                "contactWechat" : contactWechat
    }

    print user_uuid, user_id, userName,phone,email,authQQ,authWeibo,authWechat
    print dataDict
        
def queryInfo():
    dataDict = {}
    querySQL = """ 
    SELECT t_user.uuid, t_user.id, t_user.nickname, t_user.avatar, t_user.gender, t_user.area, t_user.detail, t_user.career,
        (SELECT count(type) FROM t_user_user WHERE user_uuid='{user_uuid}' AND type=0) AS following,
        (SELECT count(type) FROM t_user_user WHERE user_uuid='{user_uuid}' AND type=1) AS followed,
        (SELECT count(uuid) FROM t_project WHERE author_uuid='{user_uuid}') AS myproject,
        (SELECT count(type) FROM  t_project_user WHERE user_uuid='{user_uuid}' AND type=0) AS joinedProject,
        (SELECT count(type) FROM  t_project_user WHERE user_uuid='{user_uuid}' AND type=1) AS followedProject
        FROM t_user WHERE t_user.uuid='{user_uuid}' 
    """.format(user_uuid=uuid)


    querySchoolSQL = """
    SELECT school FROM t_user_eduction WHERE user_uuid='%s' ORDER BY sorting ASC
    """ % uuid
    queryUserTagSQL = """
    SELECT content FROM t_tag_user WHERE user_uuid='%s' ORDER BY sorting ASC
    """ % uuid
    
    cnx = __cnxpool.get_connection()  
    cursor = cnx.cursor(dictionary=True)  
    cursor.execute(querySQL)  
    results = cursor.fetchall()
    tupleData  = results[0]
    dataDict["uuid"] = tupleData["uuid"]
    dataDict["userId"] = tupleData["id"]
    dataDict["nickname"] = tupleData["nickname"]
    dataDict["avatar"] = tupleData["avatar"]
    dataDict["gender"] = tupleData["gender"]
    dataDict["location"] = tupleData["area"]
    dataDict["detail"] = tupleData["detail"]
    dataDict["career"] = tupleData["career"]
    dataDict["myAndjoinedProject"] = tupleData["myproject"] + tupleData["joinedProject"]
    dataDict["followedProject"] = tupleData["followedProject"]
    dataDict["following"] = tupleData["following"]
    dataDict["followed"] = tupleData["followed"]


    cursor = cnx.cursor(dictionary=False) 
    cursor.execute(querySchoolSQL)  
    rows = cursor.fetchall()
    schoolList = []
    for row in rows:
        schoolList.append(row[0])
    dataDict["school"] = schoolList

    cursor = cnx.cursor(dictionary=False) 
    cursor.execute(queryUserTagSQL)  
    rows = cursor.fetchall()
    tagsList = []
    for row in rows:
        tagsList.append(row[0])
    dataDict["tag"] = tagsList

    print "~" * 80
    print dataDict
    

if __name__ == '__main__':
    queryInfo()
    pass
