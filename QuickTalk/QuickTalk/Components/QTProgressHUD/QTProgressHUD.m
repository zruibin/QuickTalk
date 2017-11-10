//
//  QTProgressHUD.m
//  QuickTalk
//
//  Created by  Ruibin.Chow on 2017/9/8.
//  Copyright © 2017年 www.creactism.com. All rights reserved.
//

#import "QTProgressHUD.h"

static MBProgressHUD *hud = nil;

@interface QTProgressHUD ()

+ (void)releaseHUD;

@end

@implementation QTProgressHUD

+ (void)showHUD:(UIView *)view
{
    if (view) {
        hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    }
    
//    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
//    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
    hud.bezelView.backgroundColor = [UIColor colorFromHexValue:0x000 withAlpha:0.9];
    hud.contentColor = [UIColor whiteColor];
}

+ (void)showHUDWithText:(NSString *)text
{
    hud.mode = MBProgressHUDModeText;
    hud.label.text = text;
    // Move to bottm center.
//    hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
    
    [self hide];
}

+ (void)showHUDWithText:(NSString *)text delay:(NSTimeInterval)timeInterval
{
    hud.mode = MBProgressHUDModeText;
    hud.label.text = text;
    hud.label.font = [UIFont systemFontOfSize:14.5f];
    [hud hideAnimated:YES afterDelay:timeInterval];
    [self releaseHUD];
}

+ (void)showHUDSuccess
{
    hud.mode = MBProgressHUDModeCustomView;
    UIImage *image = [[UIImage imageNamed:@"Checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    hud.customView = [[UIImageView alloc] initWithImage:image];
    // Looks a bit nicer if we make it square.
    hud.square = YES;
    
    [self hide];
}

+ (void)hide
{
//    [hud hideAnimated:YES];
    [hud hideAnimated:YES afterDelay:.5f];
    [self releaseHUD];
}

+ (void)showHUDText:(NSString *)text view:(UIView *)view
{
    if (view) {
        hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
        hud.bezelView.backgroundColor = [UIColor colorFromHexValue:0x000 withAlpha:0.9];
        hud.contentColor = [UIColor whiteColor];
    }
    [self showHUDWithText:text];
}

#pragma mark - Private

+ (void)releaseHUD
{
    if (hud) {
        hud = nil;
    }
}

@end
