//
//  QTCommentModel.h
//  QuickTalk
//
//  Created by  Ruibin.Chow on 2017/10/20.
//  Copyright © 2017年 www.creactism.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QTCommentModel : NSObject

@property (nonatomic, assign) NSInteger *_id;
@property (nonatomic, copy) NSString *uuid;
@property (nonatomic, copy) NSString *userUUID;
@property (nonatomic, copy) NSString *topicUUID;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, assign) NSInteger like;
@property (nonatomic, assign) NSInteger dislike;

+ (void)requestTopicCommentData:(NSString *)topicUUID page:(NSUInteger)page
              completionHandler:(void (^)(NSArray<QTCommentModel *> *list, NSError * error))completionHandler;

+ (void)requestForSendComment:(NSString *)topicUUID
                      content:(NSString *)content
                     userUUID:(NSString *)userUUID
            completionHandler:(void (^)(BOOL action, NSError * error))completionHandler;

+ (void)requestForAgreeOrDisAgreeComment:(NSString *)uuid
                                   action:(NSString *)action
                        completionHandler:(void (^)(BOOL action, NSError * error))completionHandler;

@end
