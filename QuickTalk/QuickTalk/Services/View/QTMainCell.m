//
//  QTMainCell.m
//  QuickTalk
//
//  Created by  Ruibin.Chow on 2017/11/1.
//  Copyright © 2017年 www.creactism.com. All rights reserved.
//

#import "QTMainCell.h"

@interface QTMainCell ()

@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, copy) NSDictionary *detailAttributes;

- (void)initSubviews;

@end

@implementation QTMainCell


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
    [self.contentView addSubview:self.detailLabel];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).with.insets(UIEdgeInsetsMake(10, 10, 10, 10));
    }];
}

#pragma mark - Private

- (CGSize)sizeForString:(NSString *)string attributes:(NSDictionary *)attributes
{
    CGFloat w = CGRectGetWidth([[UIScreen mainScreen] bounds]) - 20;
    CGSize size = [string boundingRectWithSize:CGSizeMake(w, MAXFLOAT)
                                       options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading | NSStringDrawingUsesDeviceMetrics
                                    attributes:attributes context:nil].size;
    
    return size;
}

#pragma mark - Public

- (void)loadData:(NSString *)text
{
    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:text attributes:self.detailAttributes];
    self.detailLabel.attributedText = attributedText;
}

- (CGFloat)heightForCell:(NSString *)text
{
    CGSize size = [self sizeForString:text attributes:self.detailAttributes];
    CGFloat height = 10 + size.height + 10;
    if (height < 60) {
        height = 60;
    }
    return height;
}

#pragma mark - setter and getter

- (UILabel *)detailLabel
{
    if (_detailLabel == nil) {
        _detailLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.font = [UIFont systemFontOfSize:14];
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
            paragraphStyle.lineSpacing = 5.0f;//增加行高
            paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
            paragraphStyle.alignment = NSTextAlignmentLeft;
            NSDictionary *attributes = @{
                                         NSFontAttributeName: [UIFont boldSystemFontOfSize:18],
                                         NSForegroundColorAttributeName: [UIColor colorFromHexValue:0x585858],
                                         NSParagraphStyleAttributeName: paragraphStyle
                                         };
            attributes;
        });
    }
    return _detailAttributes;
}



@end
