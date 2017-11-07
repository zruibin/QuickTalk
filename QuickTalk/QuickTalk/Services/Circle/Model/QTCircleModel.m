//
//  QTCircleModel.m
//  QuickTalk
//
//  Created by  Ruibin.Chow on 2017/11/7.
//  Copyright © 2017年 www.creactism.com. All rights reserved.
//

#import "QTCircleModel.h"


@interface QTCircleModelList: NSObject
@property (nonatomic, copy) NSArray<QTCircleModel *> *data;
@end

@implementation QTCircleModelList
+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"data" : [QTCircleModel class]};
}
@end


@implementation QTCircleModel

+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{@"_id" : @"id"};
}

+ (void)requestCircleData:(NSUInteger)page userUUID:(NSString *)userUUID
       completionHandler:(void (^)(NSArray<QTCircleModel *> *list, NSError * error))completionHandler
{
    NSDictionary *params = @{@"index": [NSNumber numberWithInteger:page]};
    if (userUUID.length > 0) {
        params = @{
                   @"index": [NSNumber numberWithInteger:page],
                   @"user_uuid": userUUID
                   };
    }
    [QTNetworkAgent requestDataForQuickTalkService:@"/circle/circleList" method:SERVICE_REQUEST_GET params:params completionHandler:^(id  _Nullable responseObject, NSError * _Nullable error) {
        if (completionHandler == nil) {
            return;
        }
        if (error) {
            completionHandler(nil, error);
        } else {
            QTCircleModelList *listModel = nil;
            @try {
                NSUInteger code = [responseObject[@"code"] integerValue];
                if (code == CODE_SUCCESS) {
                    listModel = [QTCircleModelList yy_modelWithJSON:responseObject];
                } else {
                    error = [QTServiceCode error:code];
                }
            } @catch (NSException *exception) {
                ;
            } @finally {
                completionHandler(listModel.data, error);
            }
        }
    }];
}

+ (void)requestForSendCircle:(NSString *)userUUID
                      content:(NSString *)content
            completionHandler:(void (^)(BOOL action, NSError * error))completionHandler
{
    NSDictionary *params = @{@"content":content, @"user_uuid": userUUID};
    [QTNetworkAgent requestDataForQuickTalkService:@"/circle/submitCircle" method:SERVICE_REQUEST_POST params:params completionHandler:^(id  _Nullable responseObject, NSError * _Nullable error) {
        if (completionHandler == nil) {
            return;
        }
        if (error) {
            completionHandler(nil, error);
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

+ (void)requestForDeleteCircle:(NSString *)circleUUID userUUID:(NSString *)userUUID
           completionHandler:(void (^)(BOOL action, NSError * error))completionHandler
{
    NSDictionary *params = @{@"uuid": circleUUID, @"user_uuid": userUUID};
    [QTNetworkAgent requestDataForQuickTalkService:@"/circle/deleteCircle" method:SERVICE_REQUEST_POST params:params completionHandler:^(id  _Nullable responseObject, NSError * _Nullable error) {
        if (completionHandler == nil) {
            return;
        }
        if (error) {
            completionHandler(nil, error);
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

+ (void)requestForLikeCircle:(NSString *)circleUUID
             completionHandler:(void (^)(BOOL action, NSError * error))completionHandler
{
    NSDictionary *params = @{@"circle_uuid": circleUUID};
    [QTNetworkAgent requestDataForQuickTalkService:@"/circle/like" method:SERVICE_REQUEST_POST params:params completionHandler:^(id  _Nullable responseObject, NSError * _Nullable error) {
        if (completionHandler == nil) {
            return;
        }
        if (error) {
            completionHandler(nil, error);
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
