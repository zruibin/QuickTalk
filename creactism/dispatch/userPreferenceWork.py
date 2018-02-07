#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# userPreferenceWork.py
#
# Created by ruibin.chow on 2018/02/07.
# Copyright (c) 2018年 ruibin.chow All rights reserved.
# 

"""

"""
from dispatch import celery
from service.quickTalk.userPreference.generateAll import generateAll

@celery.task
def generateAllUserPreference():
    generateAll()
    pass
    

if __name__ == '__main__':
    pass
