#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# __init__.py
#
# Created by ruibin.chow on 2017/08/08.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""

"""

from flask import Blueprint
  
account = Blueprint("account", __name__)
  
from service.account import register
from service.account import verifyEmailOrPhone
from service.account import token
from service.account import setting
from service.account import changeTag
from service.account import changeContact
from service.account import info
from service.account import contact
from service.account import checkContact
from service.account import changeInfo
from service.account import getVerifyCode
from service.account import changeAvatar
from service.account import thirdParty
from service.account import changePassword
from service.account import forgetPassword
from service.account import login
from service.account import applyContact
from service.account import agreeApplyContact
from service.account import settingList
from service.account import changeInfoDetail

