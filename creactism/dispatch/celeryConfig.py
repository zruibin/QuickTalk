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
    "dispatch.BackupTask" 
)

# schedules
CELERYBEAT_SCHEDULE = {
    "database_backup_task" : {
        "task" : "dispatch.BackupTask.backup",
        "schedule" : crontab(hour=18, minute=0) # 由于部署服务端时间问题，要提前8个小时来算，凌晨2点时备份
    }
}



