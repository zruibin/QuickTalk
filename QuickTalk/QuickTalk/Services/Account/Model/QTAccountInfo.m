//
//  QTAccountInfo.m
//  QuickTalk
//
//  Created by  Ruibin.Chow on 2017/12/13.
//  Copyright © 2017年 www.creactism.com. All rights reserved.
//

#import "QTAccountInfo.h"

@implementation QTAccountInfo

+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{@"_id" : @"id"};
}

+ (void)requestLogin:(NSString *)account
                type:(NSString *)type
            password:(NSString *)password
   completionHandler:(void (^)(QTAccountInfo *userInfo, NSError * error))completionHandler
{
    NSDictionary *params = @{@"password": [password md5], @"type": type, @"account": account};
    [QTNetworkAgent requestDataForAccountService:@"/login" method:SERVICE_REQUEST_POST params:params completionHandler:^(id  _Nullable responseObject, NSError * _Nullable error) {
        if (completionHandler == nil) {
            return;
        }
        if (error) {
            completionHandler(nil, error);
        } else {
            QTAccountInfo *userInfo = nil;
            @try {
                NSUInteger code = [responseObject[@"code"] integerValue];
                if (code == CODE_SUCCESS) {
                    userInfo = [QTAccountInfo yy_modelWithJSON:responseObject[@"data"]];
                } else {
                    error = [QTServiceCode error:code];
                }
            } @catch (NSException *exception) {
                ;
            } @finally {
                completionHandler(userInfo, error);
            }
        }
    }];
}

+ (void)requestLoginForThirdPart:(NSString *)openId
                            type:(NSString *)type
               completionHandler:(void (^)(QTAccountInfo *userInfo, NSError * error))completionHandler
{
    NSDictionary *params = @{@"type": type, @"account":openId};
    [QTNetworkAgent requestDataForAccountService:@"/login" method:SERVICE_REQUEST_POST params:params completionHandler:^(id  _Nullable responseObject, NSError * _Nullable error) {
        if (completionHandler == nil) {
            return;
        }
        if (error) {
            completionHandler(nil, error);
        } else {
            QTAccountInfo *userInfo = nil;
            @try {
                NSUInteger code = [responseObject[@"code"] integerValue];
                if (code == CODE_SUCCESS) {
                    userInfo = [QTAccountInfo yy_modelWithJSON:responseObject[@"data"]];
                } else {
                    error = [QTServiceCode error:code];
                }
            } @catch (NSException *exception) {
                ;
            } @finally {
                completionHandler(userInfo, error);
            }
        }
    }];
}

+ (void)requestRegisterUser:(NSString *)account
                   password:(NSString *)password
                       type:(NSString *)type
          completionHandler:(void (^)(QTAccountInfo *accountInfo, NSError * error))completionHandler
{
    if (account.length == 0) account = @"";
    if (password.length == 0) password = @"";
    if (type.length == 0) type = @"";
    NSDictionary *params = @{
                             @"account":account,
                             @"password":[password md5],
                             @"type":type
                             };
    [QTNetworkAgent requestDataForAccountService:@"/register" method:SERVICE_REQUEST_POST params:params completionHandler:^(id  _Nullable responseObject, NSError * _Nullable error) {
        if (completionHandler == nil) {
            return;
        }
        if (error) {
            completionHandler(nil, error);
        } else {
            QTAccountInfo *accountInfo = nil;
            @try {
                NSUInteger code = [responseObject[@"code"] integerValue];
                if (code == CODE_SUCCESS) {
                    accountInfo = [QTAccountInfo yy_modelWithJSON:responseObject[@"data"]];
                } else {
                    error = [QTServiceCode error:code];
                }
            } @catch (NSException *exception) {
                ;
            } @finally {
                completionHandler(accountInfo, error);
            }
        }
    }];
}

+ (void)requestForgetPassword:(NSString *)account
                         type:(NSString *)type
                     password:(NSString *)password
            completionHandler:(void (^)(BOOL action, NSError * error))completionHandler;
{
    if (account.length == 0) account = @"";
    if (password.length == 0) password = @"";
    if (type.length == 0) type = @"";
    NSDictionary *params = @{
                             @"account":account,
                             @"newpassword":[password md5],
                             @"type":type
                             };
    [QTNetworkAgent requestDataForAccountService:@"/forgetPassword" method:SERVICE_REQUEST_POST params:params completionHandler:^(id  _Nullable responseObject, NSError * _Nullable error) {
        if (completionHandler == nil) {
            return;
        }
        if (error) {
            completionHandler(NO, error);
        } else {
            BOOL action = NO;
            @try {
                NSUInteger code = [responseObject[@"code"] integerValue];
                if (code == CODE_SUCCESS) {
                    action = YES;
                } else {
                    error = [QTServiceCode error:code];
                }
            } @catch (NSException *exception) {
                ;
            } @finally {
                completionHandler(action, error);
            }
        }
    }];
}

@end




