//
//  QTTipView.m
//  QuickTalk
//
//  Created by  Ruibin.Chow on 2017/10/26.
//  Copyright © 2017年 www.creactism.com. All rights reserved.
//

#import "QTTipView.h"

@interface QTTipView ()

@property (nonatomic, strong) UIButton *agreeButton;
@property (nonatomic, strong) UIButton *disAgreeButton;
@property (nonatomic, weak) UIView *superView;
@property (nonatomic, assign) CGFloat viewWidth;

@end

@implementation QTTipView

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

- (instancetype)initFromSuperView:(UIView *)superView;
{
    CGRect frame = superView.bounds;
    self = [super initWithFrame:frame];
    if (self) {
        _superView = superView;
        _viewWidth = frame.size.width;
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews
{
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:.6f];
    [self addSubview:self.agreeButton];
    [self.agreeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(180);
        make.height.mas_equalTo(40);
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).offset(-60);
    }];
    [self addSubview:self.disAgreeButton];
    [self.disAgreeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.and.height.equalTo(self.agreeButton);
        make.centerX.equalTo(self);
        make.centerY.equalTo(self);
    }];
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
    [self addGestureRecognizer:gesture];
}

#pragma mark - Public

+ (instancetype)tipInView:(UIView *)view
{
    return [[self alloc] initFromSuperView:view];
}

- (void)show
{
    [self.superView addSubview:self];
    self.hidden = NO;
    [UIView animateWithDuration:.25f animations:^{
        self.alpha = 1;
    }];
}

- (void)hide
{
    [UIView animateWithDuration:.25f animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        self.hidden = YES;
        [self removeFromSuperview];
    }];
}

#pragma mark - Action

- (void)agreeAction
{
    if (self.onAgreeActionBlock) {
        self.onAgreeActionBlock();
    }
    [self hide];
}

- (void)disagreeAction
{
    if (self.onDisagreeActionBlock) {
        self.onDisagreeActionBlock();
    }
    [self hide];
}

#pragma mark - setter and getter

- (UIButton *)agreeButton
{
    if (_agreeButton == nil) {
        _agreeButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.translatesAutoresizingMaskIntoConstraints = NO;
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage createImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor orangeColor] forState:UIControlStateHighlighted];
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            button.layer.cornerRadius = 4;
            button.layer.masksToBounds = YES;
            [button addTarget:self action:@selector(agreeAction) forControlEvents:UIControlEventTouchUpInside];
            button;
        });
    }
    return _agreeButton;
}

- (UIButton *)disAgreeButton
{
    if (_disAgreeButton == nil) {
        _disAgreeButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.translatesAutoresizingMaskIntoConstraints = NO;
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage createImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor orangeColor] forState:UIControlStateHighlighted];
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            button.layer.cornerRadius = 4;
            button.layer.masksToBounds = YES;
            [button addTarget:self action:@selector(disagreeAction) forControlEvents:UIControlEventTouchUpInside];
            button;
        });
    }
    return _disAgreeButton;
}

- (void)setAgreeString:(NSString *)agreeString
{
    _agreeString = agreeString;
    [self.agreeButton setTitle:agreeString forState:UIControlStateNormal];
}

- (void)setDisAgreeString:(NSString *)disAgreeString
{
    _disAgreeString = disAgreeString;
    [self.disAgreeButton setTitle:disAgreeString forState:UIControlStateNormal];
}

@end
