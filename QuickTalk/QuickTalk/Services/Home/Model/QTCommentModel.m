//
//  QTCommentModel.m
//  QuickTalk
//
//  Created by  Ruibin.Chow on 2017/10/20.
//  Copyright © 2017年 www.creactism.com. All rights reserved.
//

#import "QTCommentModel.h"

@interface QTCommentModelList: NSObject
@property (nonatomic, copy) NSArray<QTCommentModel *> *data;
@end

@implementation QTCommentModelList
+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"data" : [QTCommentModel class]};
}
@end

@implementation QTCommentModel

+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{@"_id" : @"id"};
}

+ (void)requestTopicCommentData:(NSString *)topicUUID page:(NSUInteger)page
       completionHandler:(void (^)(NSArray<QTCommentModel *> *list, NSError * error))completionHandler
{
    NSDictionary *params = @{@"index": [NSNumber numberWithInteger:page], @"topic_uuid": topicUUID};
    [QTNetworkAgent requestDataForQuickTalkService:@"/commentList" method:SERVICE_REQUEST_GET params:params completionHandler:^(id  _Nullable responseObject, NSError * _Nullable error) {
        if (completionHandler == nil) {
            return;
        }
        if (error) {
            completionHandler(nil, error);
        } else {
            QTCommentModelList *listModel = nil;
            @try {
                NSUInteger code = [responseObject[@"code"] integerValue];
                if (code == CODE_SUCCESS) {
                    listModel = [QTCommentModelList yy_modelWithJSON:responseObject];
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

+ (void)requestForSendComment:(NSString *)topicUUID
                      content:(NSString *)content
                     userUUID:(NSString *)userUUID
              completionHandler:(void (^)(BOOL action, NSError * error))completionHandler
{
    NSDictionary *params = @{@"topic_uuid": topicUUID, @"content":content, @"user_uuid": userUUID};
    [QTNetworkAgent requestDataForQuickTalkService:@"/comment" method:SERVICE_REQUEST_POST params:params completionHandler:^(id  _Nullable responseObject, NSError * _Nullable error) {
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

+ (void)requestForAgreeOrDisAgreeComment:(NSString *)uuid
                                  action:(NSString *)action
                       completionHandler:(void (^)(BOOL action, NSError * error))completionHandler
{
    NSDictionary *params = @{@"comment_uuid": uuid, @"action":action};
    [QTNetworkAgent requestDataForQuickTalkService:@"/like" method:SERVICE_REQUEST_POST params:params completionHandler:^(id  _Nullable responseObject, NSError * _Nullable error) {
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
