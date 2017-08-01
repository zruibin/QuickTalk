#! /usr/bin/python
# coding:utf-8
# 
# compile.py
#
# Created by Ruibin.Chow on 2017/04/30.
# Copyright (c) 2017年 www.zruibin.cc. All rights reserved.
#

import py_compile, compileall
import sys, os, os.path, shutil


def getAllFileInDir(DIR):
    """返回指定目录下所有文件的集合"""
    array = getAllFileInDirBeyoundTheDir(DIR, '')
    return array
    
def getAllFileInDirBeyoundTheDir(DIR, beyoundDir):
    """返回指定目录下所有文件的集合，beyoundDir的目录不包含"""
    array = []
    # print DIR+beyoundDir
    for root, dirs, files in os.walk(DIR):
        if len(beyoundDir) != 0 and os.path.exists(DIR+beyoundDir):
            if beyoundDir not in dirs:
                continue
        for name in files:
            path = os.path.join(root,name)
            array.append(path)
            # print path
            # print os.path.basename(name)
    return array

def clear(DIR):
    """列出指定目录下所有文件"""
    array = getAllFileInDir(DIR)
    for path in array:
        # print path
        fileExtension = os.path.splitext(path)[1]
        if fileExtension == ".py":
            os.remove(path)
    pass


def help():
    string = """Available commands:
    -h or help                   Display general or command-specific helps   
    -rootDir=dirName       Source directory
    -distDir=dirName        Distribute  directory
"""
    print string
    pass


def Main(argsList):
    if len(argsList) != 1:
        # print argsList
    
        if "-h" in argsList or "help" in argsList:
            help()

        rootdir = ""
        distDir = ""
        for arg in argsList:
            if arg.startswith('-rootDir='):
                rootdir = arg.split("=")[1]
            if arg.startswith('-distDir='):
                distDir = arg.split("=")[1]
                if os.path.exists(distDir):
                    shutil.rmtree(distDir)

        # print rootdir
        # print distDir
        if len(rootdir) > 0 and len(distDir) > 0:
            shutil.copytree(rootdir, distDir)
            compileall.compile_dir(distDir)
            clear(distDir)

    # py_compile.compile(r'H:\game\test.py')
    pass


if __name__ == '__main__':
    Main(sys.argv)
    print "--" * 30
    pass

