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

@interface QTMessageListModel: NSObject
@property (nonatomic, copy) NSArray<QTMessageModel *> *data;
@end

@implementation QTMessageListModel
+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"data" : [QTMessageModel class]};
}
@end

@implementation QTMessageModel

+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{@"_id" : @"id", @"contentUUID": @"content_uuid", @"generatedUserUUID": @"generated_user_uuid"};
}

- (NSString *)nickname
{
    if (_nickname.length == 0) {
        _nickname = [NSString stringWithFormat:@"用户%@", self.userId];
    }
    return _nickname;
}

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
                    error = [QTServiceCode error:code message:responseObject[@"message"]];
                }
            } @catch (NSException *exception) {
                ;
            } @finally {
                completionHandler(model, error);
            }
        }
    }];
}


+ (void)requestMessageData:(NSUInteger)page userUUID:(NSString *)userUUID
          completionHandler:(void (^)(NSArray<QTMessageModel *> *list, NSError * error))completionHandler
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[NSNumber numberWithInteger:page] forKey:@"index"];
    if (userUUID.length > 0) {
        [params setObject:userUUID forKey:@"user_uuid"];
    }
//    [params setObject:@"update" forKey:@"update"];
    [QTNetworkAgent requestDataForMessageService:@"/message" method:SERVICE_REQUEST_POST params:[params copy] completionHandler:^(id  _Nullable responseObject, NSError * _Nullable error) {
        if (completionHandler == nil) {
            return;
        }
        if (error) {
            completionHandler(nil, error);
        } else {
            QTMessageListModel *listModel = nil;
            @try {
                NSUInteger code = [responseObject[@"code"] integerValue];
                if (code == CODE_SUCCESS) {
                    listModel = [QTMessageListModel yy_modelWithJSON:responseObject];
                } else {
                    error = [QTServiceCode error:code message:responseObject[@"message"]];
                }
            } @catch (NSException *exception) {
                ;
            } @finally {
                completionHandler(listModel.data, error);
            }
        }
    }];
}

@end
