//
//  QTMessage.m
//  QuickTalk
//
//  Created by  Ruibin.Chow on 2017/9/10.
//  Copyright © 2017年 www.creactism.com. All rights reserved.
//

#import "QTMessage.h"
#import <TSMessages/TSMessageView.h>

@implementation QTMessage

+ (void)load
{
//    [[TSMessageView appearance] setMessagePosition:TSMessageNotificationPositionBottom];
    [[TSMessageView appearance] setDuration:1.5f];
}

+ (void)showMessageNotification:(NSString *)title
{
    [self showMessageNotification:title subtitle:nil];
}

+ (void)showMessageNotification:(NSString *)title subtitle:(NSString *)subtitle
{
    [TSMessage showNotificationWithTitle:title
                                subtitle:subtitle type:TSMessageNotificationTypeMessage];
}

+ (void)showMessageNotification:(NSString *)title
                 viewController:(UIViewController *)viewController
{
    [self showMessageNotification:title subtitle:nil viewController:viewController];
}

+ (void)showMessageNotification:(NSString *)title subtitle:(NSString *)subtitle
                 viewController:(UIViewController *)viewController
{
    [TSMessage showNotificationInViewController:viewController title:title subtitle:subtitle
                                           type:TSMessageNotificationTypeMessage];
}

+ (void)showWarningNotification:(NSString *)title
{
    [self showWarningNotification:title subtitle:nil];
}

+ (void)showWarningNotification:(NSString *)title subtitle:(NSString *)subtitle
{
    [TSMessage showNotificationWithTitle:title
                                subtitle:subtitle type:TSMessageNotificationTypeWarning];
}

+ (void)showWarningNotification:(NSString *)title
                 viewController:(UIViewController *)viewController
{
    [self showWarningNotification:title subtitle:nil viewController:viewController];
}

+ (void)showWarningNotification:(NSString *)title subtitle:(NSString *)subtitle
                 viewController:(UIViewController *)viewController
{
    [TSMessage showNotificationInViewController:viewController title:title subtitle:subtitle
                                           type:TSMessageNotificationTypeWarning];
}

+ (void)showErrorNotification:(NSString *)title
{
    [self showErrorNotification:title subtitle:nil];
}

+ (void)showErrorNotification:(NSString *)title subtitle:(NSString *)subtitle
{
    [TSMessage showNotificationWithTitle:title
                                subtitle:subtitle type:TSMessageNotificationTypeError];
}

+ (void)showErrorNotification:(NSString *)title
               viewController:(UIViewController *)viewController
{
    [self showErrorNotification:title subtitle:nil viewController:viewController];
}

+ (void)showErrorNotification:(NSString *)title subtitle:(NSString *)subtitle
               viewController:(UIViewController *)viewController
{
    [TSMessage showNotificationInViewController:viewController title:title subtitle:subtitle
                                           type:TSMessageNotificationTypeError];
}

+ (void)showSuccessNotification:(NSString *)title
{
    [self showSuccessNotification:title subtitle:nil];
}

+ (void)showSuccessNotification:(NSString *)title subtitle:(NSString *)subtitle
{
    [TSMessage showNotificationWithTitle:title
                                subtitle:subtitle type:TSMessageNotificationTypeSuccess];
}

+ (void)showSuccessNotification:(NSString *)title
                 viewController:(UIViewController *)viewController
{
    [self showSuccessNotification:title subtitle:nil viewController:viewController];
}

+ (void)showSuccessNotification:(NSString *)title subtitle:(NSString *)subtitle
                 viewController:(UIViewController *)viewController
{
    [TSMessage showNotificationInViewController:viewController title:title subtitle:subtitle
                                           type:TSMessageNotificationTypeSuccess];
}

@end




