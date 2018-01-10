#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# __init__.py
#
# Created by ruibin.chow on 2017/12/04.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""

"""

from flask import Blueprint
  
account = Blueprint("account", __name__)

from . import changeArea
from . import changeGender
from . import changeDetail
from . import register
from . import login
from . import forgetPassword
from . import changePassword
from . import thirdParty
from . import info
from . import changeAvatar
from . import changeInfo
from . import userList
from . import setting
from . import settingList
from . import addDevice
from . import deleteDevice


if __name__ == '__main__':
    pass
