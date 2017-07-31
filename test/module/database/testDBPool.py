#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# testDBPool.py
#
# Created by ruibin.chow on 2017/07/31.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

import unittest
import logging
import time
from Creation.module.database import DBPool

import sys
reload(sys)
sys.setdefaultencoding("utf-8")

def logger():  
    ''''' configure logging '''  
    logging.basicConfig(level=logging.INFO,  
                    format='%(asctime)s [%(levelname)s] [%(filename)s] [%(threadName)s] [line:%(lineno)d] [%(funcName)s] %(message)s',  
                    datefmt='%Y-%m-%d %H:%M:%S')  

class DBPoolTest(unittest.TestCase):
    """docstring for DBPoolTest"""
    def setUp(self):
        pass
    
    def tearDown(self):
        pass

    def testPoolAction(self):
         """ 事务使用样例 """
         pass
        # cnxpool = DBPool()
        # logging.info("begin")  
          
        # results = cnxpool.executeTransactionQuery("SELECT * FROM `t_backoffice_user`")
        # for row in results:  
        #     logging.info("id:%d, name:%s"%(row[0],row[1]))  
        
        # logging.info("end")  


        # sql1 = """INSERT INTO `t_backoffice_user`(`id`, `nickname`, `detail`, `phone`, `email`, `qq`, `wechat`, `gender`, `area`, `avator`, `career`, `time`, `password`,`level`)
        # VALUES(4, 'zruibin1234', 'administration', '+8613113324024', 'ruibin.chow@qq.com', '328437740', 'z_ruibin', 1, '深圳', ' ', '程序员', '2017-07-31 06:17:40',
        #         'f8f235136f525e39e94f401424954c3a', 0);"""
        # sql2 = """INSERT INTO `t_backoffice_user`(`id`, `nickname`, `detail`, `phone`, `email`, `qq`, `wechat`, `gender`, `area`, `avator`, `career`, `time`, `password`,`level`)
        # VALUES(3, 'zruibin1234', 'administration', '+8613113324024', 'ruibin.chow@qq.com', '328437740', 'z_ruibin', 1, '深圳', ' ', '程序员', '2017-07-31 06:17:40',
        #         'f8f235136f525e39e94f401424954c3a', 0);"""
        # results = cnxpool.executeTransactionMutltiDml([sql1,sql2])  
        # print results 


        


if __name__ == '__main__':
    pass
