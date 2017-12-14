//
//  QTUserModel.m
//  QuickTalk
//
//  Created by  Ruibin.Chow on 2017/12/14.
//  Copyright © 2017年 www.creactism.com. All rights reserved.
//

#import "QTUserModel.h"

@implementation QTUserModel

+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{@"_id" : @"id"};
}

+ (void)requestUserInfo:(NSString *)userUUID
          completionHandler:(void (^)(QTUserModel *userModel, NSError * error))completionHandler
{
    NSDictionary *params = @{@"user_uuid": userUUID};
    [QTNetworkAgent requestDataForAccountService:@"/info" method:SERVICE_REQUEST_GET params:params completionHandler:^(id  _Nullable responseObject, NSError * _Nullable error) {
        if (completionHandler == nil) {
            return;
        }
        if (error) {
            completionHandler(nil, error);
        } else {
            QTUserModel *userInfo = nil;
            @try {
                NSUInteger code = [responseObject[@"code"] integerValue];
                if (code == CODE_SUCCESS) {
                    userInfo = [QTUserModel yy_modelWithJSON:responseObject[@"data"]];
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

@end
