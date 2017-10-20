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

@end
