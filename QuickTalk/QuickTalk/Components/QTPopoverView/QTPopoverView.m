//
//  QTPopoverView.m
//  QuickTalk
//
//  Created by  Ruibin.Chow on 2017/9/21.
//  Copyright © 2017年 www.creactism.com. All rights reserved.
//

#import "QTPopoverView.h"

static const CGFloat default_line_height = 44.0f;
static const NSUInteger TITLE_TAG = 121212;

@interface QTPopoverView () <UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, weak) UIView *superView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSDictionary *attributes;
@property (nonatomic, copy) NSArray *textList;
@property (nonatomic, assign) CGFloat viewWidth;
@property (nonatomic, strong) UIView *footView;

- (CGFloat)textHeight:(NSString *)text;

@end

@implementation QTPopoverView

- (instancetype)init
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

- (instancetype)initFromSuperView:(UIView *)superView;
{
    CGRect frame = superView.bounds;
    self = [super initWithFrame:frame];
    if (self) {
        _superView = superView;
        _viewWidth = frame.size.width;
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews
{
    [self addSubview:self.tableView];
    self.alpha = 0;

    CGRect rect = self.bounds;
    rect.origin.y = -rect.size.height;
    self.tableView.frame = rect;
    self.hidden = YES;
    _showSeparatorLine = YES;
    _textAlignment = NSTextAlignmentLeft;
    _fontSize = 16;
    _fontColor = [UIColor blackColor];
    self.scrollEnabled = NO;
    _animationTime = .4;
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
    [gesture setCancelsTouchesInView:NO];
    gesture.delegate = self;
    [self addGestureRecognizer:gesture];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.backgroundColor = [UIColor colorWithRed:.5 green:.5 blue:.5 alpha:.5];
}

#pragma mark - Public

+ (instancetype)popoverInView:(UIView *)view
{
    return [[self alloc] initFromSuperView:view];
}

- (void)show
{
    [self.superView addSubview:self];
    self.hidden = NO;
    [self.tableView reloadData];
    if (self.showAction) {
        self.tableView.tableFooterView = self.footView;
    } else {
        self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    [UIView animateWithDuration:self.animationTime animations:^{
        self.alpha = 1;
        self.tableView.frame = self.bounds;
    }];
}

- (void)hide
{
    CGRect rect = self.bounds;
    rect.origin.y = -rect.size.height;
    if (self.onHiddenHandler) {
        self.onHiddenHandler();
    }
    [UIView animateWithDuration:self.animationTime animations:^{
        self.tableView.frame = rect;
        self.alpha = 0;
    } completion:^(BOOL finished) {
        self.hidden = YES;
        [self removeFromSuperview];
    }];
}

#pragma mark - Private

- (CGFloat)textHeight:(NSString *)text
{
    CGSize size = [text boundingRectWithSize:CGSizeMake(self.viewWidth-20, MAXFLOAT)
                                        options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading | NSStringDrawingUsesDeviceMetrics
                                     attributes:self.attributes context:nil].size;
    return size.height + 10;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer* )gestureRecognizer shouldReceiveTouch:(UITouch* )touch
{
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"PKProductMainListTableViewCellContentView"]) {
        return NO;
    }
    if ([touch.view isKindOfClass:[UIButton class]]) {
        return NO;
    }
    if ([touch.view isKindOfClass:[UITableViewCell class]]) {
        return YES;
    }
    return YES;
}

#pragma mark - TableView Delegate And DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.textList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:TITLE_TAG];
    if (titleLabel == nil) {
        titleLabel = [[UILabel alloc] init];
        titleLabel.frame = CGRectMake(10, 0, self.viewWidth-20, default_line_height);
        titleLabel.font = [UIFont systemFontOfSize:self.fontSize];
        titleLabel.textColor = self.fontColor;
        titleLabel.tag = TITLE_TAG;
        [cell addSubview:titleLabel];
    }
    
    NSString *text = self.textList[indexPath.row];
    CGFloat height = default_line_height;
    if (self.multilineText) {
        titleLabel.attributedText = [[NSAttributedString alloc] initWithString:text attributes:self.attributes];
        titleLabel.numberOfLines = 0;
        titleLabel.textAlignment = NSTextAlignmentLeft;
        height = [self textHeight:text];
        if (height < default_line_height) {
            height = default_line_height;
        }
        titleLabel.frame = CGRectMake(10, 0, self.viewWidth-20, height);
    } else {
        titleLabel.text = text;
        titleLabel.numberOfLines = 1;
        titleLabel.textAlignment = self.textAlignment;
        titleLabel.frame = CGRectMake(10, 0, self.viewWidth-20, default_line_height);
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = default_line_height;
    if (self.multilineText) {
        NSString *text = self.textList[indexPath.row];
        height = [self textHeight:text];
        if (height < default_line_height) {
            height = default_line_height;
        }
    }
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.onSelectedHandler) {
        self.onSelectedHandler(indexPath.row, self.textList[indexPath.row]);
    }
}

#pragma mark - Action

- (void)footViewButtonAction
{
    if (self.textList.count > 0) {
        if (self.onSelectedHandler) {
            self.onSelectedHandler(0, self.textList[0]);
        }
    }
}

#pragma mark - setter and getter

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = ({
            UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
            tableView.estimatedRowHeight = 0;
            tableView.estimatedSectionHeaderHeight = 0;
            tableView.estimatedSectionFooterHeight = 0;
            tableView.delegate = self;
            tableView.dataSource = self;
//            tableView.translatesAutoresizingMaskIntoConstraints = NO;
            tableView.showsVerticalScrollIndicator = NO;
            tableView.exclusiveTouch = YES;
            tableView.backgroundColor = [UIColor clearColor];
            tableView.backgroundColor = [UIColor clearColor];
//            tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
            tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
            tableView;
        });
    }
    return _tableView;
}

- (NSDictionary *)attributes
{
    if (_attributes == nil) {
        _attributes = ({
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            paragraphStyle.lineSpacing = 5.0f;//增加行高
            paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
            paragraphStyle.alignment = NSTextAlignmentLeft;
            NSDictionary *attributes = @{
                                         NSFontAttributeName: [UIFont systemFontOfSize:self.fontSize],
                                         NSForegroundColorAttributeName: self.fontColor,
                                         NSParagraphStyleAttributeName: paragraphStyle
                                         };
            attributes;
        });
    }
    return _attributes;
}

- (UIView *)footView
{
    if (_footView == nil) {
        _footView = ({
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.viewWidth, 50)];
            view.backgroundColor = [UIColor whiteColor];
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:@"阅读新闻" forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage createImageWithColor:[UIColor colorFromHexValue:0x00a0e9]] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            button.layer.cornerRadius = 4;
            button.layer.masksToBounds = YES;
            [button addTarget:self action:@selector(footViewButtonAction) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:button];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.and.centerY.equalTo(view);
                make.width.mas_equalTo(100);
                make.height.mas_equalTo(30);
            }];
            
            view;
        });
    }
    return _footView;
}

- (void)setItems:(NSArray<NSString *> *)items
{
    _items = items;
    self.textList = [items copy];
    self.tableView.frame = self.bounds;
    [self.tableView reloadData];
}

- (void)setScrollEnabled:(BOOL)scrollEnabled
{
    _scrollEnabled = scrollEnabled;
    self.tableView.scrollEnabled = scrollEnabled;
}

- (void)setShowSeparatorLine:(BOOL)showSeparatorLine
{
    _showSeparatorLine = showSeparatorLine;
    if (_showSeparatorLine) {
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    } else {
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
}

@end
