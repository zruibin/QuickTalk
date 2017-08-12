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
from smtplib import SMTP_SSL
from email.MIMEText import MIMEText
import threading
from module.log.Log import Loger
from config import Config
from module.cache.RuntimeCache import CacheManager
from common.tools import generateVerificationCode3
  

def sendEmail(to, sub, content):  
    loginAccount = Config.MAIL_USER + "@" + Config.MAIL_POSTFIX
    me = "<" + Config.MAIL_USER + "@" + Config.MAIL_POSTFIX + ">"
    msg = MIMEText(content, _subtype='html', _charset='utf-8')    
    
    msg['Subject'] = sub
    msg['From'] = "可行APP" + me
    msg['To'] = to
    smtp = smtplib.SMTP()
    #ssl登录
    smtp = SMTP_SSL(Config.MAIL_HOST)
    
    try:  
        #是用来调试的。参数值为1表示开启调试模式，参数值为0关闭调试模式
        # smtp.set_debuglevel(1)
        smtp.ehlo(Config.MAIL_HOST)
        smtp.login(loginAccount, Config.MAIL_PASSWORD)  #登陆服务器
        smtp.sendmail(me, to, msg.as_string())  #发送邮件
    except Exception, e:
        Loger.error(e, __file__)
    finally:
        smtp.quit()
    pass


def sendEmailForVerifyCode(email, code):
    '''
        @Args:
            email: str (用户电子邮箱)
            code: str(6位数字验证码)
        @Return: 无
    '''
    content = "此次可用验证码："+ code + " (仅30分钟内有效)"
    sendEmail(email, "验证码", content)
    # t = threading.Thread(target=sendEmail, args=(email, "验证码", content))
    # t.start()
    pass


def sendEmailForVerifyCodeByCache(email):
    """Note: 此方法由Celery进行异步调用，dispatch发邮件"""
    result = False
    try:
        code = CacheManager.shareInstanced().getCache(email)
        if code == None:
            code = generateVerificationCode3()
            CacheManager.shareInstanced().setCache(email, code, 1800)
        sendEmailForVerifyCode(email, code)
        result = True
    except Exception as e:
        Loger.error(e, __file__)

    return result





if __name__ == '__main__':
    
    to = "ruibin.chow@qq.com" #"ruibin.chow@qq.com"
    sendEmailForVerifyCode(to, str(121212))
    print "ok"
    pass

