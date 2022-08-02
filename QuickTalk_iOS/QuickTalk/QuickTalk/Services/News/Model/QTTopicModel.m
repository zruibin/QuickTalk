//
//  QTTopicModel.m
//  QuickTalk
//
//  Created by  Ruibin.Chow on 2017/10/18.
//  Copyright © 2017年 www.creactism.com. All rights reserved.
//

#import "QTTopicModel.h"

@interface QTTopicModelList: NSObject
@property (nonatomic, copy) NSArray<QTTopicModel *> *data;
@end

@implementation QTTopicModelList
+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"data" : [QTTopicModel class]};
}
@end


@implementation QTTopicModel

+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{@"_id" : @"id"};
}


+ (void)requestTopicData:(NSUInteger)page
          completionHandler:(void (^)(NSArray<QTTopicModel *> *list, NSError * error))completionHandler
{
    NSDictionary *params = @{@"index": [NSNumber numberWithInteger:page]};
    [QTNetworkAgent requestDataForQuickTalkService:@"/topicList" method:SERVICE_REQUEST_GET params:params completionHandler:^(id  _Nullable responseObject, NSError * _Nullable error) {
        if (completionHandler == nil) {
            return;
        }
        if (error) {
            completionHandler(nil, error);
        } else {
            QTTopicModelList *listModel = nil;
            @try {
                NSUInteger code = [responseObject[@"code"] integerValue];
                if (code == CODE_SUCCESS) {
                    listModel = [QTTopicModelList yy_modelWithJSON:responseObject];
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

+ (void)requestTopic:(NSString *)topicUUID
   completionHandler:(void (^)(QTTopicModel *model, NSError * error))completionHandler
{
    NSDictionary *params = @{@"topic_uuid": topicUUID};
    [QTNetworkAgent requestDataForQuickTalkService:@"/topic" method:SERVICE_REQUEST_GET params:params completionHandler:^(id  _Nullable responseObject, NSError * _Nullable error) {
        if (completionHandler == nil) {
            return;
        }
        if (error) {
            completionHandler(nil, error);
        } else {
            QTTopicModel *model = nil;
            QTTopicModelList *listModel = nil;
            @try {
                NSUInteger code = [responseObject[@"code"] integerValue];
                if (code == CODE_SUCCESS) {
                    listModel = [QTTopicModelList yy_modelWithJSON:responseObject];
                    if (listModel.data.count > 0) {
                        model = listModel.data[0];
                    }
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

+ (void)requestTopicContent:(NSString *)topicUUID
          completionHandler:(void (^)(NSString *content, NSError * error))completionHandler
{
    NSDictionary *params = @{@"topic_uuid": topicUUID};
    [QTNetworkAgent requestDataForQuickTalkService:@"/topicContent" method:SERVICE_REQUEST_GET params:params completionHandler:^(id  _Nullable responseObject, NSError * _Nullable error) {
        if (completionHandler == nil) {
            return;
        }
        if (error) {
            completionHandler(nil, error);
        } else {
            NSString *content = nil;
        
            @try {
                NSUInteger code = [responseObject[@"code"] integerValue];
                if (code == CODE_SUCCESS) {
                    content = responseObject[@"data"][@"content"];
                } else {
                    error = [QTServiceCode error:code message:responseObject[@"message"]];
                }
            } @catch (NSException *exception) {
                ;
            } @finally {
                completionHandler(content, error);
            }
        }
    }];
}

+ (void)requestAddTopicReadCount:(NSString *)topicUUID
                  completionHandler:(void (^)(BOOL action, NSError * error))completionHandler
{
    NSDictionary *params = @{@"topic_uuid":topicUUID};
    [QTNetworkAgent requestDataForQuickTalkService:@"/updateReadCount" method:SERVICE_REQUEST_POST params:params completionHandler:^(id  _Nullable responseObject, NSError * _Nullable error) {
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

@end
