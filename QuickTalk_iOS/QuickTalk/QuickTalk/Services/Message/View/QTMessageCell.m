//
//  QTMessageCell.m
//  QuickTalk
//
//  Created by  Ruibin.Chow on 2017/12/25.
//  Copyright © 2017年 www.creactism.com. All rights reserved.
//

#import "QTMessageCell.h"
#import "QTMessageModel.h"

@interface QTMessageCell ()

@property (nonatomic, strong) UIButton *avatarButton;
@property (nonatomic, strong) UIButton *nicknameButton;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) RBLabel *webLabel;
@property (nonatomic, strong) UIButton *webButton;
@property (nonatomic, assign) QTMessageType *type;

@end

@implementation QTMessageCell

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
    [self.contentView addSubview:self.avatarButton];
    [self.avatarButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10);
        make.top.equalTo(self.contentView).offset(10);
        make.width.and.height.mas_equalTo(40);
    }];
    [self.contentView addSubview:self.nicknameButton];
    [self.nicknameButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatarButton.mas_right).offset(10);
        make.top.equalTo(self.contentView).offset(10);
        make.width.mas_greaterThanOrEqualTo(100);
        make.height.mas_equalTo(20);
    }];
    [self.contentView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nicknameButton.mas_left);
        make.right.equalTo(self.contentView).offset(-100);
        make.top.equalTo(self.nicknameButton.mas_bottom);
        make.height.mas_equalTo(20);
    }];

    [self.contentView addSubview:self.webLabel];
    [self.webLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatarButton.mas_right).offset(10);
        make.right.equalTo(self.contentView).offset(-20);
        make.top.equalTo(self.timeLabel.mas_bottom).offset(5);
        make.height.mas_equalTo(55);
    }];
    
    [self.contentView addSubview:self.webButton];
    [self.webButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.and.right.and.bottom.equalTo(self.webLabel);
    }];
    
    if ([self respondsToSelector:@selector(setLayoutMargins:)]) {
        self.layoutMargins = UIEdgeInsetsZero;
    }
    if ([self respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        self.preservesSuperviewLayoutMargins = NO;
    }
    [self setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
}

#pragma mark - Public

- (void)loadData:(QTMessageModel *)model
{
    [self.avatarButton cra_setBackgroundImage:model.avatar];
    self.timeLabel.text = [Tools getDateStringFromTimeString:model.time andNeedTime:YES];
    self.webLabel.text = model.title;
    NSString *nameString = [NSString stringWithFormat:@"%@ 关注了你", model.nickname];
    if (model.type == QTMessageUserPostLike) {
        self.webLabel.hidden = NO;
        self.webButton.hidden = NO;
        nameString = [NSString stringWithFormat:@"%@ 赞了", model.nickname];
    } else if (model.type == QTMessageUserPostComment) {
        self.webLabel.hidden = NO;
        self.webButton.hidden = NO;
        nameString = [NSString stringWithFormat:@"%@ 评论了", model.nickname];
    } else {
        self.webLabel.hidden = YES;
        self.webButton.hidden = YES;
    }
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:nameString attributes:nil];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor]
                             range:NSMakeRange(0, nameString.length)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorFromHexValue:0x5a6e97]
                             range:[nameString rangeOfString:model.nickname]];
    [self.nicknameButton setAttributedTitle:attributedString forState:UIControlStateNormal];
}

- (CGFloat)heightForCell:(QTMessageModel *)model
{
    if (model.type == QTMessageUserPostLike || model.type == QTMessageUserPostComment) {
        return 120;
    }
    return 60;
}

#pragma mark - Action

- (void)infoHandlerAction
{
    if (self.onInfoHandler) {
        self.onInfoHandler(self.tag);
    }
}

- (void)hrefHandlerAction
{
    if (self.onHrefHandler) {
        self.onHrefHandler(self.tag);
    }
}

#pragma mark - setter and getter


- (UIButton *)avatarButton
{
    if (_avatarButton == nil) {
        _avatarButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.backgroundColor = [UIColor clearColor];
            button.translatesAutoresizingMaskIntoConstraints = NO;
            [button setBackgroundImage:QuickTalk_DEFAULT_IMAGE forState:UIControlStateNormal];
            [button addTarget:self action:@selector(infoHandlerAction) forControlEvents:UIControlEventTouchUpInside];
            button;
        });
    }
    return _avatarButton;
}

- (UIButton *)nicknameButton
{
    if (_nicknameButton == nil) {
        _nicknameButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.titleLabel.font = [UIFont systemFontOfSize:16];
            [button setTitleColor:[UIColor colorFromHexValue:0x5a6e97] forState:UIControlStateNormal];
            [button setTitleColor:QuickTalk_MAIN_COLOR forState:UIControlStateHighlighted];
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            [button addTarget:self action:@selector(infoHandlerAction) forControlEvents:UIControlEventTouchUpInside];
            button;
        });
    }
    return _nicknameButton;
}

- (UILabel *)timeLabel
{
    if (_timeLabel == nil) {
        _timeLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.font = [UIFont systemFontOfSize:12];
            label.translatesAutoresizingMaskIntoConstraints = NO;
            label.lineBreakMode = NSLineBreakByTruncatingTail;
            label.textAlignment = NSTextAlignmentLeft;
            label.textColor = [UIColor colorFromHexValue:0x999999];
            label.text = @"2017/12/12";
            label;
        });
    }
    return _timeLabel;
}

- (RBLabel *)webLabel
{
    if (_webLabel == nil) {
        _webLabel = ({
            RBLabel *label = [[RBLabel alloc] init];
            label.numberOfLines = 2;
            label.backgroundColor = [UIColor colorFromHexValue:0xF3F3F5];
            label.edgeInsets = UIEdgeInsetsMake(0, 10, 0, 5);
            label.font = [UIFont systemFontOfSize:16];
            label.layer.cornerRadius = 4;
            label.layer.masksToBounds = YES;
            label;
        });
    }
    return _webLabel;
}

- (UIButton *)webButton
{
    if (_webButton == nil) {
        _webButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.translatesAutoresizingMaskIntoConstraints = NO;
            [button setBackgroundImage:[UIImage createImageWithColor:[UIColor colorFromHexValue:0x000 withAlpha:.4f]] forState:UIControlStateHighlighted];
            button.userInteractionEnabled = YES;
            button.layer.cornerRadius = 4;
            button.layer.masksToBounds = YES;
            [button addTarget:self action:@selector(hrefHandlerAction) forControlEvents:UIControlEventTouchUpInside];
            button;
        });
    }
    return _webButton;
}



@end
