#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# gun.py
#
# Created by ruibin.chow on 2017/08/06.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""
gunicorn启动配置
"""

import os
import gevent.monkey
import multiprocessing

gevent.monkey.patch_all()

DEBUG = True 

if DEBUG:
    reload = True
    debug = True 
    loglevel = 'debug'
else:
    reload = False
    debug = False 
    loglevel = 'warning'

    path_of_current_file = os.path.abspath(__file__)
    path_of_current_dir = os.path.split(path_of_current_file)[0]
    _file_name = "gunicorn"
    pidfile = '%s/logs/%s.pid' % (path_of_current_dir, _file_name)
    logfile = '%s/logs/%s.pid' % (path_of_current_dir, _file_name)
    errorlog = '%s/logs/%s_error.log' % (path_of_current_dir, _file_name)
    # accesslog = '%s/logs/%s_access.log' % (path_of_current_dir, _file_name)
    


bind = '127.0.0.1:5000'

#启动的进程数与线程
workers = multiprocessing.cpu_count() * 2 + 1 
worker_class = 'gunicorn.workers.ggevent.GeventWorker'
threads = 2 * multiprocessing.cpu_count()

x_forwarded_for_header = 'X-FORWARDED-FOR'



if __name__ == '__main__':
    pass
