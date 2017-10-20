//
//  QTUserInfo.m
//  QuickTalk
//
//  Created by  Ruibin.Chow on 2017/10/20.
//  Copyright © 2017年 www.creactism.com. All rights reserved.
//

#import "QTUserInfo.h"
#import <SAMKeychain.h>
#import "QTInfoController.h"

static NSString * const kQTLoginServiceName = @"com.creactism.QuickTalk/LoginService";
static NSString * const kQTLoginUUID = @"QTLoginUUID";
static NSString * const kQTLoginAvatar = @"QTLoginAvatar";

@interface QTUserInfo ()

@property (nonatomic, readwrite, getter=isLogin) BOOL loginStatus;
@property (nonatomic, copy, readwrite) NSString *uuid;
@property (nonatomic, copy, readwrite) NSString *avatar;

@end


@implementation QTUserInfo

+ (instancetype)sharedInstance
{
    static QTUserInfo *userInfo = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (userInfo == nil) {
            userInfo = [[super allocWithZone:NULL] init];
        }
    });
    return userInfo;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    return [QTUserInfo sharedInstance];
}

- (instancetype)copyWithZone:(struct _NSZone *)zone
{
    return [QTUserInfo sharedInstance];
}

#pragma mark - Public

- (void)login:(NSString *)uuid avatar:(NSString *)avatar
{
    self.uuid = uuid;
    self.avatar = avatar;
    self.loginStatus = YES;
    [SAMKeychain setPassword:uuid forService:kQTLoginServiceName account:kQTLoginUUID];
    [SAMKeychain setPassword:avatar forService:kQTLoginServiceName account:kQTLoginAvatar];
}

- (void)logout
{
    self.loginStatus = NO;
    [SAMKeychain deletePasswordForService:kQTLoginServiceName account:kQTLoginUUID];
    [SAMKeychain deletePasswordForService:kQTLoginServiceName account:kQTLoginAvatar];
}

- (void)loginInBackground
{
    NSString *uuid = [SAMKeychain passwordForService:kQTLoginServiceName account:kQTLoginUUID];
    NSString *avatar = [SAMKeychain passwordForService:kQTLoginServiceName account:kQTLoginAvatar];
    if (uuid.length > 0) {
        [self login:uuid avatar:avatar];
    }
}


- (BOOL)checkLoginStatus:(UIViewController *)viewController
{
    if (self.loginStatus == NO) {
        QTInfoController *loginController = [QTInfoController new];
        QTNavigationController *nav = [[QTNavigationController alloc] initWithRootViewController:loginController];
        [viewController presentViewController:nav animated:YES completion:nil];
    }
    return self.loginStatus;
}

@end
