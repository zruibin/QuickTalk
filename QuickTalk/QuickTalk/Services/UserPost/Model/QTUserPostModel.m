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


@implementation QTUserPostLikeModel
- (NSString *)nickname
{
    if (_nickname.length == 0) {
        _nickname = [NSString stringWithFormat:@"用户%@", self.userId];
    }
    return _nickname;
}
@end

@implementation QTUserPostModel

+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{@"_id" : @"id"};
}

+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"likeList" : [QTUserPostLikeModel class]};
}

- (NSString *)nickname
{
    if (_nickname.length == 0) {
        _nickname = [NSString stringWithFormat:@"用户%ld", self.userId];
    }
    return _nickname;
}


+ (void)requestUserPostData:(NSUInteger)page userUUID:(NSString *)userUUID
           relationUserUUID:(NSString *)relationUserUUID
       completionHandler:(void (^)(NSArray<QTUserPostModel *> *list, NSError * error))completionHandler
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[NSNumber numberWithInteger:page] forKey:@"index"];
    if (relationUserUUID.length > 0) {
        [params setObject:relationUserUUID forKey:@"relation_user_uuid"];
    }
    if (userUUID.length > 0) {
        [params setObject:userUUID forKey:@"user_uuid"];
    }
    [QTNetworkAgent requestDataForUserPostService:@"/userPostList" method:SERVICE_REQUEST_GET params:[params copy] completionHandler:^(id  _Nullable responseObject, NSError * _Nullable error) {
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

+ (void)requestStarUserPostData:(NSUInteger)page userUUID:(NSString *)userUUID
           relationUserUUID:(NSString *)relationUserUUID
          completionHandler:(void (^)(NSArray<QTUserPostModel *> *list, NSError * error))completionHandler
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[NSNumber numberWithInteger:page] forKey:@"index"];
    if (relationUserUUID.length > 0) {
        [params setObject:relationUserUUID forKey:@"relation_user_uuid"];
    }
    if (userUUID.length > 0) {
        [params setObject:userUUID forKey:@"user_uuid"];
    }
    [QTNetworkAgent requestDataForUserPostService:@"/starUserPostList" method:SERVICE_REQUEST_GET params:[params copy] completionHandler:^(id  _Nullable responseObject, NSError * _Nullable error) {
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
    [QTNetworkAgent requestDataForUserPostService:@"/addUserPost" method:SERVICE_REQUEST_POST params:params completionHandler:^(id  _Nullable responseObject, NSError * _Nullable error) {
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
                    error = [QTServiceCode error:code message:responseObject[@"message"]];
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
    [QTNetworkAgent requestDataForUserPostService:@"/deleteUserPost" method:SERVICE_REQUEST_POST params:params completionHandler:^(id  _Nullable responseObject, NSError * _Nullable error) {
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
                    error = [QTServiceCode error:code message:responseObject[@"message"]];
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
    [QTNetworkAgent requestDataForUserPostService:@"/addReadCount" method:SERVICE_REQUEST_POST params:params completionHandler:^(id  _Nullable responseObject, NSError * _Nullable error) {
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
                    error = [QTServiceCode error:code message:responseObject[@"message"]];
                }
            } @catch (NSException *exception) {
                ;
            } @finally {
                completionHandler(action, error);
            }
        }
    }];
}

+ (void)requestUserCollectionAction:(NSString *)userPostUUID
                           userUUID:(NSString *)userUUID
                             action:(NSString *)action
                  completionHandler:(void (^)(BOOL action, NSError * error))completionHandler
{
    NSDictionary *params = @{@"content_uuid":userPostUUID, @"user_uuid":userUUID, @"action": action, @"type": @"1"};
    [QTNetworkAgent requestDataForCollectionService:@"/action" method:SERVICE_REQUEST_POST params:params completionHandler:^(id  _Nullable responseObject, NSError * _Nullable error) {
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
                    error = [QTServiceCode error:code message:responseObject[@"message"]];
                }
            } @catch (NSException *exception) {
                ;
            } @finally {
                completionHandler(action, error);
            }
        }
    }];
}

+ (void)requestCollectionData:(NSUInteger)page userUUID:(NSString *)userUUID
                         type:(NSString *)type
            completionHandler:(void (^)(NSArray<QTUserPostModel *> *list, NSError * error))completionHandler
{
    NSDictionary *params = @{
                             @"index": [NSNumber numberWithInteger:page],
                             @"user_uuid": userUUID,
                             @"type": type
                             };
    [QTNetworkAgent requestDataForCollectionService:@"/list" method:SERVICE_REQUEST_GET params:params completionHandler:^(id  _Nullable responseObject, NSError * _Nullable error) {
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

+ (void)requestForUserPostLikeOrUnLike:(NSString *)userUUID
                   contentUUID:(NSString *)contentUUID
                        action:(NSString *)action
             completionHandler:(void (^)(BOOL action, NSError * error))completionHandler
{
    NSDictionary *params = @{@"action": action, @"content_uuid":contentUUID, @"user_uuid": userUUID, @"type":@"2"};
    [QTNetworkAgent requestDataForLikeService:@"/like" method:SERVICE_REQUEST_POST params:params completionHandler:^(id  _Nullable responseObject, NSError * _Nullable error) {
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
                    error = [QTServiceCode error:code message:responseObject[@"message"]];
                }
            } @catch (NSException *exception) {
                ;
            } @finally {
                completionHandler(action, error);
            }
        }
    }];
}

+ (void)requestUserForUserPostLikeData:(NSUInteger)page userUUID:(NSString *)userUUID
                relationUserUUID:(NSString *)relationUserUUID
          completionHandler:(void (^)(NSArray<QTUserPostModel *> *list, NSError * error))completionHandler
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[NSNumber numberWithInteger:page] forKey:@"index"];
    [params setObject:@"2" forKey:@"type"];
    if (userUUID.length > 0) {
        [params setObject:userUUID forKey:@"user_uuid"];
    }
    if (relationUserUUID.length > 0) {
        [params setObject:relationUserUUID forKey:@"relation_user_uuid"];
    }
    [QTNetworkAgent requestDataForLikeService:@"/likeList" method:SERVICE_REQUEST_GET params:[params copy] completionHandler:^(id  _Nullable responseObject, NSError * _Nullable error) {
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
