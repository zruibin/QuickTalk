//
//  QTUserPostModel.h
//  QuickTalk
//
//  Created by  Ruibin.Chow on 2017/12/5.
//  Copyright © 2017年 www.creactism.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QTUserPostLikeModel : NSObject

@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *userUUID;

@end

@interface QTUserPostModel : NSObject

@property (nonatomic, assign) NSInteger _id;
@property (nonatomic, copy) NSString *uuid;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *userUUID;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *txt;
@property (nonatomic, assign) NSInteger commentCount;
@property (nonatomic, assign) NSInteger readCount;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSArray<QTUserPostLikeModel *> *likeList;
@property (nonatomic, assign) BOOL liked;


+ (void)requestUserPostData:(NSUInteger)page userUUID:(NSString *)userUUID
                relationUserUUID:(NSString *)relationUserUUID
          completionHandler:(void (^)(NSArray<QTUserPostModel *> *list, NSError * error))completionHandler;

+ (void)requestAddUserPost:(NSString *)userUUID
                     title:(NSString *)title
                   content:(NSString *)content
                       txt:(NSString *)txt
         completionHandler:(void (^)(BOOL action, NSError * error))completionHandler;

+ (void)requestDeleteUserPost:(NSString *)userUUID
                 userPostUUID:(NSString *)userPostUUID
            completionHandler:(void (^)(BOOL action, NSError * error))completionHandler;

+ (void)requestAddUserPostReadCount:(NSString *)userPostUUID
                  completionHandler:(void (^)(BOOL action, NSError * error))completionHandler;

+ (void)requestUserCollectionAction:(NSString *)userPostUUID
                           userUUID:(NSString *)userUUID
                            action:(NSString *)action
                  completionHandler:(void (^)(BOOL action, NSError * error))completionHandler;

+ (void)requestCollectionData:(NSUInteger)page userUUID:(NSString *)userUUID
                type:(NSString *)type
          completionHandler:(void (^)(NSArray<QTUserPostModel *> *list, NSError * error))completionHandler;

+ (void)requestForUserPostLikeOrUnLike:(NSString *)userUUID
                           contentUUID:(NSString *)contentUUID
                                action:(NSString *)action
                     completionHandler:(void (^)(BOOL action, NSError * error))completionHandler;

+ (void)requestUserForUserPostLikeData:(NSUInteger)page userUUID:(NSString *)userUUID
                        relationUserUUID:(NSString *)relationUserUUID
                     completionHandler:(void (^)(NSArray<QTUserPostModel *> *list, NSError * error))completionHandler;

@end


