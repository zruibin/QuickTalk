#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# code.py
#
# Created by ruibin.chow on 2017/08/07.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""
请求返回code与相对应的message
基本错误从10001开始
Token错误从11000开始
图片错误从12000开始
"""

from common.tools import jsonTool

CODE_SUCCESS = 10000 # 请求成功

CODE_ERROR_SYSTEM = 10001 # 系统错误
CODE_ERROR_SERVICE = 10002 # 服务错误
CODE_ERROR_PARAM = 10003 # 参数错误
CODE_ERROR_BUSY = 10004 # 系统繁忙错误
CODE_ERROR_ILLEGAL_REQUEST = 10005 # 非法请求错误
CODE_ERROR_PERMISSION = 10006 # 权限错误
CODE_ERROR_INVALID_USER = 10007 # 不合法用户
CODE_ERROR_MISS_PARAM = 10008 # 缺少参数
CODE_ERROR_REQUEST_TOO_MANY = 10009 # 请求次数过多

CODE_ERROR_USER_EXISTS = 10010 # 用户已存在
CODE_ERROR_USER_NOT_EXISTS = 10011 # 用户不存在
CODE_ERROR_CONTENT_IS_NULL = 10012 # 内容为空
CODE_ERROR_TEXT_TOO_LONG = 10013 # 输入文字太长，请确认不超过XXX个字符
CODE_ERROR_OUT_OF_LIMIT = 10014 # 发布内容过于频繁
CODE_ERROR_CONTAIN_ILLEGAL_WEBSITE = 10015 # 包含非法网址
CODE_ERROR_CONTAIN_ADVERTISING = 10016 # 包含非法内容
CODE_ERROR_TEST_AND_VERIFY = 10017 # 需要验证码
CODE_ERROR_SUCCESS_BUT_NEED_WAIT = 10018 # 发布成功，目前服务器可能会有延迟，请耐心等待1-2分钟
CODE_ERROR_ILLEGAL_COMMENT = 10019 # 不合法的评论
CODE_ERROR_ILLEGAL_JOURNAL = 10020 # 不合法的日志
CODE_ERROR_ILLEGAL_NICKNAME = 10021 # 不合法的昵称
CODE_ERROR_THE_PHONE_HAS_BE_USED = 10022 # 该手机号已经被使用
CODE_ERROR_THE_ACCOUNT_HAS_BEAN_BIND_PHONE = 10023 # 该用户已经绑定手机
CODE_ERROR_WRONG_VERIFIER = 10024 # Verifier错误
CODE_ERROR_AUTH_FAILD = 10025 # 认证失败
CODE_ERROR_PHONE_OR_PASSWORD_ERROR = 10026 # 手机或密码错误
CODE_ERROR_EMAIL_OR_PASSWORD_ERROR = 10027 # 邮箱或密码错误
CODE_ERROR_CONTAINS_FORBID_WORLD = 10028 # 含有敏感词
CODE_ERROR_VERSION_REJECTED = 10029 # 版本号错误
CODE_ERROR_VERIFY_CODE_OUTDATE = 10030 # 验证码过期
CODE_ERROR_THE_EMAIL_HAS_BE_USED = 10031 # 该邮箱已经被使用
CODE_ERROR_PASSWORD_ERROR = 10032 # 密码错误
CODE_ERROR_ILLEGAL_TAG_CONTENT = 10033 # 列表字符格式错误
CODE_ERROR_ILLEGAL_DATA_CONTENT = 10034 # 数据格式错误
CODE_ERROR_ONLY_FOR_EMAIL = 10035 # 暂时只支持邮箱
CODE_ERROR_THIDR_ALREAD_BE_BIND = 10036 # 该第三方帐号已被绑定


CODE_ERROR_TOKEN_USED = 11000 # token已经被使用
CODE_ERROR_TOKEN_EXPIRED = 11001 # token已经过期
CODE_ERROR_TOKEN_REVOKED = 11002 # token不合法
CODE_ERROR_TOKEN_NOT_FOUND = 11003 # token或用户uuid未找到
CODE_ERROR_TOKEN_CACHE_FAIL = 11004 # token缓存失败

CODE_ERROR_IMAGE_SERVICE_ERROR = 12000 # 上传图片服务错误
CODE_ERROR_IMAGE_UNSUPPORTED_TYPE = 12001 #不支持的图片类型，仅仅支持JPG、GIF、PNG
CODE_ERROR_IMAGE_TOO_LARGE = 12002 # 图片太大
CODE_ERROR_IMAGE_DOSE_NOT_MULTIPART = 12003 # 请确保使用multpart上传图片
CODE_ERROR_IMAGE_NUMBER_TOO_MANY = 12004 # 上传图片超过指定数量


MESSAGE = {
    CODE_SUCCESS : "请求成功",

    CODE_ERROR_SYSTEM : "系统错误",
    CODE_ERROR_SERVICE : "服务错误",
    CODE_ERROR_PARAM : "参数错误",
    CODE_ERROR_BUSY : "系统繁忙错误",
    CODE_ERROR_PERMISSION : "权限错误",
    CODE_ERROR_ILLEGAL_REQUEST : "非法请求错误",
    CODE_ERROR_INVALID_USER : "不合法用户",
    CODE_ERROR_MISS_PARAM : "缺少参数",
    CODE_ERROR_REQUEST_TOO_MANY : "请求次数过多",

    CODE_ERROR_USER_EXISTS : "用户已存在",
    CODE_ERROR_USER_NOT_EXISTS : "用户不存在",
    CODE_ERROR_CONTENT_IS_NULL : "内容为空",
    CODE_ERROR_TEXT_TOO_LONG : "输入文字太长，请确认不超过XXX个字符",
    CODE_ERROR_OUT_OF_LIMIT : "发布内容过于频繁",
    CODE_ERROR_CONTAIN_ILLEGAL_WEBSITE : "包含非法网址",
    CODE_ERROR_CONTAIN_ADVERTISING : "包含非法内容",
    CODE_ERROR_TEST_AND_VERIFY : "需要验证码",
    CODE_ERROR_SUCCESS_BUT_NEED_WAIT : "发布成功，目前服务器可能会有延迟，请耐心等待1-2分钟",
    CODE_ERROR_ILLEGAL_COMMENT : "不合法的评论",
    CODE_ERROR_ILLEGAL_JOURNAL : "不合法的日志",
    CODE_ERROR_ILLEGAL_NICKNAME : "不合法的昵称",
    CODE_ERROR_THE_PHONE_HAS_BE_USED : "该手机号已经被使用",
    CODE_ERROR_THE_ACCOUNT_HAS_BEAN_BIND_PHONE : "该用户已经绑定手机",
    CODE_ERROR_WRONG_VERIFIER : " Verifier错误",
    CODE_ERROR_AUTH_FAILD : "认证失败",
    CODE_ERROR_PHONE_OR_PASSWORD_ERROR : "手机或密码错误",
    CODE_ERROR_EMAIL_OR_PASSWORD_ERROR : "邮箱或密码错误",
    CODE_ERROR_CONTAINS_FORBID_WORLD : "含有敏感词",
    CODE_ERROR_VERSION_REJECTED : "版本号错误",
    CODE_ERROR_VERIFY_CODE_OUTDATE : "验证码过期",
    CODE_ERROR_THE_EMAIL_HAS_BE_USED : "该邮箱已经被使用",
    CODE_ERROR_PASSWORD_ERROR : "密码错误",
    CODE_ERROR_ILLEGAL_TAG_CONTENT : "列表字符格式错误",
    CODE_ERROR_ILLEGAL_DATA_CONTENT : "数据格式错误",
    CODE_ERROR_ONLY_FOR_EMAIL : "暂时只支持邮箱",
    CODE_ERROR_THIDR_ALREAD_BE_BIND : "该第三方帐号已被绑定",

    CODE_ERROR_TOKEN_USED : "token已经被使用",
    CODE_ERROR_TOKEN_EXPIRED : "token已经过期",
    CODE_ERROR_TOKEN_REVOKED : "token不合法",
    CODE_ERROR_TOKEN_NOT_FOUND : "token或用户uuid未找到",
    CODE_ERROR_TOKEN_CACHE_FAIL : "token缓存失败",

    CODE_ERROR_IMAGE_SERVICE_ERROR : "上传图片服务错误",
    CODE_ERROR_IMAGE_UNSUPPORTED_TYPE : "不支持的图片类型，仅仅支持JPG、GIF、PNG",
    CODE_ERROR_IMAGE_TOO_LARGE : "图片太大",
    CODE_ERROR_IMAGE_DOSE_NOT_MULTIPART : "请确保使用multpart上传图片",
    CODE_ERROR_IMAGE_NUMBER_TOO_MANY : "上传图片超过指定数量",
}

def PACKAGE_CODE(code, message, data=None):
    return  jsonTool({"code": code, 'message': message, "data":data})

def RESPONSE_JSON(code, data=None):
    return PACKAGE_CODE(code, MESSAGE[code], data)
    


if __name__ == '__main__':
    print MESSAGE
    pass
