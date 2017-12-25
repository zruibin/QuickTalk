//
//  QTMessageModel.h
//  QuickTalk
//
//  Created by  Ruibin.Chow on 2017/12/25.
//  Copyright © 2017年 www.creactism.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QTMessageCountModel : NSObject

@property (nonatomic, assign) NSInteger count;
@property (nonatomic, copy) NSString *type;

@end

@interface QTMessageModel : NSObject

@property (nonatomic, assign) NSInteger _id;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, copy) NSString *userPostUUID;
@property (nonatomic, copy) NSString *userUUID;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *generatedUserUUID;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *contentUUID;
@property (nonatomic, copy) NSString *content;


+ (void)requestMessageCountData:(NSString *)userUUID
                           type:(NSString *)type
              completionHandler:(void (^)(QTMessageCountModel *model, NSError * error))completionHandler;

+ (void)requestMessageData:(NSUInteger)page userUUID:(NSString *)userUUID
          completionHandler:(void (^)(NSArray<QTMessageModel *> *list, NSError * error))completionHandler;

@end
