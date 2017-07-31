#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# DBPool.py
#
# Created by ruibin.chow on 2017/07/31.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

import mysql.connector.pooling
import Config
import logging
import time

class DBPool(object):  
    ''' mysql 数据库连接池 '''
    __slots__ = ("__cnxpool", "__cnx")
     
    def __init__(self):  
        ''''' Constructor '''
        dbconfig = {
          "user":Config.DBUSER,
          "password":Config.DBPWD,
          "host":Config.DBHOST,
          "port":Config.DBPORT,
          "database":Config.DBNAME,
          "charset":Config.DBCHAR
        }

        try:  
            self.__cnxpool = mysql.connector.pooling.MySQLConnectionPool(pool_size=Config.DBPOOLSIZE, 
                        pool_reset_session=True, **dbconfig)  
        except Exception as e:  
            logging.warning(e)  
          
    def executeSingleDml(self, strsql):
        """ insert update delete 单条sql语句"""
        results = True
        try:  
            cnx = self.__cnxpool.get_connection()  
            cursor = cnx.cursor()  
            cursor.execute(strsql)  
            cursor.close()  
            cnx.commit()  
        except Exception as e:  
            logging.warning(e)
            results = False
        finally:  
            if cnx:  
                cnx.close()
        return False
      
    def executeSingleQuery(self, strsql): 
        """ 查询 单条sql语句"""
        results = None  
        try:  
            cnx = self.__cnxpool.get_connection()  
            cursor = cnx.cursor()  
            cursor.execute(strsql)  
            results = cursor.fetchall()  
            cursor.close()  
        except Exception as e:  
            logging.warning(e)  
        finally:  
            if cnx:  
                cnx.close()  
        return results  
      
    def __startTransaction(self):  
        try:  
            self.__cnx = self.__cnxpool.get_connection()  
        except Exception as e:  
            logging.warning(e)  
      
    def __endTransaction(self):  
        if self.__cnx:  
            self.__cnx.close()  
      
    def __commitTransaction(self):  
        try:  
            self.__cnx.commit()  
        except Exception as e:  
            logging.warning(e)  
      
    def __rollbackTransaction(self):  
        try:  
            self.__cnx.rollback()  
        except Exception as e:  
            logging.warning(e)  
      
    def executeTransactionQuery(self, strsql):
        """ 事务下查询sql语句"""
        results = None
        self.__startTransaction()
        try:  
            cursor = self.__cnx.cursor()  
            cursor.execute(strsql)  
            results = cursor.fetchall()  
            cursor.close()
            self.__commitTransaction() 
        except Exception as e:  
            logging.warning(e)
            self.__rollbackTransaction()
        finally:
            self.__endTransaction() 

        return results  
      
    def executeTransactionDml(self, strsql):
        """事务下 insert update delete 单条sql语句"""
        results = True
        self.__startTransaction()
        try:  
            cursor = self.__cnx.cursor()  
            cursor.execute(strsql)  
            cursor.close()
            self.__commitTransaction()
        except Exception as e:  
            logging.warning(e)
            results = False
            self.__rollbackTransaction()
        finally:
            self.__endTransaction()
        return results

    def executeTransactionMutltiDml(self, sqlList):
        """事务下 insert update delete 单条sql语句"""
        results = True
        self.__startTransaction()
        try:  
            cursor = self.__cnx.cursor()  
            for strsql in sqlList:
                cursor.execute(strsql)
            cursor.close()
            self.__commitTransaction()
        except Exception as e:  
            logging.warning(e)
            results = False
            self.__rollbackTransaction()
        finally:
            self.__endTransaction()
        return results
  


def logger():  
    ''''' configure logging '''  
    logging.basicConfig(level=logging.INFO,  
                    format='%(asctime)s [%(levelname)s] [%(filename)s] [%(threadName)s] [line:%(lineno)d] [%(funcName)s] %(message)s',  
                    datefmt='%Y-%m-%d %H:%M:%S')  
  
def test():  
    ''''' 事务使用样例 '''  
      
    cnxpool = DBPool()  
    logging.info("begin")  
      
    results = cnxpool.executeTransactionQuery("SELECT * FROM `t_backoffice_user`")
    for row in results:  
        logging.info("id:%d, name:%s"%(row[0],row[1]))  
    
    logging.info("end")  


    sql1 = """INSERT INTO `t_backoffice_user`(`id`, `nickname`, `detail`, `phone`, `email`, `qq`, `wechat`, `gender`, `area`, `avator`, `career`, `time`, `password`,`level`)
    VALUES(4, 'zruibin1234', 'administration', '+8613113324024', 'ruibin.chow@qq.com', '328437740', 'z_ruibin', 1, '深圳', ' ', '程序员', '2017-07-31 06:17:40',
            'f8f235136f525e39e94f401424954c3a', 0);"""
    sql2 = """INSERT INTO `t_backoffice_user`(`id`, `nickname`, `detail`, `phone`, `email`, `qq`, `wechat`, `gender`, `area`, `avator`, `career`, `time`, `password`,`level`)
    VALUES(3, 'zruibin1234', 'administration', '+8613113324024', 'ruibin.chow@qq.com', '328437740', 'z_ruibin', 1, '深圳', ' ', '程序员', '2017-07-31 06:17:40',
            'f8f235136f525e39e94f401424954c3a', 0);"""
    results = cnxpool.executeTransactionMutltiDml([sql1,sql2])  
    print results 
  

if __name__ == '__main__':  
    logger()        
    test()  
    pass













