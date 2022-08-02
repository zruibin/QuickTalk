#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# tools.py
#
# Created by ruibin.chow on 2017/08/05.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""
json 响应包装工具
"""

from flask import current_app, request, Response
import json, uuid, time, hashlib, random, datetime
from config import *


def jsonTool(obj):
    indent = None
    separators = (',', ':')
    jsonStr = json.dumps(obj, indent=indent, separators=separators)
    response = current_app.response_class((jsonStr, "\n"), mimetype=current_app.config["JSONIFY_MIMETYPE"])
    # response.headers['Access-Control-Allow-Origin'] = '*'  
    # response.headers['Access-Control-Allow-Methods'] = 'PUT,GET,POST,DELETE'  
    # response.headers['Access-Control-Allow-Headers'] = 'x-requested-with,content-type' 
    print response
    return response


def generateUUID():
    """由MAC地址、当前时间戳、随机数生成。可以保证全球范围内的唯一性，
        但MAC的使用同时带来安全性问题，局域网中可以使用IP来代替MAC，
        由于安全问题此处将生成的uuid md5加密一次
     """
    uuidStr = uuid.uuid1()
    uuidStr = str(uuidStr)
    uuidStr = md5hex(uuidStr)
    return uuidStr


def generateCurrentTime():
    timeStr = time.strftime('%Y-%m-%d %H:%M:%S', time.localtime(time.time()))
    return timeStr


def generateCurrentTimeInNumber():
    timeStr = time.strftime("%Y%m%d%H%M%S", time.localtime(time.time()))
    return timeStr
 

def md5hex(word):  
    """ MD5加密算法，返回32位小写16进制符号 """  
    if len(word) == 0:
        return word
    if isinstance(word, unicode):  
        word = word.encode("utf-8")  
    elif not isinstance(word, str):  
        word = str(word)  
    m = hashlib.md5()  
    m.update(word)  
    return m.hexdigest()


def generateVerificationCode():
    ''' 随机生成6位的验证码 '''
    code_list = []
    for i in range(10): # 0-9数字
        code_list.append(str(i))
    for i in range(65, 91): # A-Z
        code_list.append(chr(i))
    for i in range(97, 123): # a-z
        code_list.append(chr(i))
    
    myslice = random.sample(code_list, 6)  # 从list中随机获取6个元素，作为一个片断返回
    verification_code = ''.join(myslice) # list to string
    # print code_list
    # print type(myslice)
    return verification_code


def generateVerificationCode2():
    ''' 随机生成6位的验证码 '''
    code_list = []
    for i in range(2):
        random_num = random.randint(0, 9) # 随机生成0-9的数字
        # 利用random.randint()函数生成一个随机整数a，使得65<=a<=90
        # 对应从“A”到“Z”的ASCII码
        a = random.randint(65, 90)
        b = random.randint(97, 122)
        random_uppercase_letter = chr(a)
        random_lowercase_letter = chr(b)
        code_list.append(str(random_num))
        code_list.append(random_uppercase_letter)
        code_list.append(random_lowercase_letter)
    verification_code = ''.join(code_list)
    return verification_code


def generateVerificationCode3():
    ''' 随机生成6位纯数字的验证码 '''
    numList = []
    for i in range(6):
        num = random.randint(0, 9)
        numList.append(str(num))
    code = "".join(numList)
    return code


def getValueFromRequestByKey(key):
    """从request中的args或form中取得值"""
    value = request.args.get(key) if request.args.get(key) else request.form.get(key)
    return value
    

def generateFileName():
    """文件名，不包含后缀，规则:当时时间(秒级)加6位随机数字字母"""
    timeNum = generateCurrentTimeInNumber()
    randomNum = generateVerificationCode()
    return timeNum + randomNum
    

def fullPathForMediasFile(fileType, uuid, fileName):
    fileName = fileName.strip()
    if len(fileName) == 0: return ""
    fileName = Config.WEB_SITE_HOST + Config.UPLOAD_FOLDER +  fileType + "/" + uuid + "/" + fileName.strip()
    return fileName


def parsePageIndex(index):
    if index == None:
        index = 1
    index = int(index)
    return index


def limit(index, size=Config.PAGE_OF_SIZE):
    return "LIMIT %d,%d" % ((index-1)*size, size)


def makeCookie(response, key, value):
    outdate = datetime.datetime.today() + datetime.timedelta(seconds=Config.TOKEN_EXPIRE) 
    response.set_cookie(key, value, expires=outdate)
    return response

def userAvatarURL(uuid, avatar):
    if avatar == None or len(avatar) == 0: return ""
    if "http://" in avatar or "https://" in avatar:
        return avatar
    else:
        return fullPathForMediasFile(Config.UPLOAD_FILE_FOR_USER, uuid, avatar)




if __name__ == '__main__':
    pass
