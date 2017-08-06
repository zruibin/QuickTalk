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
    bind = '127.0.0.1:5000'
    pidfile = 'logs/gunicorn.pid'
    logfile = 'logs/debug.log'


#启动的进程数与线程
workers = multiprocessing.cpu_count() * 2 + 1 
worker_class = 'gunicorn.workers.ggevent.GeventWorker'
threads = 2 * multiprocessing.cpu_count()

x_forwarded_for_header = 'X-FORWARDED-FOR'



if __name__ == '__main__':
    pass
