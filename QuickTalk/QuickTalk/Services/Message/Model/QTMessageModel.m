//
//  QTMessageModel.m
//  QuickTalk
//
//  Created by  Ruibin.Chow on 2017/12/25.
//  Copyright © 2017年 www.creactism.com. All rights reserved.
//

#import "QTMessageModel.h"

@implementation QTMessageCountModel

@end

@implementation QTMessageModel

+ (void)requestMessageCountData:(NSString *)userUUID
                      type:(NSString *)type
                     completionHandler:(void (^)(QTMessageCountModel *model, NSError * error))completionHandler
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (userUUID.length > 0) {
        [params setObject:userUUID forKey:@"user_uuid"];
    }
    if (type.length > 0) {
        [params setObject:type forKey:@"type"];
    }
    [QTNetworkAgent requestDataForMessageService:@"/count" method:SERVICE_REQUEST_POST params:[params copy] completionHandler:^(id  _Nullable responseObject, NSError * _Nullable error) {
        if (completionHandler == nil) {
            return;
        }
        if (error) {
            completionHandler(nil, error);
        } else {
            QTMessageCountModel *model = nil;
            @try {
                NSUInteger code = [responseObject[@"code"] integerValue];
                if (code == CODE_SUCCESS) {
                    model = [QTMessageCountModel yy_modelWithJSON:responseObject[@"data"]];
                } else {
                    error = [QTServiceCode error:code];
                }
            } @catch (NSException *exception) {
                ;
            } @finally {
                completionHandler(model, error);
            }
        }
    }];
}

@end
