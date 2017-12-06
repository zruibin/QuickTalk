//
//  QTUserPostCommentModel.h
//  QuickTalk
//
//  Created by  Ruibin.Chow on 2017/12/6.
//  Copyright © 2017年 www.creactism.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QTUserPostCommentModel : NSObject

@property (nonatomic, assign) NSInteger _id;
@property (nonatomic, copy) NSString *uuid;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *userUUID;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, assign) BOOL isReply;
@property (nonatomic, copy) NSString *replyUUID;
@property (nonatomic, copy) NSString *replyNickname;
@property (nonatomic, copy) NSString *replyContent;


+ (void)requestUserPostCommentData:(NSString *)userpostUUID page:(NSUInteger)page
                 completionHandler:(void (^)(NSArray<QTUserPostCommentModel *> *list, NSError * error))completionHandler;

+ (void)requestForSendComment:(NSString *)userPostUUID
                      content:(NSString *)content
                     userUUID:(NSString *)userUUID
                      isReply:(BOOL)isReply
                    replyUUID:(NSString *)replyUUID
            completionHandler:(void (^)(BOOL action, NSError * error))completionHandler;

@end
