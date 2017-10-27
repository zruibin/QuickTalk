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
NSString * const QTRefreshDataNotification = @"kkQTRefreshDataNotification";

static NSDate *refreshDate = nil;

@interface QTUserInfo ()

@property (nonatomic, readwrite, getter=isLogin) BOOL loginStatus;
@property (nonatomic, copy, readwrite) NSString *uuid;
@property (nonatomic, copy, readwrite) NSString *avatar;
@property (nonatomic, assign, readwrite) BOOL hiddenOneClickLogin;

- (void)checkHidden;

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
    self.uuid = nil;
    self.avatar = nil;
}

- (void)loginInBackground
{
    refreshDate = [NSDate date];
    NSString *uuid = [SAMKeychain passwordForService:kQTLoginServiceName account:kQTLoginUUID];
    NSString *avatar = [SAMKeychain passwordForService:kQTLoginServiceName account:kQTLoginAvatar];
    if (uuid.length > 0) {
        [self login:uuid avatar:avatar];
    }
    [self checkHidden];
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

- (void)checkingObsolescence
{
    NSDate *nowDate = [NSDate date];
    NSTimeInterval interval = [nowDate timeIntervalSinceDate:refreshDate];//获取某一时间与当前时间的间隔
    if (interval > 300) {
        [[NSNotificationCenter defaultCenter] postNotificationName:QTRefreshDataNotification object:nil];
        refreshDate = [NSDate date];
    }
}

+ (void)requestLogin:(NSString *)openId type:(NSString *)type avatar:(NSString *)avatar
       completionHandler:(void (^)(QTUserInfo *userInfo, NSError * error))completionHandler
{
    NSDictionary *params = @{@"openId": [openId md5], @"type": type, @"avatar": avatar};
    [QTNetworkAgent requestDataForQuickTalkService:@"/login" method:SERVICE_REQUEST_POST params:params completionHandler:^(id  _Nullable responseObject, NSError * _Nullable error) {
        if (completionHandler == nil) {
            return;
        }
        if (error) {
            completionHandler(nil, error);
        } else {
            QTUserInfo *userInfo = nil;
            @try {
                NSUInteger code = [responseObject[@"code"] integerValue];
                if (code == CODE_SUCCESS) {
                    userInfo = [QTUserInfo yy_modelWithJSON:responseObject[@"data"]];
                } else {
                    error = [QTServiceCode error:code];
                }
            } @catch (NSException *exception) {
                ;
            } @finally {
                completionHandler(userInfo, error);
            }
        }
    }];
}

#pragma mark - Private

- (void)checkHidden
{
    [QTNetworkAgent requestDataForQuickTalkService:@"/hidden" method:SERVICE_REQUEST_POST params:nil completionHandler:^(id  _Nullable responseObject, NSError * _Nullable error) {
        if (error == nil) {
            BOOL action = NO;
            @try {
                NSUInteger code = [responseObject[@"code"] integerValue];
                if (code == CODE_SUCCESS) {
                    action = [responseObject[@"data"][@"hidden"] boolValue];;
                } else {
                    error = [QTServiceCode error:code];
                }
            } @catch (NSException *exception) {
                ;
            } @finally {
                self.hiddenOneClickLogin = action;
            }
        }
    }];
}

@end
