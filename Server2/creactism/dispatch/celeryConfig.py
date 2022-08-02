#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# celeryConfig.py
#
# Created by ruibin.chow on 2017/08/19.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""
Celery配置文件
"""

from config import *
from datetime import timedelta
from celery.schedules import crontab

import sys
# 第三方库
sys.path.append("./lib")
sys.path.append("./lib/pygetui")

CeleryDB = Config.CACHE_DB + "://:" + Config.CACHE_PASSWORD + "@" + Config.CACHE_HOST + ":" + str(Config.CACHE_PORT)

BROKER_URL = CeleryDB + "/2"               ##指定 Broker    
CELERY_RESULT_BACKEND = BROKER_URL  ##指定 Backend    
CELERY_TIMEZONE="Asia/Shanghai"                     ##指定时区，默认是 UTC

##CELERY_TIMEZONE="UTC"                             

# import
CELERY_IMPORTS = (  ##指定导入的任务模块   
    "dispatch.notification",
    "dispatch.BackupTask",
    "dispatch.userPreferenceWork"
)

# schedules
CELERYBEAT_SCHEDULE = {
    # "add-every-30-seconds": {
    #      "task": "dispatch.backupTask.add",
    #      "schedule":  crontab(),#timedelta(seconds=5),       # 每 30 秒执行一次
    #      "args": (5, 8)                           # 任务函数参数
    # },
    "database_backup_task" : {
        "task" : "dispatch.BackupTask.backup",
        "schedule" : crontab(hour=18, minute=0) # 由于部署服务端时间问题，要提前8个小时来算，凌晨2点时备份
    },
    "userPreference_task" : {
        "task" : "dispatch.userPreferenceWork.generateAllUserPreference",
        "schedule" : crontab(hour=19, minute=0) # 凌晨3点时计算
    }
    # "multiply-at-some-time": {
    #     "task": "celery_app.task2.multiply",
    #     "schedule": crontab(hour=9, minute=50),   # 每天早上 9 点 50 分执行一次
    #     "args": (3, 7)                            # 任务函数参数
    # }
}



