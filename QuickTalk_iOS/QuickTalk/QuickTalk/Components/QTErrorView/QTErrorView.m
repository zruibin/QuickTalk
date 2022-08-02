//
//  QTErrorView.m
//  QuickTalk
//
//  Created by  Ruibin.Chow on 2017/11/10.
//  Copyright © 2017年 www.creactism.com. All rights reserved.
//

#import "QTErrorView.h"

@interface QTErrorView ()

@property (nonatomic, strong) UIButton *button;

- (void)initSubViews;

@end

@implementation QTErrorView

- (instancetype) init
{
    self = [super init];
    if (self) {
        [self initSubViews];
    }
    return self;
}

- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews
{
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.button];
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.and.centerY.equalTo(self);
        make.width.mas_equalTo(140);
        make.height.mas_equalTo(40);
    }];
}

#pragma mark - Action

- (void)reloadAction
{
    if (self.onRefreshHandler) {
        self.onRefreshHandler();
    }
}

#pragma mark - setter and getter

- (UIButton *)button
{
    if (_button == nil) {
        _button = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button addTarget:self action:@selector(reloadAction) forControlEvents:UIControlEventTouchUpInside];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont boldSystemFontOfSize:14];
            [button setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
            [button setTitle:@"重新加载" forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage createImageWithColor:[UIColor colorFromHexValue:0xEFEFEF]]
                              forState:UIControlStateNormal];
            button.layer.cornerRadius = 4;
            button.layer.masksToBounds = YES;
            button;
        });
    }
    return _button;
}

@end
