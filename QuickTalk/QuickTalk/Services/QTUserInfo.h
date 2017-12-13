//
//  QTUserInfo.h
//  QuickTalk
//
//  Created by  Ruibin.Chow on 2017/10/20.
//  Copyright © 2017年 www.creactism.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class QTAccountInfo;

extern NSString * const QTRefreshDataNotification;
extern NSString * const QTLoginStatusChangeNotification;

@interface QTUserInfo : NSObject

@property (nonatomic, readonly, getter=isLogin) BOOL loginStatus;
@property (nonatomic, assign, readonly) BOOL hiddenData;

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

+ (instancetype)sharedInstance;

- (void)login:(QTAccountInfo *)userInfo password:(NSString *)password type:(NSString *)type;
- (void)loginWithThirdPart:(QTAccountInfo *)userInfo openId:(NSString *)openId type:(NSString *)type;
- (void)logout;
- (void)loginInBackground;
- (BOOL)checkLoginStatus:(UIViewController *)viewController;

- (void)checkingObsolescence;

+ (void)requestChangeAvatar:(NSString *)userUUID avatarImage:(UIImage *)avatarImage
          completionHandler:(void (^)(NSString *avatar, NSError * error))completionHandler;

+ (void)requestChangeNickName:(NSString *)userUUID nickname:(NSString *)nickname
            completionHandler:(void (^)(BOOL action, NSError * error))completionHandler;



@end
