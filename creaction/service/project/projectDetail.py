#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# projectDetail.py
#
# Created by ruibin.chow on 2017/08/18.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""
查看项目(项目详细内容)
"""

from service.project import project
from flask import Flask, Response, request
from module.database import DB
from module.log.Log import Loger
from config import *
from common.code import *
from common.tools import getValueFromRequestByKey, parsePageIndex
from common.commonMethods import queryProjectString, limit


@project.route('/project', methods=["GET", "POST"])
def projectDetail():
    projectUUID = getValueFromRequestByKey("project_uuid")
    if projectUUID == None:
        return RESPONSE_JSON(CODE_ERROR_MISS_PARAM)

    dataDict = __queryProjectDetailFromStorage(projectUUID)

    return RESPONSE_JSON(CODE_SUCCESS)


def __queryProjectDetailFromStorage(projectUUID):
    dataDict = None

    
    return dataDict
    

        
if __name__ == '__main__':
    pass
