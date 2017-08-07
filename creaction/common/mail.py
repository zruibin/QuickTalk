#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# mail.py
#
# Created by ruibin.chow on 2017/08/07.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""

"""

from email.MIMEText import MIMEText
import smtplib

# mail_host="smtp.126.com"  #设置服务器
# mail_user="creaction"    #用户名
# mail_pass="...362436..."   #口令 
# mail_postfix="126.com"  #发件箱的后缀
mail_host="smtp.qq.com"  #设置服务器
mail_user="328437740"    #用户名
mail_pass="7811327rbsd."   #口令 
mail_postfix="qq.com"  #发件箱的后缀
  
def sendEmail(to_list, sub, content):  #to_list：收件人；sub：主题；content：邮件内容
    me="验证码"+"<"+mail_user+"@"+mail_postfix+">"   #这里的hello可以任意设置，收到信后，将按照设置显示
    msg = MIMEText(content,_subtype='html',_charset='utf-8')    #创建一个实例，这里设置为html格式邮件
    msg['Subject'] = sub    #设置主题
    msg['From'] = me  
    msg['To'] = ";".join(to_list)  
    try:  
        s = smtplib.SMTP()  
        s.connect(mail_host)  #连接smtp服务器
        s.login(mail_user,mail_pass)  #登陆服务器
        s.sendmail(me, to_list, msg.as_string())  #发送邮件
        s.close()  
        return True  
    except Exception, e:  
        print str(e)  
        return False

if __name__ == '__main__':
    
    mailto_list=["creaction@126.com"] 

    if sendEmail(mailto_list,"hello","<a href='http://www.zruibin.cci'>Ruibin.Chow</a>"):  
        print "发送成功"  
    else:  
        print "发送失败"  

