//
//  QTProgressHUD.h
//  QuickTalk
//
//  Created by  Ruibin.Chow on 2017/9/8.
//  Copyright © 2017年 www.creactism.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QTProgressHUD : NSObject

+ (void)showHUD:(UIView *)view;
+ (void)showHUDWithText:(NSString *)text;
+ (void)showHUDWithText:(NSString *)text delay:(NSTimeInterval)timeInterval;
+ (void)showHUDSuccess;
+ (void)hide;

+ (void)showHUDText:(NSString *)text view:(UIView *)view;

@end
