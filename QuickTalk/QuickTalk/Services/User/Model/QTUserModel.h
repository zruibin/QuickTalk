//
//  QTUserModel.h
//  QuickTalk
//
//  Created by  Ruibin.Chow on 2017/12/14.
//  Copyright © 2017年 www.creactism.com. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, QTUserRelationStatus) {
    QTUserRelationDefault = 0, //未关注
    QTUserRelationStar = 1, //已关注
    QTUserRelationStarAndBeStar = 2 //相互关注
};

@interface QTUserModel : NSObject

@property (nonatomic, copy) NSString *_id;
@property (nonatomic, copy) NSString *uuid;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *detail;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *qq;
@property (nonatomic, copy) NSString *wechat;
@property (nonatomic, copy) NSString *weibo;
@property (nonatomic, copy) NSString *area;
@property (nonatomic, assign) NSInteger gender;
@property (nonatomic, assign) QTUserRelationStatus relationStatus;


+ (void)requestUserInfo:(NSString *)userUUID
      completionHandler:(void (^)(QTUserModel *userModel, NSError * error))completionHandler;

+ (void)requestPhoneUserData:(NSString *)userUUID phones:(NSArray *)phones
      completionHandler:(void (^)(NSArray<QTUserModel *> *list, NSError * error))completionHandler;

+ (void)requestStarRelation:(NSString *)userUUID uuidList:(NSArray *)uuidList
           completionHandler:(void (^)(NSDictionary *dict, NSError * error))completionHandler;

+ (void)requestBeStarRelation:(NSString *)userUUID uuidList:(NSArray *)uuidList
            completionHandler:(void (^)(NSDictionary *dict, NSError * error))completionHandler;

+ (void)requestForStarOrUnStar:(NSString *)userUUID
                      contentUUID:(NSString *)contentUUID
                     action:(NSString *)action
            completionHandler:(void (^)(BOOL action, NSError * error))completionHandler;

@end



