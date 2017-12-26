//
//  QTUserInfo.m
//  QuickTalk
//
//  Created by  Ruibin.Chow on 2017/10/20.
//  Copyright © 2017年 www.creactism.com. All rights reserved.
//

#import "QTUserInfo.h"
#import <SAMKeychain.h>
#import "QTAccountInfo.h"
#import "QTAccountLoginController.h"

static NSString * const kQTLoginServiceName = @"com.creactism.QuickTalk/LoginService";
static NSString * const kQTLoginAccount = @"QTLoginAccount";
static NSString * const kQTLoginPassword = @"QTLoginPassword";
static NSString * const kQTLoginOpenId = @"QTLoginOpenId";
static NSString * const kQTLoginType = @"QTLoginType";
NSString * const QTLoginStatusChangeNotification = @"kQTLoginStatusChangeNotification";

static NSDate *refreshDate = nil;

@interface QTUserInfo ()

@property (nonatomic, readwrite, getter=isLogin) BOOL loginStatus;
@property (nonatomic, assign, readwrite) BOOL hiddenData;

- (void)checkHidden;
- (void)bindNotificationDevice;
- (void)unBindNotificationDevice;

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

- (void)login:(QTAccountInfo *)userInfo password:(NSString *)password type:(NSString *)type
{
    self._id = userInfo._id;
    self.uuid = userInfo.uuid;
    self.nickname = userInfo.nickname;
    self.avatar = userInfo.avatar;
    self.detail = userInfo.detail;
    self.email = userInfo.email;
    self.phone = userInfo.phone;
    self.qq = userInfo.qq;
    self.wechat = userInfo.wechat;
    self.weibo = userInfo.weibo;
    self.gender = userInfo.gender;
    self.area = userInfo.area;
    self.loginStatus = YES;
    [SAMKeychain setPassword:userInfo.phone forService:kQTLoginServiceName account:kQTLoginAccount];
    [SAMKeychain setPassword:password forService:kQTLoginServiceName account:kQTLoginPassword];
    [SAMKeychain setPassword:type forService:kQTLoginServiceName account:kQTLoginType];
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:QTLoginStatusChangeNotification object:nil];
    });
    [self bindNotificationDevice];
}

- (void)loginWithThirdPart:(QTAccountInfo *)userInfo openId:(NSString *)openId type:(NSString *)type
{
    [SAMKeychain setPassword:openId forService:kQTLoginServiceName account:kQTLoginOpenId];
    [self login:userInfo password:nil type:type];
}

- (void)logout
{
    [self unBindNotificationDevice];
    self.loginStatus = NO;
    [SAMKeychain deletePasswordForService:kQTLoginServiceName account:kQTLoginAccount];
    [SAMKeychain deletePasswordForService:kQTLoginServiceName account:kQTLoginPassword];
    [SAMKeychain deletePasswordForService:kQTLoginServiceName account:kQTLoginOpenId];
    [SAMKeychain deletePasswordForService:kQTLoginServiceName account:kQTLoginType];
    self.uuid = nil;
    self.avatar = nil;
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:QTLoginStatusChangeNotification object:nil];
    });
}

- (void)loginInBackground
{
    [self checkHidden];
    refreshDate = [NSDate date];
    NSString *account = [SAMKeychain passwordForService:kQTLoginServiceName account:kQTLoginAccount];
    NSString *password = [SAMKeychain passwordForService:kQTLoginServiceName account:kQTLoginPassword];
    NSString *openId = [SAMKeychain passwordForService:kQTLoginServiceName account:kQTLoginOpenId];
    NSString *type = [SAMKeychain passwordForService:kQTLoginServiceName account:kQTLoginType];
    if ([type isEqualToString:QuickTalk_ACCOUNT_EMAIL] ||
        [type isEqualToString:QuickTalk_ACCOUNT_PHONE]) {
        [QTAccountInfo requestLogin:account type:QuickTalk_ACCOUNT_PHONE password:password completionHandler:^(QTAccountInfo *userInfo, NSError *error) {
            if (error == nil) {
                [self login:userInfo password:password type:type];
            }
        }];
    } else if ([type isEqualToString:QuickTalk_ACCOUNT_WECHAT] ||
               [type isEqualToString:QuickTalk_ACCOUNT_QQ] ||
               [type isEqualToString:QuickTalk_ACCOUNT_WEIBO])  {
        [QTAccountInfo requestLoginForThirdPart:openId type:type completionHandler:^(QTAccountInfo *userInfo, NSError *error) {
            if (error == nil) {
                [self loginWithThirdPart:userInfo openId:openId type:type];
            }
        }];
    }
}

- (BOOL)checkLoginStatus:(UIViewController *)viewController
{
    if (self.loginStatus == NO) {
        QTAccountLoginController *loginController = [QTAccountLoginController new];
        QTNavigationController *nav = [[QTNavigationController alloc] initWithRootViewController:loginController];
        [viewController presentViewController:nav animated:YES completion:nil];
    }
    return self.loginStatus;
}

- (void)checkingObsolescence
{
    NSDate *nowDate = [NSDate date];
    NSTimeInterval interval = [nowDate timeIntervalSinceDate:refreshDate];//获取某一时间与当前时间的间隔
    if (interval > 3600) { /*token缓存时间为一小时，超过则重新登录*/
        [self loginInBackground];
    }
}

+ (void)requestChangeAvatar:(NSString *)userUUID avatarImage:(UIImage *)avatarImage
          completionHandler:(void (^)(NSString *avatar, NSError * error))completionHandler
{
    if (userUUID.length == 0) {
        userUUID = @"";
    }
    NSString *url = [NSString stringWithFormat:@"%@/quickTalk/account/changeAvatar", QuickTalk_SERVICE_HOST];
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
                error = [QTServiceCode error:code message:responseObject[@"message"]];
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
                    error = [QTServiceCode error:code message:responseObject[@"message"]];
                }
            } @catch (NSException *exception) {
                ;
            } @finally {
                completionHandler(action, error);
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
                    error = [QTServiceCode error:code message:responseObject[@"message"]];
                }
            } @catch (NSException *exception) {
                ;
            } @finally {
                self.hiddenData = action;
            }
        }
    }];
}

- (void)bindNotificationDevice
{
    if (self.uuid.length == 0 || self.deviceId.length == 0) {
        return ;
    }
    DLog(@"bindNotificationDevice...");
    DLog(@"uuid: %@, deviceId: %@", self.uuid, self.deviceId);
    NSDictionary *params = @{@"user_uuid": self.uuid, @"deviceId": self.deviceId};
    [QTNetworkAgent requestDataForAccountService:@"/addDevice" method:SERVICE_REQUEST_POST params:params completionHandler:^(id  _Nullable responseObject, NSError * _Nullable error) {
        if (error == nil) {
            @try {
                NSUInteger code = [responseObject[@"code"] integerValue];
                if (code == CODE_SUCCESS) {
                    DLog(@"bind device success...");
                } else {
                    error = [QTServiceCode error:code message:responseObject[@"message"]];
                    DLog(@"error: %@", error.userInfo[ERROR_MESSAGE]);
                }
            } @catch (NSException *exception) {
                ;
            } @finally {
                ;
            }
        }
    }];
}

- (void)unBindNotificationDevice
{
    if (self.uuid.length == 0 || self.deviceId.length == 0) {
        return ;
    }
    DLog(@"unBindNotificationDevice...");
    DLog(@"uuid: %@, deviceId: %@", self.uuid, self.deviceId);
    NSDictionary *params = @{@"user_uuid": self.uuid, @"deviceId": self.deviceId};
    [QTNetworkAgent requestDataForAccountService:@"/deleteDevice" method:SERVICE_REQUEST_POST params:params completionHandler:^(id  _Nullable responseObject, NSError * _Nullable error) {
        if (error == nil) {
            @try {
                NSUInteger code = [responseObject[@"code"] integerValue];
                if (code == CODE_SUCCESS) {
                    DLog(@"unbind device success...");
                } else {
                    error = [QTServiceCode error:code message:responseObject[@"message"]];
                    DLog(@"error: %@", error.userInfo[ERROR_MESSAGE]);
                }
            } @catch (NSException *exception) {
                ;
            } @finally {
                ;
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

- (void)setDeviceId:(NSString *)deviceId
{
    _deviceId = deviceId;
    [self bindNotificationDevice];
}

@end
