//
//  QTAccountInfo.h
//  QuickTalk
//
//  Created by  Ruibin.Chow on 2017/12/13.
//  Copyright © 2017年 www.creactism.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QTAccountInfo : NSObject

@property (nonatomic, copy) NSString *_id;
@property (nonatomic, copy) NSString *uuid;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *detail;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *qq;
@property (nonatomic, copy) NSString *wechat;
@property (nonatomic, copy) NSString *weibo;
@property (nonatomic, copy) NSString *area;
@property (nonatomic, assign) NSInteger gender;

+ (void)requestLogin:(NSString *)account
                type:(NSString *)type
            password:(NSString *)password
   completionHandler:(void (^)(QTAccountInfo *userInfo, NSError * error))completionHandler;

+ (void)requestLoginForThirdPart:(NSString *)openId
                type:(NSString *)type
   completionHandler:(void (^)(QTAccountInfo *userInfo, NSError * error))completionHandler;

+ (void)requestRegisterUser:(NSString *)account
                   password:(NSString *)password
                       type:(NSString *)type
          completionHandler:(void (^)(QTAccountInfo *accountInfo, NSError * error))completionHandler;

+ (void)requestForgetPassword:(NSString *)account
                         type:(NSString *)type
                     password:(NSString *)password
            completionHandler:(void (^)(BOOL action, NSError * error))completionHandler;

+ (void)requestForChangePassword:(NSString *)userUUID
                     oldpassword:(NSString *)oldpassword
                     newpassword:(NSString *)newpassword
               completionHandler:(void (^)(BOOL action, NSError * error))completionHandler;

+ (void)requestForAccountInfo:(NSString *)userUUID
                     type:(NSString *)type
                     data:(NSString *)data
            completionHandler:(void (^)(BOOL action, NSError * error))completionHandler;

+ (void)requestForThirdPart:(NSString *)userUUID
                       type:(NSString *)type
                     method:(NSString *)method
                     openId:(NSString *)openId
          completionHandler:(void (^)(BOOL action, NSError * error))completionHandler;

+ (void)requestForChangeGender:(NSString *)userUUID
                         gender:(NSString *)gender
            completionHandler:(void (^)(BOOL action, NSError * error))completionHandler;

+ (void)requestForSetting:(NSString *)userUUID
                     type:(NSString *)type
                   status:(NSString *)status
        completionHandler:(void (^)(BOOL action, NSError * error))completionHandler;

+ (void)requestForSettingList:(NSString *)userUUID
            completionHandler:(void (^)(NSDictionary *dict, NSError * error))completionHandler;

@end



