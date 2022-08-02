//
//  QTMessage.h
//  QuickTalk
//
//  Created by  Ruibin.Chow on 2017/9/10.
//  Copyright © 2017年 www.creactism.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QTMessage : NSObject

+ (void)showMessageNotification:(NSString *)title;
+ (void)showMessageNotification:(NSString *)title subtitle:(NSString *)subtitle;
+ (void)showMessageNotification:(NSString *)title
                 viewController:(UIViewController *)viewController;
+ (void)showMessageNotification:(NSString *)title subtitle:(NSString *)subtitle
                 viewController:(UIViewController *)viewController;

+ (void)showWarningNotification:(NSString *)title;
+ (void)showWarningNotification:(NSString *)title subtitle:(NSString *)subtitle;
+ (void)showWarningNotification:(NSString *)title
                 viewController:(UIViewController *)viewController;
+ (void)showWarningNotification:(NSString *)title subtitle:(NSString *)subtitle
                 viewController:(UIViewController *)viewController;

+ (void)showErrorNotification:(NSString *)title;
+ (void)showErrorNotification:(NSString *)title subtitle:(NSString *)subtitle;
+ (void)showErrorNotification:(NSString *)title
                 viewController:(UIViewController *)viewController;
+ (void)showErrorNotification:(NSString *)title subtitle:(NSString *)subtitle
                 viewController:(UIViewController *)viewController;

+ (void)showSuccessNotification:(NSString *)title;
+ (void)showSuccessNotification:(NSString *)title subtitle:(NSString *)subtitle;
+ (void)showSuccessNotification:(NSString *)title
               viewController:(UIViewController *)viewController;
+ (void)showSuccessNotification:(NSString *)title subtitle:(NSString *)subtitle
               viewController:(UIViewController *)viewController;

@end
