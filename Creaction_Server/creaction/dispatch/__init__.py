#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# __init__.py
#
# Created by ruibin.chow on 2017/08/11.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""

"""
from celery import Celery

celery = Celery('tasks') # , broker='redis://:0928@localhost:6379/3'

celery.config_from_object('dispatch.celeryConfig')   ##通过 Celery 实例加载配置模块


if __name__ == '__main__':
    pass
