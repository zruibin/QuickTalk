#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# Log.py
#
# Created by ruibin.chow on 2017/08/01.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""

"""

from config import Config
import logging
import inspect, os


class Log(object):
    """docstring for Log"""

# format='%(asctime)s [%(levelname)s] [%(filename)s] [%(threadName)s] [line:%(lineno)d] [%(funcName)s] %(message)s',
    if Config.DEBUG:
        logging.basicConfig(level=logging.WARNING,  
                    format='%(asctime)s [%(levelname)s] [%(threadName)s] %(message)s',  
                    datefmt='%Y-%m-%d %H:%M:%S') 
    else:
        logging.basicConfig(filename = os.path.join(os.getcwd(), 'log.txt'), level=logging.WARNING,  
                    format='%(asctime)s [%(levelname)s] [%(threadName)s] %(message)s',  
                    datefmt='%Y-%m-%d %H:%M:%S')  

    def __init__(self):
        super(Log, self).__init__()
        pass

    @classmethod
    def debug(cls, string):
        string = "[%s] %s" % (inspect.stack()[1][3], string)
        logging.debug(string)
        pass

    @classmethod
    def info(cls, string):
        string = "[%s] %s" % (inspect.stack()[1][3], string)
        logging.info(string)
        pass

    @classmethod
    def warning(cls, string):
        string = "[%s] %s" % (inspect.stack()[1][3], string)
        logging.warning(string)
        pass

    @classmethod
    def error(cls, string):
        string = "[%s] %s" % (inspect.stack()[1][3], string)
        logging.error(string)
        pass


if __name__ == '__main__':

    pass






