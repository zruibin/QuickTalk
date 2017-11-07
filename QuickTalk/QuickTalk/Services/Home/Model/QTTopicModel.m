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
