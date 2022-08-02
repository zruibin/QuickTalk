//
//  QTUserPostMainCell.m
//  QuickTalk
//
//  Created by  Ruibin.Chow on 2017/12/5.
//  Copyright © 2017年 www.creactism.com. All rights reserved.
//

#import "QTUserPostMainCell.h"
#import "QTUserPostModel.h"
#import "QTUserPostLikeView.h"

@interface QTUserPostMainCell ()

@property (nonatomic, strong, readwrite) UIButton *avatarButton;
@property (nonatomic, strong, readwrite) UIButton *nicknameButton;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, copy) NSDictionary *detailAttributes;

@property (nonatomic, strong) RBLabel *webLabel;
@property (nonatomic, strong) UIButton *webButton;
@property (nonatomic, strong) UILabel *readLabel;
@property (nonatomic, strong) UILabel *commentLabel;
@property (nonatomic, strong) UIButton *arrowButton;
@property (nonatomic, strong) QTUserPostLikeView *likeView;
@property (nonatomic, strong) UIButton *likeButton;

- (void)initSubviews;
- (CGSize)sizeForString:(NSString *)string attributes:(NSDictionary *)attributes;

@end

@implementation QTUserPostMainCell

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
    self.contentView.backgroundColor = [UIColor clearColor];
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
    [self.contentView addSubview:self.likeView];
    [self.likeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatarButton.mas_right).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-20);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-5);
        make.height.mas_equalTo(0);
    }];
    [self.contentView addSubview:self.readLabel];
    [self.readLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatarButton.mas_right).offset(10);
        make.bottom.equalTo(self.likeView.mas_top).offset(-5);
        make.height.mas_equalTo(20);
        make.width.mas_greaterThanOrEqualTo(30);
    }];
    [self.contentView addSubview:self.commentLabel];
    [self.commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.readLabel.mas_right).offset(10);
        make.bottom.equalTo(self.readLabel);
        make.height.mas_equalTo(20);
        make.width.mas_greaterThanOrEqualTo(30);
    }];
    [self.contentView addSubview:self.webLabel];
    [self.webLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatarButton.mas_right).offset(10);
        make.right.equalTo(self.contentView).offset(-20);
        make.bottom.equalTo(self.readLabel.mas_top).offset(-5);
        make.height.mas_equalTo(55);
    }];
    [self.contentView addSubview:self.detailLabel];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timeLabel.mas_bottom).offset(5);
        make.left.equalTo(self.avatarButton.mas_right).offset(10);
        make.right.equalTo(self.contentView).offset(-10);
        make.bottom.equalTo(self.webLabel.mas_top);
    }];
    
    [self.contentView addSubview:self.webButton];
    [self.webButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.and.right.and.bottom.equalTo(self.webLabel);
    }];
    [self.contentView addSubview:self.arrowButton];
    [self.arrowButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(2);
        make.right.equalTo(self.contentView).offset(-6);
        make.width.and.height.mas_equalTo(36);
    }];
    [self.contentView addSubview:self.likeButton];
    [self.likeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.readLabel);
        make.right.equalTo(self.contentView).offset(-20);
        make.width.and.height.mas_equalTo(30);
    }];
    self.likeButton.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
}

#pragma mark - Private

- (CGSize)sizeForString:(NSString *)string attributes:(NSDictionary *)attributes
{
    CGFloat w = CGRectGetWidth([[UIScreen mainScreen] bounds]) - 60 - 10;
    CGSize size = [string boundingRectWithSize:CGSizeMake(w, MAXFLOAT)
                                       options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading | NSStringDrawingUsesDeviceMetrics
                                    attributes:attributes context:nil].size;
    
    return size;
}

#pragma mark - Public

- (void)loadData:(QTUserPostModel *)model
{
    [self.avatarButton cra_setBackgroundImage:model.avatar];
    if (model.nickname > 0) {
        [self.nicknameButton setTitle:model.nickname forState:UIControlStateNormal];
    } else {
        [self.nicknameButton setTitle:[NSString stringWithFormat:@"用户%ld", model.userId] forState:UIControlStateNormal];
    }
    self.timeLabel.text = [Tools getDateStringFromTimeString:model.time andNeedTime:YES];
    if (model.txt.length > 0) {
        self.detailLabel.attributedText = [[NSAttributedString alloc] initWithString:model.txt attributes:self.detailAttributes];
    } else {
        self.detailLabel.attributedText = nil;
    }
    self.webLabel.text = model.title;
    self.readLabel.text = [NSString stringWithFormat:@"阅读: %@", [Tools countTransition:model.readCount]];
    self.commentLabel.text = [NSString stringWithFormat:@"评论: %@", [Tools countTransition:model.commentCount]];
    
    UIImage *image = nil;
    if (model.liked) {
        image = [UIImage imageNamed:@"like"];
    } else {
        image = [[UIImage imageNamed:@"unlike"] imageWithTintColor:[UIColor colorFromHexValue:0x999999]];
    }
    [self.likeButton setImage:image forState:UIControlStateNormal];
    [self.likeButton setImage:[image imageWithTintColor:QuickTalk_MAIN_COLOR]
                      forState:UIControlStateHighlighted];
    
    __weak typeof(self) weakSelf = self;
    self.likeView.likeList = model.likeList;
    [self.likeView setOnIconTouchHandler:^(NSInteger index) {
        if (weakSelf.onlikeIconTouchHandler) {
            weakSelf.onlikeIconTouchHandler(weakSelf.tag, index);
        }
    }];
    CGFloat likeViewH = [self.likeView generateHeight:model.likeList];
    if (model.likeList.count == 0) {
        self.likeView.hidden = YES;
        [self.likeView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.avatarButton.mas_right).offset(10);
            make.right.equalTo(self.contentView.mas_right).offset(-20);
            make.bottom.equalTo(self.contentView.mas_bottom);
            make.height.mas_equalTo(0);
        }];
        [self.readLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.avatarButton.mas_right).offset(10);
            make.bottom.equalTo(self.likeView.mas_top).offset(-5);
            make.height.mas_equalTo(20);
            make.width.mas_greaterThanOrEqualTo(30);
        }];
    } else {
        self.likeView.hidden = NO;
        [self.likeView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.avatarButton.mas_right).offset(10);
            make.right.equalTo(self.contentView.mas_right).offset(-20);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-5);
            make.height.mas_equalTo(likeViewH);
        }];
        [self.readLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.avatarButton.mas_right).offset(10);
            make.bottom.equalTo(self.likeView.mas_top).offset(-5);
            make.height.mas_equalTo(20);
            make.width.mas_greaterThanOrEqualTo(30);
        }];
    }
}

- (CGFloat)heightForCell:(QTUserPostModel *)model
{
    CGSize size = CGSizeZero;
    if (model.txt.length > 0) {
        size = [self sizeForString:model.txt attributes:self.detailAttributes];
    }
    
    CGFloat likeViewH = [self.likeView generateHeight:model.likeList];
    
    CGFloat height = 60 + size.height + 90 + likeViewH;

    return  height;
}

#pragma mark - Action

- (void)herfHandlerAction
{
    if (self.onHrefHandler) {
        self.onHrefHandler(self.tag);
    }
}

- (void)arrowHandlerAction
{
    if (self.onArrowHandler) {
        self.onArrowHandler(self.tag);
    }
}

- (void)infoHandlerAction
{
    if (self.onInfoHandler) {
        self.onInfoHandler(self.tag);
    }
}

- (void)didLikeHandlerAction
{
    if (self.onDidLikeHandler) {
        self.onDidLikeHandler(self.tag);
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

- (UILabel *)detailLabel
{
    if (_detailLabel == nil) {
        _detailLabel = ({
            UILabel *label = [[UILabel alloc] init];
            
            label.translatesAutoresizingMaskIntoConstraints = NO;
            label.lineBreakMode = NSLineBreakByCharWrapping;
            label.textAlignment = NSTextAlignmentLeft;
            label.numberOfLines = 0;
//            label.backgroundColor = [UIColor yellowColor];
            label;
        });
    }
    return _detailLabel;
}

- (NSDictionary *)detailAttributes
{
    if (_detailAttributes == nil) {
        _detailAttributes = ({
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            paragraphStyle.lineSpacing = 4.0f;//增加行高
            paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
            paragraphStyle.alignment = NSTextAlignmentLeft;
            NSDictionary *attributes = @{
                                         NSFontAttributeName: [UIFont systemFontOfSize:16],
                                         NSForegroundColorAttributeName: [UIColor blackColor],
                                         NSParagraphStyleAttributeName: paragraphStyle
                                         };
            attributes;
        });
    }
    return _detailAttributes;
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
//            button.backgroundColor = [UIColor redColor];
            button.translatesAutoresizingMaskIntoConstraints = NO;
            [button setBackgroundImage:[UIImage createImageWithColor:[UIColor colorFromHexValue:0x000 withAlpha:.4f]] forState:UIControlStateHighlighted];
            button.userInteractionEnabled = YES;
            button.layer.cornerRadius = 4;
            button.layer.masksToBounds = YES;
            [button addTarget:self action:@selector(herfHandlerAction) forControlEvents:UIControlEventTouchUpInside];
            button;
        });
    }
    return _webButton;
}

- (UILabel *)readLabel
{
    if (_readLabel == nil) {
        _readLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.text = @"阅读量:1233";
            label.font = [UIFont systemFontOfSize:12];
            label.textAlignment = NSTextAlignmentLeft;
            label.textColor = [UIColor colorFromHexValue:0x999999];
            label;
        });
    }
    return _readLabel;
}

- (UILabel *)commentLabel
{
    if (_commentLabel == nil) {
        _commentLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.text = @"评论:1233";
            label.font = [UIFont systemFontOfSize:12];
            label.textAlignment = NSTextAlignmentLeft;
            label.textColor = [UIColor colorFromHexValue:0x999999];
            label;
        });
    }
    return _commentLabel;
}

- (UIButton *)arrowButton
{
    if (_arrowButton == nil) {
        _arrowButton = ({
            UIImage *image = [UIImage imageNamed:@"down"];
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//            button.backgroundColor = [UIColor redColor];
            button.translatesAutoresizingMaskIntoConstraints = NO;
            [button setImage:[image imageWithTintColor:[UIColor colorFromHexValue:0x999999]] forState:UIControlStateNormal];
            [button setImage:[image imageWithTintColor:QuickTalk_MAIN_COLOR] forState:UIControlStateHighlighted];
            button.userInteractionEnabled = YES;
            button.imageEdgeInsets = UIEdgeInsetsMake(12, 12, 12, 12);
            [button addTarget:self action:@selector(arrowHandlerAction) forControlEvents:UIControlEventTouchUpInside];
            button;
        });
    }
    return _arrowButton;
}

- (QTUserPostLikeView *)likeView
{
    if (_likeView == nil) {
        _likeView = ({
            QTUserPostLikeView *likeView = [[QTUserPostLikeView alloc] init];
//            likeView.backgroundColor = [UIColor colorFromHexValue:0xF3F3F5];
            likeView;
        });
    }
    return _likeView;
}

- (UIButton *)likeButton
{
    if (_likeButton == nil) {
        _likeButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.translatesAutoresizingMaskIntoConstraints = NO;
            UIImage *image = [UIImage imageNamed:@"like"];
            [button setImage:image forState:UIControlStateNormal];
            [button setImage:[image imageWithTintColor:QuickTalk_MAIN_COLOR]
                              forState:UIControlStateHighlighted];
            button.userInteractionEnabled = YES;
//            button.backgroundColor = [UIColor yellowColor];
            [button addTarget:self action:@selector(didLikeHandlerAction) forControlEvents:UIControlEventTouchUpInside];
            button;
        });
    }
    return _likeButton;
}

@end

