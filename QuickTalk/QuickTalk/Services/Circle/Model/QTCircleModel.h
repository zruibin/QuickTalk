//
//  QTCircleModel.h
//  QuickTalk
//
//  Created by  Ruibin.Chow on 2017/11/7.
//  Copyright © 2017年 www.creactism.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QTCircleModel : NSObject

@property (nonatomic, copy) NSString *_id;
@property (nonatomic, copy) NSString *uuid;
@property (nonatomic, copy) NSString *userUUID;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, assign) NSInteger like;

+ (void)requestCircleData:(NSUInteger)page userUUID:(NSString *)userUUID
        completionHandler:(void (^)(NSArray<QTCircleModel *> *list, NSError * error))completionHandler;

+ (void)requestForSendCircle:(NSString *)userUUID
                     content:(NSString *)content
           completionHandler:(void (^)(BOOL action, NSError * error))completionHandler;

+ (void)requestForDeleteCircle:(NSString *)circleUUID userUUID:(NSString *)userUUID
             completionHandler:(void (^)(BOOL action, NSError * error))completionHandler;

+ (void)requestForLikeCircle:(NSString *)circleUUID
           completionHandler:(void (^)(BOOL action, NSError * error))completionHandler;

@end




