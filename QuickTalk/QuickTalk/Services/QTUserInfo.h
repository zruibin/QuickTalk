//
//  QTUserInfo.h
//  QuickTalk
//
//  Created by  Ruibin.Chow on 2017/10/20.
//  Copyright © 2017年 www.creactism.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QTUserInfo : NSObject

@property (nonatomic, readonly, getter=isLogin) BOOL loginStatus;
@property (nonatomic, copy, readonly) NSString *uuid;
@property (nonatomic, copy, readonly) NSString *avatar;
@property (nonatomic, assign, readonly) BOOL hiddenOneClickLogin;

+ (instancetype)sharedInstance;

- (void)login:(NSString *)uuid avatar:(NSString *)avatar;
- (void)logout;
- (void)loginInBackground;
- (BOOL)checkLoginStatus:(UIViewController *)viewController;

@end
