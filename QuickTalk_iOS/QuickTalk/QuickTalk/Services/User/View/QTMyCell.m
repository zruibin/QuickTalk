//
//  QTMyCell.m
//  QuickTalk
//
//  Created by  Ruibin.Chow on 2017/12/20.
//  Copyright © 2017年 www.creactism.com. All rights reserved.
//

#import "QTMyCell.h"

@interface QTMyCell ()

@end


@implementation QTMyCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubviews];
    }
    return self;
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _multiplie = 0.8;
        [self initSubviews];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)initSubviews
{
    [self.contentView addSubview:self.iconView];
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.and.bottom.equalTo(self.contentView);
        make.width.mas_equalTo(self.contentView.mas_height).multipliedBy(self.multiplie);
        make.height.mas_equalTo(self.contentView.mas_height).multipliedBy(self.multiplie);
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(10);
    }];
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.height.mas_equalTo(30);
        make.left.equalTo(self.iconView.mas_right).offset(10);
        make.right.equalTo(self.contentView).offset(-30);
    }];
    
    if ([self respondsToSelector:@selector(setLayoutMargins:)]) {
        self.layoutMargins = UIEdgeInsetsZero;
    }
    if ([self respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        self.preservesSuperviewLayoutMargins = NO;
    }
    [self setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 0)];
}

#pragma mark - setter and getter

- (UIImageView *)iconView
{
    if (_iconView == nil) {
        _iconView = ({
            UIImageView *imageView = [UIImageView new];
            imageView.layer.cornerRadius = 4;
            imageView.layer.masksToBounds = YES;
            imageView;
        });
    }
    return _iconView;
}

- (UILabel *)titleLabel
{
    if (_titleLabel == nil) {
        _titleLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.font = [UIFont systemFontOfSize:14];
//            label.textColor = [UIColor colorFromHexValue:0x585858];
            label;
        });
    }
    return _titleLabel;
}

- (void)setMultiplie:(CGFloat)multiplie
{
    _multiplie = multiplie;
    [self.iconView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.contentView.mas_height).multipliedBy(multiplie);
        make.height.mas_equalTo(self.contentView.mas_height).multipliedBy(multiplie);
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(10);
    }];
}

@end
