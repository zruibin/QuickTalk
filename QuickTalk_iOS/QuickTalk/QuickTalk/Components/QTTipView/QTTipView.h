//
//  QTTipView.h
//  QuickTalk
//
//  Created by  Ruibin.Chow on 2017/10/26.
//  Copyright © 2017年 www.creactism.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QTTipView : UIView

@property (nonatomic, copy) NSString *agreeString;
@property (nonatomic, copy) NSString *disAgreeString;
@property (nonatomic, copy) void (^onAgreeActionBlock)(void);
@property (nonatomic, copy) void (^onDisagreeActionBlock)(void);
@property (nonatomic, copy) void (^onReportActionBlock)(void);
@property (nonatomic, copy) void (^onShowBlock)(void);
@property (nonatomic, copy) void (^onHideBlock)(void);
@property (nonatomic, copy) NSString *content;

+ (instancetype)tipInView:(UIView *)view;
- (void)show;
- (void)hide;

@end
