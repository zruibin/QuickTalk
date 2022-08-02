//
//  QTPopoverView.h
//  QuickTalk
//
//  Created by  Ruibin.Chow on 2017/9/21.
//  Copyright © 2017年 www.creactism.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QTPopoverView : UIView

@property (nonatomic, copy) void (^onHiddenHandler)(void);
@property (nonatomic, copy) NSArray<NSString *> *items;
@property (nonatomic, copy) void (^onSelectedHandler)(NSUInteger index, NSString *title);
@property (nonatomic, assign) BOOL showSeparatorLine;
@property (nonatomic, assign) NSTextAlignment textAlignment;
@property (nonatomic, assign) BOOL multilineText;
@property (nonatomic, assign) CGFloat fontSize;
@property (nonatomic, strong) UIColor *fontColor;
@property (nonatomic, assign) BOOL scrollEnabled;
@property (nonatomic, assign) NSTimeInterval animationTime;
@property (nonatomic, assign) BOOL showAction;

+ (instancetype)popoverInView:(UIView *)view;

- (void)show;
- (void)hide;

@end
