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

RELEASE="build"

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

def clean(DIR):
    """列出指定目录下所有文件"""
    array = getAllFileInDir(DIR)
    for path in array:
        # print path
        fileExtension = os.path.splitext(path)[1]
        if fileExtension == ".py":
            os.remove(path)
    pass

def cleanPYC(DIR):
    array = getAllFileInDir(DIR)
    print array
    for path in array:
        # print path
        fileExtension = os.path.splitext(path)[1]
        if fileExtension == ".pyc":
            os.remove(path)
    pass


def help():
    string = """Available commands:
    -h or help                   Display general or command-specific helps   
    -rootDir=dirName       Source directory
    clean  dirName            clean dirName all .pyc file                         
"""
    print string
    pass


def copyRequireFile():
    dirList = ["./requirements.txt", "./conf/start.sh", "./conf/creactism.conf", "./conf/supervisor.conf", "./conf/nginx.conf"]
    for directory in dirList:
        newDir = RELEASE + "/" + os.path.basename(directory)
        shutil.copyfile(directory, newDir)
    pass

def removeSomeDir():
    dirList = ["/logs", "/medias"]
    for dirPath in dirList:
        dirName = RELEASE + dirPath
        if os.path.exists(dirName):
            shutil.rmtree(dirName)
    pass


def convert_character(string, origin_string, replace_string):
    """用指定的字符替换文本中指定的字符"""
    string = string.replace(origin_string, replace_string)
    return string

def changeDebugStatus(DIR):
    oldText = "DEBUG = True"
    newText = "DEBUG = False"
    fileList = ["config.py", "gun.py"]
    for fileName in fileList:
        filePath = DIR + "/" + fileName
        content = ""
        print filePath
        with open(filePath, "r") as f:
            allText = f.read()
            content = allText.replace(oldText, newText)
        with open(filePath, "w") as f:
            f.write(content)
    pass



def Main(argsList):
    if len(argsList) != 1:
        # print argsList
    
        if "-h" in argsList or "help" in argsList:
            help()
            return
        if "clean" in argsList:
            print argsList
            if os.path.exists(argsList[2]):
                cleanPYC(argsList[2])
                shutil.rmtree(RELEASE)
            return

        rootdir = ""
        distDir = RELEASE
        for arg in argsList:
            if arg.startswith('-rootDir='):
                rootdir = arg.split("=")[1]
                if os.path.exists(distDir):
                    shutil.rmtree(distDir)

        # print rootdir
        # print distDir
        if len(rootdir) > 0 and len(distDir) > 0:
            shutil.copytree(rootdir, distDir)
            changeDebugStatus(distDir)
            compileall.compile_dir(distDir)
            copyRequireFile()
            removeSomeDir()
            clean(distDir)

    # py_compile.compile(r'H:\game\test.py')
    pass


if __name__ == '__main__':
    Main(sys.argv)
    print "--" * 30
    pass

