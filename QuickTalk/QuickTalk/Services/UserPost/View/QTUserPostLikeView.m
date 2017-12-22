//
//  QTUserPostLikeView.m
//  QuickTalk
//
//  Created by  Ruibin.Chow on 2017/12/22.
//  Copyright © 2017年 www.creactism.com. All rights reserved.
//

#import "QTUserPostLikeView.h"
#import "QTUserPostModel.h"

static const NSInteger countOfEveryLine = 7;
static const CGFloat singleWH = 28.0f;
static const CGFloat paddingH = 6.0f;

@interface QTUserPostLikeView ()

@property (nonatomic, assign) NSInteger countOfLines;

- (void)initSubViews;

@end

@implementation QTUserPostLikeView

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

- (void)initSubViews
{
    
}

- (void)makeSubViews
{
    for (UIView *view in [self subviews]) {
        [view removeFromSuperview];
    }
    
    __weak typeof(self) weakSelf = self;
    [self.likeList enumerateObjectsUsingBlock:^(QTUserPostLikeModel * _Nonnull obj, NSUInteger index, BOOL * _Nonnull stop) {
        NSInteger nowInLine = index / countOfEveryLine;
        CGFloat y = (singleWH + paddingH) * nowInLine + paddingH;
        CGFloat x = (singleWH + paddingH) * (index % countOfEveryLine + 1);
        UIButton *icon = [UIButton buttonWithType:UIButtonTypeCustom];
        icon.tag = index;
        [icon addTarget:weakSelf action:@selector(iconTouchAction:) forControlEvents:UIControlEventTouchUpInside];
        icon.frame = CGRectMake(x, y, singleWH, singleWH);
        [icon setBackgroundImage:QuickTalk_DEFAULT_IMAGE forState:UIControlStateNormal];
        [weakSelf addSubview:icon];
    }];
    
    UIImageView *likeIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"like"]];
    likeIcon.frame = CGRectMake(paddingH+2, paddingH+5, singleWH-10, singleWH-10);
    [self addSubview:likeIcon];
}

#pragma mark - Public

- (CGFloat)generateHeight:(NSArray<QTUserPostLikeModel *> *)likeList
{
    CGFloat height = 0.0f;
    NSInteger count = [likeList count];
    if (count != 0) {
        NSInteger countOfLines = ceil(count/(countOfEveryLine+0.0f));
        height = (singleWH + paddingH) * countOfLines + paddingH;
    }
    return height;
}

#pragma mark - Action

- (void)iconTouchAction:(UIButton *)button
{
    if (self.onIconTouchHandler) {
        self.onIconTouchHandler(button.tag);
    }
}

#pragma mark - setter and getter

- (void)setLikeList:(NSArray<QTUserPostLikeModel *> *)likeList
{
    _likeList = [likeList copy];
    
    NSInteger count = [_likeList count];
    if (count == 0) {
        self.countOfLines = 0;
        return;
    }
    self.countOfLines = ceil(count/(countOfEveryLine+0.0f));
    [self makeSubViews];
}

@end


