 //
//  QTUserStarButton.m
//  QuickTalk
//
//  Created by  Ruibin.Chow on 2017/12/20.
//  Copyright © 2017年 www.creactism.com. All rights reserved.
//

#import "QTUserStarButton.h"

@interface QTUserStarButton ()

@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UILabel *detailTextLabel;

@end

@implementation QTUserStarButton

- (instancetype) init
{
    self = [super init];
    if (self) {
        [self initSubViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews
{
    [self addSubview:self.iconView];
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.mas_height).multipliedBy(0.55);
        make.height.mas_equalTo(self.mas_height).multipliedBy(0.55);
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(10);
    }];
    [self addSubview:self.textLabel];
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconView.mas_right).offset(10);
        make.right.equalTo(self).offset(-10);
        make.top.equalTo(self).offset(8);
        make.height.mas_equalTo(self.mas_height).multipliedBy(0.4);
    }];
    [self addSubview:self.detailTextLabel];
    [self.detailTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.textLabel);
        make.right.equalTo(self.textLabel);
        make.top.equalTo(self.textLabel.mas_bottom);
        make.height.mas_equalTo(self.mas_height).multipliedBy(0.4);
    }];
}

#pragma mark - setter and getter

- (UIImageView *)iconView
{
    if (_iconView == nil) {
        _iconView = ({
            UIImageView *imageView = [UIImageView new];
            imageView;
        });
    }
    return _iconView;
}

- (UILabel *)textLabel
{
    if (_textLabel == nil) {
        _textLabel = ({
            UILabel *label = [UILabel new];
            label.textColor = [UIColor blackColor];
            label.font = [UIFont systemFontOfSize:16];
            label;
        });
    }
    return _textLabel;
}

- (UILabel *)detailTextLabel
{
    if (_detailTextLabel == nil) {
        _detailTextLabel = ({
            UILabel *label = [UILabel new];
            label.textColor = [UIColor colorFromHexValue:0x585858];
            label.font = [UIFont systemFontOfSize:14];
            label;
        });
    }
    return _detailTextLabel;
}

- (void)setIcon:(UIImage *)icon
{
    _icon = icon;
    self.iconView.image = icon;
}

- (void)setText:(NSString *)text
{
    _text = text;
    self.textLabel.text = text;
}

- (void)setDetailText:(NSString *)detailText
{
    _detailText = detailText;
    self.detailTextLabel.text = detailText;
}

@end
