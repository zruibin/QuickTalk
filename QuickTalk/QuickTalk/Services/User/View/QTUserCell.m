//
//  QTUserCell.m
//  QuickTalk
//
//  Created by  Ruibin.Chow on 2017/12/21.
//  Copyright © 2017年 www.creactism.com. All rights reserved.
//

#import "QTUserCell.h"

@interface QTUserCell ()

@property (nonatomic, strong) UIButton *iconView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *actionButton;

@end

@implementation QTUserCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _multiplie = 0.8;
        [self initSubviews];
    }
    return self;
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
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
        make.right.equalTo(self.contentView).offset(-80);
    }];
    [self.contentView addSubview:self.actionButton];
    [self.actionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(65);
        make.height.mas_equalTo(28);
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-10);
    }];
    self.relationStatus = QTViewRelationHidden;
    if ([self respondsToSelector:@selector(setLayoutMargins:)]) {
        self.layoutMargins = UIEdgeInsetsZero;
    }
    if ([self respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        self.preservesSuperviewLayoutMargins = NO;
    }
    [self setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
}

#pragma mark - Public

- (void)loadData:(NSString *)avatar nickname:(NSString *)nickname subname:(NSString *)subname
{
    [self.iconView setBackgroundImage:QuickTalk_DEFAULT_IMAGE forState:UIControlStateNormal];
    if (subname.length > 0) {
        self.titleLabel.text = [NSString stringWithFormat:@"%@(%@)", nickname, subname];
    } else {
        self.titleLabel.text = nickname;
    }
}

#pragma mark - Action

- (void)avatarAction
{
    if (self.onAvatarHandler) {
        self.onAvatarHandler(self.tag);
    }
}

- (void)actionButtonAction
{
    if (self.onActionHandler) {
        self.onActionHandler(self.tag);
    }
}

#pragma mark - setter and getter

- (UIButton *)iconView
{
    if (_iconView == nil) {
        _iconView = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.userInteractionEnabled = YES;
            [button addTarget:self action:@selector(avatarAction) forControlEvents:UIControlEventTouchUpInside];
            button;
        });
    }
    return _iconView;
}

- (UILabel *)titleLabel
{
    if (_titleLabel == nil) {
        _titleLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.font = [UIFont systemFontOfSize:16];
//            label.textColor = [UIColor colorFromHexValue:0x585858];
            label;
        });
    }
    return _titleLabel;
}

- (UIButton *)actionButton
{
    if (_actionButton == nil) {
        _actionButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setBackgroundImage:[UIImage createImageWithColor:[UIColor colorFromHexValue:0x000 withAlpha:.4]]
                              forState:UIControlStateHighlighted];
            button.titleLabel.font = [UIFont systemFontOfSize:12];
            button.userInteractionEnabled = YES;
            button.layer.borderWidth = 1;
            button.layer.cornerRadius = 2;
            button.layer.borderColor = [QuickTalk_MAIN_COLOR CGColor];
            [button setTitleColor:QuickTalk_MAIN_COLOR forState:UIControlStateNormal];
            [button setTitle:@"关注" forState:UIControlStateNormal];
            [button addTarget:self action:@selector(actionButtonAction) forControlEvents:UIControlEventTouchUpInside];
            button;
        });
    }
    return _actionButton;
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

- (void)setRelationStatus:(QTViewRelationStatus)relationStatus
{
    _relationStatus = relationStatus;
    if (relationStatus == QTViewRelationDefault) {
        self.actionButton.hidden = NO;
        self.actionButton.layer.borderColor = [QuickTalk_MAIN_COLOR CGColor];
        [self.actionButton setTitleColor:QuickTalk_MAIN_COLOR forState:UIControlStateNormal];
        [self.actionButton setTitle:@"关注" forState:UIControlStateNormal];
    }
    if (relationStatus == QTViewRelationStar) {
        self.actionButton.hidden = NO;
        self.actionButton.layer.borderColor = [QuickTalk_SECOND_COLOR CGColor];
        [self.actionButton setTitleColor:QuickTalk_SECOND_COLOR forState:UIControlStateNormal];
        [self.actionButton setTitle:@"已关注" forState:UIControlStateNormal];
    }
    if (relationStatus == QTViewRelationStarAndBeStar) {
        self.actionButton.hidden = NO;
        self.actionButton.layer.borderColor = [QuickTalk_SECOND_COLOR CGColor];
        [self.actionButton setTitleColor:QuickTalk_SECOND_COLOR forState:UIControlStateNormal];
        [self.actionButton setTitle:@"相互关注" forState:UIControlStateNormal];
    }
    if (relationStatus == QTViewRelationHidden) {
        self.actionButton.hidden = YES;
    }
}


@end
