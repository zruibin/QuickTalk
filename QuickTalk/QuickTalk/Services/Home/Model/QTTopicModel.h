//
//  QTTopicModel.h
//  QuickTalk
//
//  Created by  Ruibin.Chow on 2017/10/18.
//  Copyright © 2017年 www.creactism.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QTTopicModel : NSObject

@property (nonatomic, copy) NSString *uuid;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *detail;
@property (nonatomic, copy) NSString *href;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, assign) NSInteger _id;


+ (void)requestTopicData:(NSUInteger)page
       completionHandler:(void (^)(NSArray<QTTopicModel *> *list, NSError * error))completionHandler;

+ (void)requestTopic:(NSString *)topicUUID
   completionHandler:(void (^)(QTTopicModel *model, NSError * error))completionHandler;

@end
