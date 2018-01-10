#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# changePassword.py
#
# Created by ruibin.chow on 2017/08/12.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""
修改密码
"""

from . import account
from module.database import DB
from module.log.Log import Loger
from config import *
from common.code import *
from common.auth import vertifyTokenHandle
from common.tools import getValueFromRequestByKey, md5hex
from .generalMethod import verifyUserPassword


@account.route('/changePassword', methods=["POST"])
@vertifyTokenHandle
def changePassword():
    userUUID = getValueFromRequestByKey("user_uuid")
    oldpassword = md5hex(getValueFromRequestByKey("oldpassword"))
    newpassword = md5hex(getValueFromRequestByKey("newpassword"))

    # 检查密码是否正确
    if not verifyUserPassword(userUUID, oldpassword):
        return RESPONSE_JSON(CODE_ERROR_PASSWORD_ERROR)

    # 更新密码
    if __changeUserPasswordInStorage(userUUID, newpassword):
        return RESPONSE_JSON(CODE_SUCCESS)
    else:
        return RESPONSE_JSON(CODE_ERROR_SERVICE)


def __changeUserPasswordInStorage(userUUID, password):
    result = False
    sqlList = []
    argsList = []

    deleteSQL = """DELETE FROM t_quickTalk_user_auth WHERE user_uuid=%s """
    sqlList.append(deleteSQL)
    argsList.append([userUUID])

    updateSQL = """
        INSERT INTO t_quickTalk_user_auth(user_uuid, password) VALUES (%s, %s)
        """
    sqlList.append(updateSQL)
    argsList.append([userUUID, password])

    dbManager = DB.DBManager.shareInstanced()
    try: 
        result = dbManager.executeTransactionMutltiDmlWithArgsList(sqlList, argsList)
    except Exception as e:
        Loger.error(e, __file__)
            
    return result


if __name__ == '__main__':
    pass
