//
//  QTUserPostCommentModel.m
//  QuickTalk
//
//  Created by  Ruibin.Chow on 2017/12/6.
//  Copyright © 2017年 www.creactism.com. All rights reserved.
//

#import "QTUserPostCommentModel.h"

@interface QTUserPostCommentModelList: NSObject
@property (nonatomic, copy) NSArray<QTUserPostCommentModel *> *data;
@end

@implementation QTUserPostCommentModelList
+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"data" : [QTUserPostCommentModel class]};
}
@end


@implementation QTUserPostCommentModel

+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{@"_id" : @"id"};
}

+ (void)requestUserPostCommentData:(NSString *)userpostUUID page:(NSUInteger)page
              completionHandler:(void (^)(NSArray<QTUserPostCommentModel *> *list, NSError * error))completionHandler
{
    NSDictionary *params = @{@"index": [NSNumber numberWithInteger:page], @"userPost_uuid": userpostUUID};
    [QTNetworkAgent requestDataForQuickTalkService:@"/userPost/userPostCommentList" method:SERVICE_REQUEST_GET params:params completionHandler:^(id  _Nullable responseObject, NSError * _Nullable error) {
        if (completionHandler == nil) {
            return;
        }
        if (error) {
            completionHandler(nil, error);
        } else {
            QTUserPostCommentModelList *listModel = nil;
            @try {
                NSUInteger code = [responseObject[@"code"] integerValue];
                if (code == CODE_SUCCESS) {
                    listModel = [QTUserPostCommentModelList yy_modelWithJSON:responseObject];
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

+ (void)requestForSendComment:(NSString *)userPostUUID
                      content:(NSString *)content
                     userUUID:(NSString *)userUUID
                      isReply:(BOOL)isReply
                    replyUUID:(NSString *)replyUUID
            completionHandler:(void (^)(BOOL action, NSError * error))completionHandler
{
    NSMutableDictionary *params = [@{@"userPost_uuid": userPostUUID, @"content":content, @"user_uuid": userUUID} mutableCopy];
    if (isReply) {
        [params setObject:@"1" forKey:@"isReply"];
        [params setObject:replyUUID forKey:@"reply_uuid"];
    }
    [QTNetworkAgent requestDataForQuickTalkService:@"/userPost/addUserPostComment" method:SERVICE_REQUEST_POST params:[params copy] completionHandler:^(id  _Nullable responseObject, NSError * _Nullable error) {
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
