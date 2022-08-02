//
//  QTTipView.m
//  QuickTalk
//
//  Created by  Ruibin.Chow on 2017/10/26.
//  Copyright © 2017年 www.creactism.com. All rights reserved.
//

#import "QTTipView.h"

@interface QTTipView ()

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIButton *agreeButton;
@property (nonatomic, strong) UIButton *disAgreeButton;
@property (nonatomic, strong) UIButton *reportButton;
@property (nonatomic, weak) UIView *superView;
@property (nonatomic, assign) CGFloat viewWidth;
@property (nonatomic, copy) NSDictionary *attributes;

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
    self.backgroundColor = [UIColor whiteColor];//[UIColor colorWithWhite:0 alpha:.6f];
    
    [self addSubview:self.reportButton];
    [self.reportButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(40);
        make.top.equalTo(self).offset(20);
        make.right.equalTo(self);
    }];
    
    [self addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(80);
        make.left.equalTo(self).offset(10);
        make.right.equalTo(self).offset(-10);
        make.height.mas_equalTo(300);
    }];
    
    [self addSubview:self.agreeButton];
    [self.agreeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(140);
        make.height.mas_equalTo(40);
        make.centerX.equalTo(self).offset(-100);
        make.top.equalTo(self.textView.mas_bottom).offset(30);
    }];
    [self addSubview:self.disAgreeButton];
    [self.disAgreeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.and.height.equalTo(self.agreeButton);
        make.centerX.equalTo(self).offset(100);
        make.top.equalTo(self.agreeButton);
    }];
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
    [self addGestureRecognizer:gesture];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.textView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
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
    if (self.onShowBlock) {
        self.onShowBlock();
    }
}

- (void)hide
{
    [UIView animateWithDuration:.25f animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        self.hidden = YES;
        [self removeFromSuperview];
    }];
    if (self.onHideBlock) {
        self.onHideBlock();
    }
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

- (void)reportAction
{
    [self hide];
    if (self.onReportActionBlock) {
        self.onReportActionBlock();
    }
}

#pragma mark - setter and getter

- (UITextView *)textView
{
    if (_textView == nil) {
        _textView = ({
            UITextView *textView = [[UITextView alloc] init];
            textView.font = [UIFont systemFontOfSize:19];
            textView.editable = NO;
            textView.showsVerticalScrollIndicator = NO;
            textView.textContainerInset = UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f);
            textView;
        });
    }
    return _textView;
}

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
            button.layer.borderColor = [[UIColor grayColor] CGColor];
            button.layer.borderWidth = .5f;
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
            button.layer.borderColor = [[UIColor grayColor] CGColor];
            button.layer.borderWidth = .5f;
            [button addTarget:self action:@selector(disagreeAction) forControlEvents:UIControlEventTouchUpInside];
            button;
        });
    }
    return _disAgreeButton;
}

- (UIButton *)reportButton
{
    if (_reportButton == nil) {
        _reportButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.translatesAutoresizingMaskIntoConstraints = NO;
            [button setTitle:@"举报" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor orangeColor] forState:UIControlStateHighlighted];
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            [button addTarget:self action:@selector(reportAction) forControlEvents:UIControlEventTouchUpInside];
            button;
        });
    }
    return _reportButton;
}

- (NSDictionary *)attributes
{
    if (_attributes == nil) {
        _attributes = ({
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            paragraphStyle.lineSpacing = 5.0f;//增加行高
            paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
            paragraphStyle.alignment = NSTextAlignmentLeft;
            NSDictionary *attributes = @{
                                         NSFontAttributeName: [UIFont systemFontOfSize:20],
                                         NSForegroundColorAttributeName: [UIColor colorFromHexValue:0x585858],
                                         NSParagraphStyleAttributeName: paragraphStyle
                                         };
            attributes;
        });
    }
    return _attributes;
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

- (void)setContent:(NSString *)content
{
    _content = [NSString stringWithFormat:@"\n%@", content];
    self.textView.attributedText = [[NSAttributedString alloc] initWithString:_content attributes:self.attributes];
}

@end
