//
//  QTUserInfo.h
//  QuickTalk
//
//  Created by  Ruibin.Chow on 2017/10/20.
//  Copyright © 2017年 www.creactism.com. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const QTRefreshDataNotification;
extern NSString * const QTLoginStatusChangeNotification;

@interface QTUserInfo : NSObject

@property (nonatomic, readonly, getter=isLogin) BOOL loginStatus;
@property (nonatomic, copy, readonly) NSString *_id;
@property (nonatomic, copy, readonly) NSString *uuid;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, assign, readonly) BOOL hiddenData;

+ (instancetype)sharedInstance;

- (void)login:(NSString *)uuid avatar:(NSString *)avatar nickname:(NSString *)nickname;
- (void)logout;
- (void)loginInBackground;
- (BOOL)checkLoginStatus:(UIViewController *)viewController;

- (void)checkingObsolescence;

+ (void)requestLogin:(NSString *)openId
                type:(NSString *)type
              avatar:(NSString *)avatar
            nickName:(NSString *)nickname
   completionHandler:(void (^)(QTUserInfo *userInfo, NSError * error))completionHandler;

+ (void)requestChangeAvatar:(NSString *)userUUID avatarImage:(UIImage *)avatarImage
          completionHandler:(void (^)(NSString *avatar, NSError * error))completionHandler;

+ (void)requestChangeNickName:(NSString *)userUUID nickname:(NSString *)nickname
            completionHandler:(void (^)(BOOL action, NSError * error))completionHandler;
@end
