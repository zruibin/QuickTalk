//
//  QTTopicRightCell.m
//  QuickTalk
//
//  Created by  Ruibin.Chow on 2017/10/19.
//  Copyright © 2017年 www.creactism.com. All rights reserved.
//

#import "QTTopicRightCell.h"

@interface QTTopicRightCell ()

@property (nonatomic, strong, readwrite) UIButton *avatarButton;
@property (nonatomic, strong) UIImageView *bgView;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, copy) NSDictionary *detailAttributes;

- (void)initSubviews;
- (CGSize)sizeForString:(NSString *)string attributes:(NSDictionary *)attributes;


@end

@implementation QTTopicRightCell

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
        make.right.equalTo(self.contentView).offset(-10);
        make.top.equalTo(self.contentView).offset(10);
        make.width.and.height.mas_equalTo(40);
    }];
    [self.contentView addSubview:self.bgView];
    [self.contentView addSubview:self.detailLabel];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(14);
        make.right.equalTo(self.avatarButton.mas_left).offset(-30);
        make.left.greaterThanOrEqualTo(self.contentView).offset(30);
        make.height.mas_greaterThanOrEqualTo(30);
    }];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.detailLabel.mas_top).offset(-10);
        make.left.equalTo(self.detailLabel.mas_left).offset(-14);
        make.right.equalTo(self.detailLabel.mas_right).offset(14);
        make.bottom.equalTo(self.detailLabel.mas_bottom).offset(10);
    }];
}

#pragma mark - Public

- (void)loadData:(NSString *)detail avatar:(NSString *)avatar
{
    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:detail attributes:self.detailAttributes];
    self.detailLabel.attributedText = attributedText;
    [self.imageView cra_setImage:avatar];
}

- (CGFloat)heightForCell:(NSString *)detail
{
    CGSize size = [self sizeForString:detail attributes:self.detailAttributes];
    CGFloat height = 14 + size.height + 14;
    height = ceil(height);
    if (height < 50) {
        height = 50;
    }
    return  height;
}

#pragma mark - Private

- (CGSize)sizeForString:(NSString *)string attributes:(NSDictionary *)attributes
{
    CGFloat w = CGRectGetWidth([[UIScreen mainScreen] bounds]) - 20 - 45 - 40;
    CGSize size = [string boundingRectWithSize:CGSizeMake(w, MAXFLOAT)
                                       options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading | NSStringDrawingUsesDeviceMetrics
                                    attributes:attributes context:nil].size;
    
    return size;
}

#pragma mark - setter and getter

- (UIButton *)avatarButton
{
    if (_avatarButton == nil) {
        _avatarButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.backgroundColor = [UIColor redColor];
            button.translatesAutoresizingMaskIntoConstraints = NO;
            button;
        });
    }
    return _avatarButton;
}

- (UIImageView *)bgView
{
    if (_bgView == nil) {
        _bgView = ({
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.image = [[UIImage imageNamed:@"message_sender_background_normal"] resizableImageWithCapInsets:UIEdgeInsetsMake(30, 20, 10, 20)];
            imageView;
        });
    }
    return _bgView;
}

- (UILabel *)detailLabel
{
    if (_detailLabel == nil) {
        _detailLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.font = [UIFont systemFontOfSize:18];
            label.translatesAutoresizingMaskIntoConstraints = NO;
            label.lineBreakMode = NSLineBreakByCharWrapping;
            label.textAlignment = NSTextAlignmentLeft;
            label.numberOfLines = 0;
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
                                         NSFontAttributeName: [UIFont systemFontOfSize:17],
                                         NSForegroundColorAttributeName: [UIColor blackColor],
                                         NSParagraphStyleAttributeName: paragraphStyle
                                         };
            attributes;
        });
    }
    return _detailAttributes;
}

@end

