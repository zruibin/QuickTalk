#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# RuntimeCache.py
#
# Created by ruibin.chow on 2017/08/04.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""
运行时缓存
"""

from config import Config
from module.log.Log import Loger
import redis

class CacheManager(object):
    """docstring for CacheManager"""

    __slots__ = ("__instance", "__redisClient")
    __instance = None

    def __init__(self):
        super(CacheManager, self).__init__()
        try:
            pool = redis.ConnectionPool(host=Config.CACHE_HOST, port=Config.CACHE_PORT, 
                                                db=0, password=Config.CACHE_PASSWORD)
            self.__redisClient = redis.Redis(connection_pool=pool)
        except Exception, e:
            Loger.error(e, __file__)
            raise e
            pass

    @classmethod
    def shareInstanced(cls):
        """单例模式"""
        if(cls.__instance == None):
            cls.__instance = CacheManager()
        return cls.__instance

    def setCache(self, key, value, expire=Config.CACHE_EXPIRE):
        try:
            self.__redisClient.setex(key, value, time=expire)
        except Exception, e:
            Loger.error(e, __file__)
            raise e

    def getCache(self, key):
        value = None
        try:
            value = self.__redisClient.get(key)
        except Exception, e:
            Loger.error(e, __file__)
        return value

    def setStringCache(self, key, value):
        try:
            self.__redisClient.set(key, value)
        except Exception, e:
            Loger.error(e, __file__)
            raise e

    def getStringCache(self, key):
        value = None
        try:
            value = self.__redisClient.get(key)
        except Exception, e:
            Loger.error(e, __file__)
        return value

    def setListCache(self, key, values):
        try:
            self.__redisClient.delete(key)
            for value in values:
                self.__redisClient.rpush(key, value)
        except Exception, e:
            Loger.error(e, __file__)
            raise e
        
    def getListCache(self, key):
        dataList = []
        try:
            dataList = self.__redisClient.lrange(key, 0, -1)
        except Exception, e:
            Loger.error(e, __file__)
            raise e
        return dataList
        


if __name__ == '__main__':
    pass
