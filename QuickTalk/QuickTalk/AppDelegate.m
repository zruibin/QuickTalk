//
//  AppDelegate.m
//  QuickTalk
//
//  Created by  Ruibin.Chow on 2017/10/16.
//  Copyright © 2017年  Ruibin.Chow. All rights reserved.
//

#import "AppDelegate.h"
#import "QTTabBarController.h"
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

static BOOL isBackGroundActivateApplication;

@interface AppDelegate ()

- (void)registerService:(UIApplication *)application launchOptions:(NSDictionary *)launchOptions;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self registerService:application launchOptions:launchOptions];
    [MMPopupWindow sharedWindow].touchWildToHide = YES;
    [[RBScheduler sharedInstance] run];
    [[QTUserInfo sharedInstance] loginInBackground];
    [[QTCleaner sharedInstance] checkingCache];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    QTTabBarController *tabBarController = [[QTTabBarController alloc] init];
    self.window.rootViewController = tabBarController;
    [self.window makeKeyAndVisible];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [[QTUserInfo sharedInstance] checkingObsolescence];
    [[NSNotificationCenter defaultCenter] postNotificationName:QTPasteBoardCheckingNotification object:nil];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)registerService:(UIApplication *)application launchOptions:(NSDictionary *)launchOptions
{
    /*腾讯Bugly*/
    [Bugly startWithAppId:@"f2e0562976"];
    
    /*讯飞语音*/
    NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@", @"5a1244d8"];
    [IFlySpeechUtility createUtility:initString];
    [IFlySetting setLogFilePath:IFLY_PATH];
#if DEBUG
    [IFlySetting showLogcat:NO];
#else
    [IFlySetting showLogcat:NO];
#endif
    
    /*分享SDK*/
    [ShareSDK registerActivePlatforms:@[
                                        @(SSDKPlatformTypeSinaWeibo),
                                        @(SSDKPlatformTypeWechat),
                                        @(SSDKPlatformTypeQQ)
                                        ]
                             onImport:^(SSDKPlatformType platformType) {
                                 switch (platformType) {
                                     case SSDKPlatformTypeWechat:
                                         [ShareSDKConnector connectWeChat:[WXApi class]];
                                         break;
                                     case SSDKPlatformTypeQQ:
                                         [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                                         break;
                                     case SSDKPlatformTypeSinaWeibo:
                                         [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                                     default:
                                         break;
                                 }
                             } onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
                                 switch (platformType) {
                                     case SSDKPlatformTypeSinaWeibo:
                                         //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                                         [appInfo SSDKSetupSinaWeiboByAppKey:@"3709932233"
                                                                   appSecret:@"d83172702a0265c73023e8a784990055"
                                                                 redirectUri:@"http://open.weibo.com/apps/3709932233/privilege/oauth"
                                                                    authType:SSDKAuthTypeBoth];
                                         break;
                                     case SSDKPlatformTypeWechat:
                                         [appInfo SSDKSetupWeChatByAppId:@"wx1494d37a482793b0"
                                                               appSecret:@"6e1932bca93d26a8cbfd069a57395c43"];
                                         break;
                                     case SSDKPlatformTypeQQ:
                                         [appInfo SSDKSetupQQByAppId:@"1106426421"
                                                              appKey:@"cHVFNyHxCyCyNEur"
                                                            authType:SSDKAuthTypeBoth];
                                         break;
                                     default:
                                           break;
                                 }
                             }];
    
    /*百度推送*/
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0) {
        if (@available(iOS 10.0, *)) {
            UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
            [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert + UNAuthorizationOptionSound + UNAuthorizationOptionBadge)
                                  completionHandler:^(BOOL granted, NSError * _Nullable error) {
                                      // Enable or disable features based on authorization.
                                      if (granted) {
                                          dispatch_async(dispatch_get_main_queue(), ^{
                                              [application registerForRemoteNotifications];
                                          });
                                      }
                                  }];
        }
    } else {
        UIUserNotificationType myTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:myTypes categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
    
#if DEBUG
    BPushMode pushMode = BPushModeDevelopment;
#else
    BPushMode pushMode = BPushModeProduction;
#endif
    // 在 App 启动时注册百度云推送服务，需要提供 Apikey
    [BPush registerChannel:launchOptions apiKey:@"yORLvhoD8cNEVFqglaOGKxAd" pushMode:pushMode withFirstAction:nil withSecondAction:nil withCategory:nil useBehaviorTextInput:YES isDebug:YES];
    // App 是用户点击推送消息启动
    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo) {
        DLog(@"从消息启动:%@",userInfo);
        [BPush handleNotification:userInfo];
    }
    //角标清0
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

/*此方法是用户点击了通知，应用在前台或者开启后台并且应用在后台时调起*/
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
        fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    //杀死状态下，直接跳转到跳转页面。
    if (application.applicationState == UIApplicationStateInactive && !isBackGroundActivateApplication) {
        DLog(@"applacation is unactive ===== %@",userInfo);
    }
    // 应用在后台。当后台设置aps字段里的 content-available 值为 1 并开启远程通知激活应用的选项
    if (application.applicationState == UIApplicationStateBackground) {
        isBackGroundActivateApplication = YES;
        DLog(@"background is Activated Application ");
    }
    completionHandler(UIBackgroundFetchResultNewData);
    DLog(@"backgroud : %@", userInfo);
}

/*在 iOS8 系统中，还需要添加这个方法。通过新的 API 注册推送服务*/
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    DLog(@"deviceToken:%@", deviceToken);
    [BPush registerDeviceToken:deviceToken];
    [BPush bindChannelWithCompleteHandler:^(id result, NSError *error) {
        // 需要在绑定成功后进行 settag listtag deletetag unbind 操作否则会失败
        if (error) { // 网络错误
            return ;
        }
        if (result) {
            // 确认绑定成功
            if ([result[@"error_code"]intValue] != 0) {
                return;
            }
            DLog(@"channelId: %@", [BPush getChannelId]);
            [QTUserInfo sharedInstance].deviceId = [BPush getChannelId];
//            [BPush setTag:@"Mytag" withCompleteHandler:^(id result, NSError *error) {
//                if (result) {
//                    DLog(@"设置tag成功");
//                }
//            }];
        }
    }];
}

/*当DeviceToken 获取失败时，系统会回调此方法*/
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    DLog(@"DeviceToken 获取失败，原因：%@",error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    // App 收到推送的通知
    [BPush handleNotification:userInfo];
    // 应用在前台 或者后台开启状态下，不跳转页面，让用户选择。
    if (application.applicationState == UIApplicationStateActive || application.applicationState == UIApplicationStateBackground) {
        DLog(@"acitve or background");
    }
    else {//杀死状态下，直接跳转到跳转页面。

    }
    DLog(@"%@",userInfo);
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    DLog(@"接收本地通知啦！！！");
    [BPush showLocalNotificationAtFront:notification identifierKey:nil];
}


@end




