#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# Log.py
#
# Created by ruibin.chow on 2017/08/01.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""
日志处理模块
"""

from config import Config
import logging, logging.handlers
import inspect, os
from functools import wraps


class Loger(object):  
    """
    filename 是输出日志文件名的前缀

    when 是一个字符串的定义如下：
        “S”: Seconds
        “M”: Minutes
        “H”: Hours
        “D”: Days
        “W”: Week day (0=Monday)
        “midnight”: Roll over at midnight

    interval 是指等待多少个单位when的时间后，Logger会自动重建文件，当然，这个文件的创建
    取决于filename+suffix，若这个文件跟之前的文件有重名，则会自动覆盖掉以前的文件，所以
    有些情况suffix要定义的不能因为when而重复。

    backupCount 是保留日志个数。默认的0是不会自动删除掉日志。若设10，则在文件的创建过程中
    库会判断是否有超过这个10，若超过，则会从最先创建的开始删除

    Note: http://blog.csdn.net/t163ang/article/details/38495533
    """

    # 定义日志输出格式
    fmtStr = "%(asctime)s [%(levelname)s] [%(threadName)s] %(message)s"

    if Config.DEBUG:
        logging.basicConfig(level=logging.WARNING,  
                    format=fmtStr, datefmt="%Y-%m-%d %H:%M:%S") 
    else:
        # 初始化
        logging.basicConfig()

        # 创建TimedRotatingFileHandler处理对象
        # 间隔5(S)创建新的名称为log%Y%m%d_%H%M%S.txt的文件，并一直占用log文件。
        fileshandle = logging.handlers.TimedRotatingFileHandler(Config.LOG_DIR+"log", 
                                                when="D", interval=1, backupCount=7)
        # 设置日志文件后缀，以当前时间作为日志文件后缀名。
        fileshandle.suffix = "%Y%m%d_%H%M%S.txt"
        # 设置日志输出级别和格式
        fileshandle.setLevel(logging.WARNING)
        formatter = logging.Formatter(fmtStr)
        fileshandle.setFormatter(formatter)
        # 添加到日志处理对象集合
        logging.getLogger('').addHandler(fileshandle)


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






