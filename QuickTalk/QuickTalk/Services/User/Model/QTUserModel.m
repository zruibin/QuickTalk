//
//  QTUserModel.m
//  QuickTalk
//
//  Created by  Ruibin.Chow on 2017/12/14.
//  Copyright © 2017年 www.creactism.com. All rights reserved.
//

#import "QTUserModel.h"

@interface QTUserListModel: NSObject
@property (nonatomic, copy) NSArray<QTUserModel *> *data;
@end

@implementation QTUserListModel
+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"data" : [QTUserModel class]};
}
@end


@implementation QTUserModel

+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{@"_id" : @"id", @"relationStatus":@"relation"};
}

- (NSString *)nickname
{
    if (_nickname.length == 0) {
        _nickname = [NSString stringWithFormat:@"用户%@", self._id];
    }
    return _nickname;
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

+ (void)requestPhoneUserData:(NSString *)userUUID phones:(NSArray *)phones
           completionHandler:(void (^)(NSArray<QTUserModel *> *list, NSError * error))completionHandler
{
    NSString *phoneListString = [Tools dataTojsonString:phones];;
    NSDictionary *params = @{@"user_uuid": userUUID, @"phoneList": phoneListString};
    [QTNetworkAgent requestDataForUserService:@"/phoneListUsers" method:SERVICE_REQUEST_POST params:params completionHandler:^(id  _Nullable responseObject, NSError * _Nullable error) {
        if (completionHandler == nil) {
            return;
        }
        if (error) {
            completionHandler(nil, error);
        } else {
            QTUserListModel *list = nil;
            @try {
                NSUInteger code = [responseObject[@"code"] integerValue];
                if (code == CODE_SUCCESS) {
                    list = [QTUserListModel yy_modelWithJSON:responseObject];
                } else {
                    error = [QTServiceCode error:code];
                }
            } @catch (NSException *exception) {
                ;
            } @finally {
                completionHandler(list.data, error);
            }
        }
    }];
}

+ (void)requestStarRelation:(NSString *)userUUID uuidList:(NSArray *)uuidList
          completionHandler:(void (^)(NSDictionary *dict, NSError * error))completionHandler
{
    NSString *uuidListString = [Tools dataTojsonString:uuidList];;
    NSDictionary *params = @{@"user_uuid": userUUID, @"uuidList": uuidListString};
    [QTNetworkAgent requestDataForStarService:@"/queryStarUserRelation" method:SERVICE_REQUEST_POST params:params completionHandler:^(id  _Nullable responseObject, NSError * _Nullable error) {
        if (completionHandler == nil) {
            return;
        }
        if (error) {
            completionHandler(nil, error);
        } else {
            NSDictionary *tempDict = nil;
            @try {
                NSUInteger code = [responseObject[@"code"] integerValue];
                if (code == CODE_SUCCESS) {
                    tempDict = [responseObject[@"data"] copy];
                } else {
                    error = [QTServiceCode error:code];
                }
            } @catch (NSException *exception) {
                ;
            } @finally {
                completionHandler(tempDict, error);
            }
        }
    }];
}

+ (void)requestBeStarRelation:(NSString *)userUUID uuidList:(NSArray *)uuidList
          completionHandler:(void (^)(NSDictionary *dict, NSError * error))completionHandler
{
    NSString *uuidListString = [Tools dataTojsonString:uuidList];;
    NSDictionary *params = @{@"user_uuid": userUUID, @"uuidList": uuidListString};
    [QTNetworkAgent requestDataForStarService:@"/queryBeStarRelation" method:SERVICE_REQUEST_POST params:params completionHandler:^(id  _Nullable responseObject, NSError * _Nullable error) {
        if (completionHandler == nil) {
            return;
        }
        if (error) {
            completionHandler(nil, error);
        } else {
            NSDictionary *tempDict = nil;
            @try {
                NSUInteger code = [responseObject[@"code"] integerValue];
                if (code == CODE_SUCCESS) {
                    tempDict = [responseObject[@"data"] copy];
                } else {
                    error = [QTServiceCode error:code];
                }
            } @catch (NSException *exception) {
                ;
            } @finally {
                completionHandler(tempDict, error);
            }
        }
    }];
}

+ (void)requestForStarOrUnStar:(NSString *)userUUID
                   contentUUID:(NSString *)contentUUID
                        action:(NSString *)action
             completionHandler:(void (^)(BOOL action, NSError * error))completionHandler
{
    NSDictionary *params = @{@"action": action, @"content_uuid":contentUUID, @"user_uuid": userUUID, @"type":@"0"};
    [QTNetworkAgent requestDataForStarService:@"/userAction" method:SERVICE_REQUEST_POST params:params completionHandler:^(id  _Nullable responseObject, NSError * _Nullable error) {
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

+ (void)requestForSearchUser:(NSString *)text page:(NSUInteger)page userUUID:(NSString *)userUUID
           completionHandler:(void (^)(NSArray<QTUserModel *> *list, NSError * error))completionHandler
{
    NSString *uuid = userUUID;
    if (userUUID.length == 0) {
        uuid = @"";
    }
    NSDictionary *params = @{@"text": text, @"index": [NSNumber numberWithInteger:page], @"user_uuid": uuid};
    [QTNetworkAgent requestDataForSearchService:@"/searchUser" method:SERVICE_REQUEST_POST params:params completionHandler:^(id  _Nullable responseObject, NSError * _Nullable error) {
        if (completionHandler == nil) {
            return;
        }
        if (error) {
            completionHandler(nil, error);
        } else {
            QTUserListModel *list = nil;
            @try {
                NSUInteger code = [responseObject[@"code"] integerValue];
                if (code == CODE_SUCCESS) {
                    list = [QTUserListModel yy_modelWithJSON:responseObject];
                } else {
                    error = [QTServiceCode error:code];
                }
            } @catch (NSException *exception) {
                ;
            } @finally {
                completionHandler(list.data, error);
            }
        }
    }];
}

+ (void)requestForStarUser:(NSUInteger)page userUUID:(NSString *)userUUID
            relationUserUUID:(NSString *)relationUserUUID
         completionHandler:(void (^)(NSArray<QTUserModel *> *list, NSError * error))completionHandler
{
    NSString *uuid = userUUID;
    if (userUUID.length == 0) {
        uuid = @"";
    }
    NSDictionary *params = @{
                             @"index": [NSNumber numberWithInteger:page],
                             @"user_uuid": uuid,
                             @"relation_user_uuid": relationUserUUID.length==0?@"":relationUserUUID
                             };
    [QTNetworkAgent requestDataForStarService:@"/queryStarUser" method:SERVICE_REQUEST_POST params:params completionHandler:^(id  _Nullable responseObject, NSError * _Nullable error) {
        if (completionHandler == nil) {
            return;
        }
        if (error) {
            completionHandler(nil, error);
        } else {
            QTUserListModel *list = nil;
            @try {
                NSUInteger code = [responseObject[@"code"] integerValue];
                if (code == CODE_SUCCESS) {
                    list = [QTUserListModel yy_modelWithJSON:responseObject];
                } else {
                    error = [QTServiceCode error:code];
                }
            } @catch (NSException *exception) {
                ;
            } @finally {
                completionHandler(list.data, error);
            }
        }
    }];
}

+ (void)requestForFans:(NSUInteger)page userUUID:(NSString *)userUUID
        relationUserUUID:(NSString *)relationUserUUID
     completionHandler:(void (^)(NSArray<QTUserModel *> *list, NSError * error))completionHandler
{
    NSString *uuid = userUUID;
    if (userUUID.length == 0) {
        uuid = @"";
    }
    NSDictionary *params = @{
                             @"index": [NSNumber numberWithInteger:page],
                             @"user_uuid": uuid,
                             @"relation_user_uuid": relationUserUUID.length==0?@"":relationUserUUID
                             };
    [QTNetworkAgent requestDataForStarService:@"/queryFans" method:SERVICE_REQUEST_POST params:params completionHandler:^(id  _Nullable responseObject, NSError * _Nullable error) {
        if (completionHandler == nil) {
            return;
        }
        if (error) {
            completionHandler(nil, error);
        } else {
            QTUserListModel *list = nil;
            @try {
                NSUInteger code = [responseObject[@"code"] integerValue];
                if (code == CODE_SUCCESS) {
                    list = [QTUserListModel yy_modelWithJSON:responseObject];
                } else {
                    error = [QTServiceCode error:code];
                }
            } @catch (NSException *exception) {
                ;
            } @finally {
                completionHandler(list.data, error);
            }
        }
    }];
}

@end
