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


CeleryDB = Config.CACHE_DB + "://:" + Config.CACHE_PASSWORD + "@" + Config.CACHE_HOST + ":" + str(Config.CACHE_PORT)

BROKER_URL = CeleryDB + "/2"               ##指定 Broker    
CELERY_RESULT_BACKEND = BROKER_URL  ##指定 Backend    
CELERY_TIMEZONE="Asia/Shanghai"                     ##指定时区，默认是 UTC

##CELERY_TIMEZONE="UTC"                             

# import
CELERY_IMPORTS = (                                  ##指定导入的任务模块   
    "dispatch.tasks",
    "dispatch.DBBackupTask" 
)

# schedules
CELERYBEAT_SCHEDULE = {
    # "add-every-30-seconds": {
    #      "task": "dispatch.backupTask.add",
    #      "schedule":  crontab(),#timedelta(seconds=5),       # 每 30 秒执行一次
    #      "args": (5, 8)                           # 任务函数参数
    # },
    "database_backup_task" : {
        "task" : "dispatch.DBBackupTask.backup",
        "schedule" : crontab(hour=1, minute=0)
    }
    # "multiply-at-some-time": {
    #     "task": "celery_app.task2.multiply",
    #     "schedule": crontab(hour=9, minute=50),   # 每天早上 9 点 50 分执行一次
    #     "args": (3, 7)                            # 任务函数参数
    # }
}



