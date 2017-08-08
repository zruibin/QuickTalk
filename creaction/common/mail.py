#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# mail.py
#
# Created by ruibin.chow on 2017/08/07.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""
邮箱验证码发送
"""

import smtplib
from email.MIMEText import MIMEText
import threading, random
from module.log.Log import Loger
from config import Config
from module.cache.RuntimeCache import CacheManager


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

  
def sendEmail(to, sub, content):  
    me = "<" + Config.MAIL_USER + "@" + Config.MAIL_POSTFIX + ">"
    msg = MIMEText(content, _subtype='html', _charset='utf-8')  
    
    msg['Subject'] = sub
    msg['From'] = "思集科技" + me
    msg['To'] = to
    smtp = smtplib.SMTP()
    try:  
        smtp.connect(Config.MAIL_HOST)  #连接smtp服务器
        smtp.login(Config.MAIL_USER, Config.MAIL_PASSWORD)  #登陆服务器
        smtp.sendmail(me, to, msg.as_string())  #发送邮件
    except Exception, e:
        Loger.error(e, __file__)
        print str(e)
    finally:
        smtp.close()
    pass


def sendEmailForVerifyCode(email, code):
    '''
        @Args:
            email: str (用户电子邮箱)
            code: str(6位数字验证码)
        @Return: 无
    '''
    content = "此次可用验证码："+ code + " (仅30分钟内有效)"
    t = threading.Thread(target=sendEmail, args=(email, "验证码", content))
    t.start()
    pass


def sendEmailForVerifyCodeByCache(email):
    try:
        code = CacheManager.shareInstanced().getCache(email)
        if code == None:
            code = generateVerificationCode2()
            CacheManager.shareInstanced().setCache(email, code, 1800)
        sendEmailForVerifyCode(email, code)
    except expression as identifier:
        Loger.error(e, __file__)
    pass


if __name__ == '__main__':
    
    to = "ruibin.chow@qq.com" #"ruibin.chow@qq.com"
    sendEmailForVerifyCode(to, str(121212))
    print "ok"
    pass

