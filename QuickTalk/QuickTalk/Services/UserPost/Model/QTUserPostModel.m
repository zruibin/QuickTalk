//
//  QTUserPostModel.m
//  QuickTalk
//
//  Created by  Ruibin.Chow on 2017/12/5.
//  Copyright © 2017年 www.creactism.com. All rights reserved.
//

#import "QTUserPostModel.h"

@interface QTUserPostModelList: NSObject
@property (nonatomic, copy) NSArray<QTUserPostModel *> *data;
@end

@implementation QTUserPostModelList
+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"data" : [QTUserPostModel class]};
}
@end


@implementation QTUserPostModel

+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{@"_id" : @"id"};
}


+ (void)requestUserPostData:(NSUInteger)page userUUID:(NSString *)userUUID
       completionHandler:(void (^)(NSArray<QTUserPostModel *> *list, NSError * error))completionHandler
{
    NSDictionary *params = @{@"index": [NSNumber numberWithInteger:page]};
    if (userUUID.length > 0) {
        params = @{
                   @"index": [NSNumber numberWithInteger:page],
                   @"user_uuid": userUUID
                   };
    }
    [QTNetworkAgent requestDataForQuickTalkService:@"/userPost/userPostList" method:SERVICE_REQUEST_GET params:params completionHandler:^(id  _Nullable responseObject, NSError * _Nullable error) {
        if (completionHandler == nil) {
            return;
        }
        if (error) {
            completionHandler(nil, error);
        } else {
            QTUserPostModelList *listModel = nil;
            @try {
                NSUInteger code = [responseObject[@"code"] integerValue];
                if (code == CODE_SUCCESS) {
                    listModel = [QTUserPostModelList yy_modelWithJSON:responseObject];
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


+ (void)requestAddUserPost:(NSString *)userUUID
                                  title:(NSString *)title
                                    content:(NSString *)content
                                    txt:(NSString *)txt
                       completionHandler:(void (^)(BOOL action, NSError * error))completionHandler
{
    NSMutableDictionary *params = [@{@"user_uuid": userUUID, @"title":title, @"content": content} mutableCopy];
    if (txt.length > 0) {
        [params setObject:txt forKey:@"txt"];
    }
    [QTNetworkAgent requestDataForQuickTalkService:@"/userPost/addUserPost" method:SERVICE_REQUEST_POST params:params completionHandler:^(id  _Nullable responseObject, NSError * _Nullable error) {
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

+ (void)requestDeleteUserPost:(NSString *)userUUID
                     userPostUUID:(NSString *)userPostUUID
         completionHandler:(void (^)(BOOL action, NSError * error))completionHandler
{
    NSDictionary *params = @{@"user_uuid": userUUID, @"userPost_uuid":userPostUUID};
    [QTNetworkAgent requestDataForQuickTalkService:@"/userPost/deleteUserPost" method:SERVICE_REQUEST_POST params:params completionHandler:^(id  _Nullable responseObject, NSError * _Nullable error) {
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

+ (void)requestAddUserPostReadCount:(NSString *)userPostUUID
            completionHandler:(void (^)(BOOL action, NSError * error))completionHandler
{
    NSDictionary *params = @{@"uuid":userPostUUID};
    [QTNetworkAgent requestDataForQuickTalkService:@"/userPost/addReadCount" method:SERVICE_REQUEST_POST params:params completionHandler:^(id  _Nullable responseObject, NSError * _Nullable error) {
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
