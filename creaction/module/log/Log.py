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
from functools import wraps



class Loger(object):
    """docstring for Log"""

# format='%(asctime)s [%(levelname)s] [%(filename)s] [%(threadName)s] [line:%(lineno)d] [%(funcName)s] %(message)s',
    if Config.DEBUG:
        logging.basicConfig(level=logging.WARNING,  
                    format='%(asctime)s [%(levelname)s] [%(threadName)s] %(message)s',  
                    datefmt='%Y-%m-%d %H:%M:%S') 
    else:
        logging.basicConfig(filename = os.path.join(os.getcwd(), './logs/log.txt'), level=logging.WARNING,  
                    format='%(asctime)s [%(levelname)s] [%(threadName)s] %(message)s',  
                    datefmt='%Y-%m-%d %H:%M:%S')  

    def __init__(self):
        super(Loger, self).__init__()
        pass

    @classmethod
    def debug(cls, string, filename=__file__):
        string = "[%s] %s" % (inspect.stack()[1][3], string)
        logging.debug(string)
        pass

    @classmethod
    def info(cls, string, filename=__file__):
        string = "[%s] %s" % (inspect.stack()[1][3], string)
        logging.info(string)
        pass

    @classmethod
    def warning(cls, string, filename=__file__):
        string = "[%s] %s" % (inspect.stack()[1][3], string)
        logging.warning(string)
        pass

    @staticmethod
    def error(string, filename=__file__):
        filename = os.path.basename(filename)
        string = "[%s] [%s] %s" % (filename, inspect.stack()[1][3], string)
        logging.error(string)
        pass


def LogHandle(func):
    @wraps(func)
    def wrapper(*args, **kwargs):
        try:
            return func(*args, **kwargs)
        except  Exception as e:
            print "**" * 40
            Loger.error(e, __file__)
            print "**" * 40
            raise
    return wrapper


if __name__ == '__main__':

    pass






