//
//  QTMainCell.m
//  QuickTalk
//
//  Created by  Ruibin.Chow on 2017/11/1.
//  Copyright © 2017年 www.creactism.com. All rights reserved.
//

#import "QTMainCell.h"
#import "QTTopicSpeaker.h"

@interface QTMainCell ()

@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, copy) NSDictionary *detailAttributes;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong, readwrite) UIButton *playButton;
@property (nonatomic, copy) NSString *uuid;

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
        make.edges.equalTo(self.contentView).with.insets(UIEdgeInsetsMake(10, 10, 35+46, 10));
    }];
    [self.contentView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10);
        make.right.equalTo(self.contentView).offset(-10);
        make.bottom.equalTo(self.contentView).offset(-5);
        make.height.mas_equalTo(30);
    }];
    [self.contentView addSubview:self.playButton];
    [self.playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(36);
        make.width.mas_equalTo(100);
        make.left.equalTo(self.contentView).offset(10);
        make.bottom.equalTo(self.timeLabel.mas_top).offset(-5);
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

- (void)playButtonAction
{
    if (self.onPlayActionHandler) {
        self.onPlayActionHandler(self.uuid, self.tag);
    }
}

#pragma mark - Public

- (void)loadData:(NSString *)text time:(NSString *)time uuid:(NSString *)uuid
{
    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:text attributes:self.detailAttributes];
    self.detailLabel.attributedText = attributedText;
    self.timeLabel.text = [Tools getDateStringFromTimeString:time andNeedTime:YES];
    
    self.uuid = uuid;
    QTTopicSpeaker *topicSpeaker = [QTTopicSpeaker sharedInstance];
    if ([topicSpeaker.name isEqualToString:uuid]) {
        if (topicSpeaker.speaker.status == QTSpeakerNone ||
            topicSpeaker.speaker.status == QTSpeakerDestory) {
            self.speaking = NO;
        } else {
            if (topicSpeaker.speaker.status == QTSpeakerPause) {
                self.speaking = NO;
            } else {
                self.speaking = YES;
            }
        }
    } else {
        self.speaking = NO;
    }
}

- (CGFloat)heightForCell:(NSString *)text
{
    CGSize size = [self sizeForString:text attributes:self.detailAttributes];
    CGFloat height = 10 + size.height;
    height = height + 40 + 46;
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

- (UIButton *)playButton
{
    if (_playButton == nil) {
        _playButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
            [button setImage:[[UIImage imageNamed:@"play"] imageWithTintColor:QuickTalk_MAIN_COLOR]
                    forState:UIControlStateHighlighted];
            [button setTitle:@"播放新闻" forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            [button setTitleColor:[UIColor colorFromHexValue:0x666666] forState:UIControlStateNormal];
            [button setTitleColor:QuickTalk_MAIN_COLOR forState:UIControlStateHighlighted];
            button.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
            button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5);
            button.layer.masksToBounds = YES;
            button.layer.cornerRadius = 4;
            button.layer.borderWidth = .5f;
            button.layer.borderColor = [[UIColor colorFromHexValue:0x666666] CGColor];
//            [button setBackgroundImage:[UIImage createImageWithColor:[UIColor colorFromHexValue:0xEAEAEA]] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage createImageWithColor:[UIColor grayColor]] forState:UIControlStateHighlighted];
            [button addTarget:self action:@selector(playButtonAction) forControlEvents:UIControlEventTouchUpInside];
            button;
        });
    }
    return _playButton;
}

- (void)setSpeaking:(BOOL)speaking
{
    _speaking = speaking;
    if (_speaking) {
        [self.playButton setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
        [self.playButton setImage:[[UIImage imageNamed:@"pause"] imageWithTintColor:QuickTalk_MAIN_COLOR]
                         forState:UIControlStateHighlighted];
        [self.playButton setTitle:@"暂停播放" forState:UIControlStateNormal];
         [self.playButton setBackgroundImage:[UIImage createImageWithColor:[UIColor colorFromHexValue:0xEAEAEA]] forState:UIControlStateNormal];
        self.playButton.layer.borderWidth = 0;
    } else {
        [self.playButton setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
        [self.playButton setImage:[[UIImage imageNamed:@"play"] imageWithTintColor:QuickTalk_MAIN_COLOR]
                         forState:UIControlStateHighlighted];
        [self.playButton setTitle:@"播放新闻" forState:UIControlStateNormal];
        self.playButton.layer.borderWidth = .5f;
    }
}

@end
