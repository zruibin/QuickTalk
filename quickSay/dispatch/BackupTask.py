#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# BackupTask.py
# ruibin.chow@qq.com
#
# Created by Ruibin.Chow on 2017/05/17.
# Copyright (c) 2017年 Ruibin.Chow All rights reserved.
# 

"""
定时备份mysql数据
"""
import os, os.path, time, sys
import tarfile, zipfile
from dispatch import celery
from config import *


reload(sys)  
sys.setdefaultencoding('utf8')  

#bakup file path
backupDir = Config.BACKUP_DIR


@celery.task
def backup():
    __backupDB()
    pass


def __backupDB():
    #mysql username
    username = Config.DBUSER
    #mysql password
    userpwd = Config.DBPWD
    # dump path
    dumpPath = "mysqldump"
    #db name
    dbName = Config.DBNAME # --all-databases 

    baseName = dbName + "_" + time.strftime("%Y%m%d-%H%M%S")
    fileName = baseName + ".sql"
    fullPath =  backupDir + "/" + fileName

    bz2File = baseName + ".tar.bz2"  

    if os.path.exists(backupDir) == False: os.mkdir(backupDir)

    cmd = dumpPath +" -u " + username + " -p'" + userpwd + "' " + dbName + " > " + fullPath
    os.system(cmd)

    bz2CMD = """tar -jcvf {backupDir}/{bz2File} -C  {backupDir} {fileName}""".format(backupDir=backupDir, bz2File=bz2File, fileName=fileName)
    print bz2CMD
    os.system(bz2CMD)

    os.remove(fullPath)
    pass


if __name__ == '__main__':
    backup()
    pass



