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
static NSString * const kQTLoginNickName = @"QTLoginNickName";
NSString * const QTRefreshDataNotification = @"kkQTRefreshDataNotification";

static NSDate *refreshDate = nil;

@interface QTUserInfo ()

@property (nonatomic, readwrite, getter=isLogin) BOOL loginStatus;
@property (nonatomic, copy, readwrite) NSString *_id;
@property (nonatomic, copy, readwrite) NSString *uuid;
@property (nonatomic, assign, readwrite) BOOL hiddenOneClickLogin;

- (void)checkHidden;

@end


@implementation QTUserInfo

+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{@"_id" : @"id"};
}

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

- (void)login:(NSString *)uuid avatar:(NSString *)avatar nickname:(NSString *)nickname
{
    self.uuid = uuid;
    self.avatar = avatar;
    self.nickname = nickname;
    self.loginStatus = YES;
    [SAMKeychain setPassword:uuid forService:kQTLoginServiceName account:kQTLoginUUID];
    [SAMKeychain setPassword:avatar forService:kQTLoginServiceName account:kQTLoginAvatar];
    [SAMKeychain setPassword:nickname forService:kQTLoginServiceName account:kQTLoginNickName];
}

- (void)logout
{
    self.loginStatus = NO;
    [SAMKeychain deletePasswordForService:kQTLoginServiceName account:kQTLoginUUID];
    [SAMKeychain deletePasswordForService:kQTLoginServiceName account:kQTLoginAvatar];
    [SAMKeychain deletePasswordForService:kQTLoginServiceName account:kQTLoginNickName];
    self.uuid = nil;
    self.avatar = nil;
}

- (void)loginInBackground
{
    refreshDate = [NSDate date];
    NSString *uuid = [SAMKeychain passwordForService:kQTLoginServiceName account:kQTLoginUUID];
    NSString *avatar = [SAMKeychain passwordForService:kQTLoginServiceName account:kQTLoginAvatar];
    NSString *nickname = [SAMKeychain passwordForService:kQTLoginServiceName account:kQTLoginNickName];
    if (uuid.length > 0) {
        [self login:uuid avatar:avatar nickname:nickname];
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

+ (void)requestLogin:(NSString *)openId
                type:(NSString *)type
              avatar:(NSString *)avatar
            nickName:(NSString *)nickname
   completionHandler:(void (^)(QTUserInfo *userInfo, NSError * error))completionHandler
{
    NSDictionary *params = @{@"openId": [openId md5], @"type": type, @"avatar": avatar, @"nickname": nickname};
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
                if (userInfo.nickname.length == 0) {
                    userInfo.nickname = nickname;
                }
                completionHandler(userInfo, error);
            }
        }
    }];
}

+ (void)requestChangeAvatar:(NSString *)userUUID avatarImage:(UIImage *)avatarImage
          completionHandler:(void (^)(NSString *avatar, NSError * error))completionHandler
{
    if (userUUID.length == 0) {
        userUUID = @"";
    }
    NSString *url = [NSString stringWithFormat:@"%@/quickTalk/change_avatar", QuickTalk_SERVICE_HOST];
    [QTNetworking handlePOST:url params:@{@"user_uuid": userUUID} formDataMap:@{@"0": avatarImage} progress:^(CGFloat progress) {
        
    } success:^(id responseObject) {
        if (completionHandler == nil) {
            return;
        }
        NSString *avatar = nil;
        NSError *error = nil;
        @try {
            NSUInteger code = [responseObject[@"code"] integerValue];
            if (code == CODE_SUCCESS) {
                avatar = responseObject[@"data"][@"avatar"];
            } else {
                error = [QTServiceCode error:code];
            }
        } @catch (NSException *exception) {
            ;
        } @finally {
            completionHandler(avatar, error);
        }
    } failure:^(NSError *error) {
        if (completionHandler == nil) {
            return;
        }
        completionHandler(nil, error);
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

+ (void)requestChangeNickName:(NSString *)userUUID nickname:(NSString *)nickname
            completionHandler:(void (^)(BOOL action, NSError * error))completionHandler
{
    if (userUUID.length == 0) {
        userUUID = @"";
    }
    if (nickname.length == 0) {
        nickname = @"";
    }
    NSDictionary *params = @{@"user_uuid":userUUID, @"nickname":nickname};
    [QTNetworkAgent requestDataForQuickTalkService:@"/change_info" method:SERVICE_REQUEST_POST params:params completionHandler:^(id  _Nullable responseObject, NSError * _Nullable error) {
        if (completionHandler == nil) {
            return;
        }
        if (error) {
            completionHandler(NO, error);
        } else {
            BOOL action = NO;
            @try {
                NSUInteger code = [responseObject[@"code"] integerValue];
                if (code == CODE_SUCCESS) {
                    action = YES;
                } else {
                    error = [QTServiceCode error:code];
                }
            } @catch (NSException *exception) {
                ;
            } @finally {
                completionHandler(action, error);
            }
        }
    }];
}

#pragma mark - setter and getter

- (NSString *)nickname
{
    if (_nickname.length == 0) {
        _nickname = [NSString stringWithFormat:@"用户%@", self._id];
    }
    return _nickname;
}

@end
