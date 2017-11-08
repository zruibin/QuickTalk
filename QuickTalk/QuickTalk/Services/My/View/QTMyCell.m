//
//  QTMyCell.m
//  QuickTalk
//
//  Created by  Ruibin.Chow on 2017/11/8.
//  Copyright © 2017年 www.creactism.com. All rights reserved.
//

#import "QTMyCell.h"

@interface QTMyCell ()

@property (nonatomic, strong, readwrite) UIButton *avatarButton;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, copy) NSDictionary *detailAttributes;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIButton *likeButton;

- (void)initSubviews;
- (CGSize)sizeForString:(NSString *)string attributes:(NSDictionary *)attributes;

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
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(10);
        make.left.equalTo(self.avatarButton.mas_right).offset(8);
        make.right.equalTo(self.contentView).offset(-10);
        make.height.mas_equalTo(20);
    }];
    [self.contentView addSubview:self.detailLabel];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(5);
        make.left.equalTo(self.avatarButton.mas_right).offset(10);
        make.right.lessThanOrEqualTo(self.contentView).offset(-10);
        make.height.mas_greaterThanOrEqualTo(30);
    }];
    [self.contentView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.detailLabel.mas_left);
        make.right.equalTo(self.contentView).offset(-100);
        make.bottom.equalTo(self.contentView).offset(-5);
        make.height.mas_equalTo(20);
    }];
    //    [self.contentView addSubview:self.likeButton];
    //    [self.likeButton mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.right.equalTo(self.contentView).offset(-15);
    //        make.centerY.equalTo(self.timeLabel);
    //        make.height.mas_equalTo(14);
    //        make.width.mas_lessThanOrEqualTo(80);
    //    }];
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

- (void)loadData:(NSString *)detail avatar:(NSString *)avatar time:(NSString *)time likeNum:(NSInteger)likeNum title:(NSString *)title
{
    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:detail attributes:self.detailAttributes];
    self.detailLabel.attributedText = attributedText;
    [self.avatarButton cra_setBackgroundImage:avatar];
    self.timeLabel.text = [Tools getDateStringFromTimeString:time andNeedTime:YES];
    [self.likeButton setTitle:[Tools countTransition:likeNum] forState:UIControlStateNormal];
    self.titleLabel.text = title;
}

- (CGFloat)heightForCell:(NSString *)detail
{
    CGSize size = [self sizeForString:detail attributes:self.detailAttributes];
    
    CGFloat height = 40 + size.height + 30;
    if (height < 70) {
        height = 70;
    }
    return  height;
}

#pragma mark - Action

- (void)onLikeButtonAction
{

}

#pragma mark - setter and getter

- (UIButton *)avatarButton
{
    if (_avatarButton == nil) {
        _avatarButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.backgroundColor = [UIColor clearColor];
            button.translatesAutoresizingMaskIntoConstraints = NO;
            button;
        });
    }
    return _avatarButton;
}

- (UILabel *)titleLabel
{
    if (_titleLabel == nil) {
        _titleLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.font = [UIFont systemFontOfSize:16];
            label.textColor = [UIColor colorFromHexValue:0x5D97D5];
            label.translatesAutoresizingMaskIntoConstraints = NO;
            label.lineBreakMode = NSLineBreakByTruncatingTail;
            label.textAlignment = NSTextAlignmentLeft;
            label;
        });
    }
    return _titleLabel;
}

- (UILabel *)detailLabel
{
    if (_detailLabel == nil) {
        _detailLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.font = [UIFont systemFontOfSize:16];
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
            label;
        });
    }
    return _timeLabel;
}

- (UIButton *)likeButton
{
    if (_likeButton == nil) {
        _likeButton = ({
            UIButton *buttom = [UIButton buttonWithType:UIButtonTypeCustom];
            [buttom setTitleColor:[UIColor colorFromHexValue:0x999999] forState:UIControlStateNormal];
            buttom.titleLabel.font = [UIFont systemFontOfSize:12];
            buttom.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            buttom.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
            [buttom setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
            buttom.translatesAutoresizingMaskIntoConstraints = NO;
            [buttom.imageView setContentMode:UIViewContentModeScaleAspectFit];
            [buttom addTarget:self action:@selector(onLikeButtonAction) forControlEvents:UIControlEventTouchUpInside];
            buttom;
        });
    }
    return _likeButton;
}

@end

