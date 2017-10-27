//
//  QTTopicController.m
//  QuickTalk
//
//  Created by  Ruibin.Chow on 2017/10/16.
//  Copyright © 2017年 www.creactism.com. All rights reserved.
//

#import "QTTopicController.h"
#import "QTTopicModel.h"
#import "QTTopicLeftCell.h"
#import "QTTopicRightCell.h"
#import "QTCommentModel.h"
#import "EwenTextView.h"
#import "QTTipView.h"

NSString * const kTopicHiddenPopupMenuNotification = @"kTopicHiddenPopupMenuNotification";

@interface QTTopicController ()
<
UITableViewDataSource, UITableViewDelegate
>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) EwenTextView *inputView;
@property (nonatomic, strong) NSMutableArray *dataList;
@property (nonatomic, assign) CGFloat viewWidth;
@property (nonatomic, assign) CGFloat viewHeight;
@property (nonatomic, assign) NSUInteger page;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UIButton *updataButton;
@property (nonatomic, strong) QTTipView *tipView;

- (void)initViews;
- (void)loadData;
- (void)loadMoreData;
- (void)sendComment:(NSString *)text;
- (void)sendAgreeOrDisAgree:(QTCommentModel *)model action:(NSString *)actionStr;
- (void)checkNewData;
- (void)showTipView:(NSInteger)index;

@end

@implementation QTTopicController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kTopicHiddenPopupMenuNotification object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initViews];
    self.dataList = [NSMutableArray array];
    
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self loadData];
    });
    self.timer = [NSTimer scheduledTimerWithTimeInterval:120 target:self selector:@selector(checkNewData) userInfo:nil repeats:YES];
    
    self.page = 1;
    [self.tableView headerWithRefreshingBlock:^{
        weakSelf.page +=1;
        [weakSelf loadMoreData];
    }];
    
    self.inputView.EwenTextViewBlock = ^(NSString *text){
        if ([[QTUserInfo sharedInstance] checkLoginStatus:weakSelf]) {
            [weakSelf sendComment:text];
        }
    };
    
    [[NSNotificationCenter defaultCenter] addObserverForName:kTopicHiddenPopupMenuNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        [weakSelf.tipView hide];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initViews
{
    self.viewWidth = CGRectGetWidth([[UIScreen mainScreen] bounds]);
    self.viewHeight = CGRectGetHeight([[UIScreen mainScreen] bounds]);
    [self.view addSubview:self.tableView];
    self.tableView.frame = CGRectMake(0, 0, self.viewWidth,
                                      self.viewHeight-64-50);
    
    [self.view addSubview:self.inputView];
    self.inputView.frame = CGRectMake(0, self.viewHeight-49-64, self.viewWidth, 49);
    
    [self.view addSubview:self.updataButton];
    self.updataButton.frame = CGRectMake(0, CGRectGetMaxY(self.tableView.frame)-35, self.viewWidth, 35);
    self.updataButton.hidden = YES;
}

- (void)loadData
{
    [QTCommentModel requestTopicCommentData:self.model.uuid page:1 completionHandler:^(NSArray<QTCommentModel *> *list, NSError *error) {
        if (error) {
            [QTProgressHUD showHUDText:error.userInfo[ERROR_MESSAGE]  view:self.view];
        } else {
            if (list.count > 0) {
                NSArray *dataArray = [[list reverseObjectEnumerator] allObjects];
                self.dataList = [NSMutableArray arrayWithArray:dataArray];
                [self.tableView reloadData];
                if (self.tableView.contentSize.height > self.tableView.frame.size.height) {
                    CGPoint offset = CGPointMake(0, self.tableView.contentSize.height - self.tableView.frame.size.height);
                    [self.tableView setContentOffset:offset animated:YES];
                }
                self.page = 1;
                self.updataButton.hidden = YES;
            }
        }
    }];
}

- (void)loadMoreData
{
    [QTCommentModel requestTopicCommentData:self.model.uuid page:self.page completionHandler:^(NSArray<QTCommentModel *> *list, NSError *error) {
        if (error) {
            [QTProgressHUD showHUDText:error.userInfo[ERROR_MESSAGE]  view:self.view];
        } else {
            [self.tableView endHeaderRefreshing];
            if (list.count > 0) {
                NSArray *array = [[list reverseObjectEnumerator] allObjects];
                [self.dataList insertObjects:array atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, array.count)]];
                [self.tableView reloadData];
                
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:array.count inSection:0];
                [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
            } else {
                self.page -= 1;
            }
        }
    }];
}

- (void)sendComment:(NSString *)text
{
    if (text.length <= 0) {
        return;
    }
    if (text.length > 300) {
        [QTMessage showWarningNotification:@"评论内容不能超过300个字!"];
        return;
    }
    NSString *topicUUID = self.model.uuid;
    NSString *userUUID = [QTUserInfo sharedInstance].uuid;
    [QTProgressHUD showHUD:self.view];
    [QTCommentModel requestForSendComment:topicUUID content:text userUUID:userUUID completionHandler:^(BOOL action, NSError *error) {
        if (action) {
            [QTProgressHUD showHUDSuccess];
            [self.inputView setOriginStatus];
            [self loadData];
        } else {
            [QTProgressHUD showHUDWithText:error.userInfo[ERROR_MESSAGE]];
        }
    }];
}

- (void)sendAgreeOrDisAgree:(QTCommentModel *)model action:(NSString *)actionStr
{
    [QTCommentModel requestForAgreeOrDisAgreeComment:model.uuid action:actionStr completionHandler:^(BOOL action, NSError *error) {
        if (action) {
            if ([actionStr isEqualToString:@"1"]) {
                model.like += 1;
            } else {
                model.dislike += 1;
            }
        } else {
            [QTProgressHUD showHUDText:error.userInfo[ERROR_MESSAGE] view:self.view];
        }
    }];
}

- (void)checkNewData
{
    [QTCommentModel requestTopicCommentData:self.model.uuid page:1 completionHandler:^(NSArray<QTCommentModel *> *list, NSError *error) {
        if (error) {
            [QTProgressHUD showHUDText:error.userInfo[ERROR_MESSAGE]  view:self.view];
        } else {
            if (list.count > 0) {
                NSArray *dataArray = [[list reverseObjectEnumerator] allObjects];
                if (self.dataList.count > 0) {
                    QTCommentModel *oldModel = self.dataList.lastObject;
                    QTCommentModel *newModel = dataArray.lastObject;
                    if (newModel._id > oldModel._id) {
                        self.updataButton.hidden = NO;
                    }
                }
            }
        }
    }];
}

- (void)showTipView:(NSInteger)index
{
    QTCommentModel *model = [self.dataList objectAtIndex:index];
    QTTipView *tipView = [QTTipView tipInView:self.view];
    NSString *agreeStr = [NSString stringWithFormat:@"赞同(%@)", [Tools countTransition:model.like]];
    NSString *disAgreeStr = [NSString stringWithFormat:@"不赞同(%@)", [Tools countTransition:model.dislike]];
    tipView.agreeString = agreeStr;
    tipView.disAgreeString = disAgreeStr;
    __weak typeof(self) weakSelf = self;
    [tipView setOnAgreeActionBlock:^{
        QTCommentModel *model = [weakSelf.dataList objectAtIndex:index];
        [weakSelf sendAgreeOrDisAgree:model action:@"1"];
    }];
    [tipView setOnDisagreeActionBlock:^{
        QTCommentModel *model = [weakSelf.dataList objectAtIndex:index];
        [weakSelf sendAgreeOrDisAgree:model action:@"2"];
    }];
    [tipView show];
    self.tipView = tipView;
}

#pragma mark - TableView Delegate And DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self) weakSelf = self;
    UITableViewCell *cell = nil;
    QTCommentModel *model = [self.dataList objectAtIndex:indexPath.row];
    if ([model.userUUID isEqualToString:[QTUserInfo sharedInstance].uuid]) {
        QTTopicRightCell *rightCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([QTTopicRightCell class])];
        [rightCell loadData:model.content avatar:model.avatar];
        [rightCell setOnTapHandler:^(NSInteger index) {
            [weakSelf showTipView:index];
        }];
        cell = rightCell;
    } else {
        QTTopicLeftCell *leftCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([QTTopicLeftCell class])];
        [leftCell loadData:model.content avatar:model.avatar];
        [leftCell setOnTapHandler:^(NSInteger index) {
            [weakSelf showTipView:index];
        }];
        cell = leftCell;
    }
    cell.tag = indexPath.row;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 100.0f;
    
    QTCommentModel *model = [self.dataList objectAtIndex:indexPath.row];
    if ([model.userUUID isEqualToString:[QTUserInfo sharedInstance].uuid]) {
        QTTopicRightCell *rightCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([QTTopicRightCell class])];
        height = [rightCell heightForCell:model.content];
    } else {
        QTTopicLeftCell *leftCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([QTTopicLeftCell class])];
        height = [leftCell heightForCell:model.content];
    }

    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
            tableView.translatesAutoresizingMaskIntoConstraints = NO;
            tableView.showsVerticalScrollIndicator = NO;
            tableView.exclusiveTouch = YES;
            tableView.backgroundColor = [UIColor clearColor];
//            tableView.contentInset = UIEdgeInsetsMake(5, 0, 0, 0);
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            [tableView registerClass:[QTTopicLeftCell class] forCellReuseIdentifier:NSStringFromClass([QTTopicLeftCell class])];
            [tableView registerClass:[QTTopicRightCell class] forCellReuseIdentifier:NSStringFromClass([QTTopicRightCell class])];
            tableView;
        });
    }
    return _tableView;
}

- (EwenTextView *)inputView
{
    if (_inputView == nil) {
        _inputView = [[EwenTextView alloc] init];
        _inputView.backgroundColor = [UIColor clearColor];
        [_inputView setPlaceholderText:@"写评论"];
    }
    return _inputView;
}

- (UIButton *)updataButton
{
    if (_updataButton == nil) {
        _updataButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:@"有新消息" forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            [button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage createImageWithColor:[UIColor colorFromHexValue:0xFFFFCC withAlpha:.98f]]
                              forState:UIControlStateNormal];
            [button addTarget:self action:@selector(loadData) forControlEvents:UIControlEventTouchUpInside];
            button;
        });
    }
    return _updataButton;
}

@end
