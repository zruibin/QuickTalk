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


@interface AppDelegate ()

- (void)registerService:(UIApplication *)application launchOptions:(NSDictionary *)launchOptions;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self registerService:application launchOptions:launchOptions];
    [MMPopupWindow sharedWindow].touchWildToHide = YES;
//    [[RBScheduler sharedInstance] run];
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
    /*打开显示允许访问通讯录*/
    CNContactStore *contactStore = [[CNContactStore alloc] init];
    [contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            DLog(@"允许访问通讯录");
        }else{
            DLog(@"不允许访问通讯录");
        }
    }];
    
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
                                        @(SSDKPlatformSubTypeQQFriend),
                                        @(SSDKPlatformSubTypeWechatSession),
                                        @(SSDKPlatformSubTypeWechatTimeline),
                                        @(SSDKPlatformTypeSinaWeibo)
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
                                                            authType:SSDKAuthTypeBoth
                                                              useTIM:NO
                                                         backUnionID:NO];
                                         break;
                                     default:
                                           break;
                                 }
                             }];
    
    /*个推推送*/
#if DEBUG
    NSString *kGTAppId = @"kYv84fJnrV5bv5YFpU6sP";
    NSString *kGTAppKey = @"jyZbxI4IwJ8Qj3DQkPIZi2";
    NSString *kGTAppSecret = @"wKnEQCeRXxAqkEUThku0n8";
#else
    NSString *kGTAppId = @"l0QOBnBOQv5XM1T2nLtNa8";
    NSString *kGTAppKey = @"N97fhuONXk9tCgUnuXyg52";
    NSString *kGTAppSecret = @"aypFVAwzmRAoXG9BALwS29";
#endif
    [GeTuiSdk startSdkWithAppId:kGTAppId appKey:kGTAppKey appSecret:kGTAppSecret delegate:self];
    [GeTuiSdk runBackgroundEnable:YES];
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
            [[UIApplication sharedApplication] registerForRemoteNotifications];
        }
    } else {
        UIUserNotificationType myTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:myTypes categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
     [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

#pragma mark - 远程通知(推送)回调

/** 远程通知注册成功委托 */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    DLog(@"\n>>>[DeviceToken Success]:%@\n\n", token);
    // [ GTSdk ]：向个推服务器注册deviceToken
    [GeTuiSdk registerDeviceToken:token];
}

/** 远程通知注册失败委托 */
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    DLog(@"%@", [NSString stringWithFormat:@"didFailToRegisterForRemoteNotificationsWithError:%@", [error localizedDescription]]);
}

#pragma mark - APP运行中接收到通知(推送)处理 - iOS 10以下版本收到推送

/** APP已经接收到“远程”通知(推送) - (App运行在后台)  */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler
{
    DLog(@"didReceiveRemoteNotification....");
    // [ GTSdk ]：将收到的APNs信息传给个推统计
    [GeTuiSdk handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

#pragma mark - iOS 10中收到推送消息

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
//  iOS 10: App在前台获取到通知
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler
{
    DLog(@"willPresentNotification：%@", notification.request.content.userInfo);
    // 根据APP需要，判断是否要提示用户Badge、Sound、Alert
    completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert);
}

//  iOS 10: 点击通知进入App时触发
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler
{
    DLog(@"didReceiveNotification：%@", response.notification.request.content.userInfo);
    // [ GTSdk ]：将收到的APNs信息传给个推统计
    [GeTuiSdk handleRemoteNotification:response.notification.request.content.userInfo];
    completionHandler();
}
#endif


#pragma mark - GeTuiSdkDelegate

/** SDK启动成功返回cid */
- (void)GeTuiSdkDidRegisterClient:(NSString *)clientId
{
    // [ GTSdk ]：个推SDK已注册，返回clientId
    DLog(@">>[GTSdk RegisterClient]:%@", clientId);
    [QTUserInfo sharedInstance].deviceId = clientId;
}

/** SDK收到透传消息回调 */
- (void)GeTuiSdkDidReceivePayloadData:(NSData *)payloadData andTaskId:(NSString *)taskId andMsgId:(NSString *)msgId andOffLine:(BOOL)offLine fromGtAppId:(NSString *)appId
{
    NSString *string = [[NSString alloc] initWithData:payloadData encoding:NSUTF8StringEncoding];
    DLog(@"GeTuiSdkDidReceivePayloadData...: %@", string);
    // [ GTSdk ]：汇报个推自定义事件(反馈透传消息)
//    [GeTuiSdk sendFeedbackMessage:90001 andTaskId:taskId andMsgId:msgId];
    NSInteger count = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
    UILocalNotification *localNote = [[UILocalNotification alloc] init];
    localNote.fireDate = [NSDate dateWithTimeIntervalSinceNow:0];
    localNote.alertBody = string;
    localNote.soundName = @"default.wav";
    localNote.applicationIconBadgeNumber = count;
    [[UIApplication sharedApplication] scheduleLocalNotification:localNote];
}

/** SDK收到sendMessage消息回调 */
- (void)GeTuiSdkDidSendMessage:(NSString *)messageId result:(int)result
{
    // 页面显示：上行消息结果反馈
}

/** SDK遇到错误回调 */
- (void)GeTuiSdkDidOccurError:(NSError *)error
{
    // 页面显示：个推错误报告，集成步骤发生的任何错误都在这里通知，如果集成后，无法正常收到消息，查看这里的通知。
    DLog(@"%@", [NSString stringWithFormat:@">>>[GexinSdk error]:%@", [error localizedDescription]]);
}

/** SDK运行状态通知 */
- (void)GeTuiSDkDidNotifySdkState:(SdkStatus)aStatus
{
    // 页面显示更新通知SDK运行状态
}

/** SDK设置推送模式回调  */
- (void)GeTuiSdkDidSetPushMode:(BOOL)isModeOff error:(NSError *)error
{
    DLog(@"%@", [NSString stringWithFormat:@">>>[SetModeOff error]: %@", [error localizedDescription]]);
}

@end




