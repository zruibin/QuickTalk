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
#import "QBPopupMenu.h"
#import "QTCommentModel.h"
#import "EwenTextView.h"

NSString * const kTopicHiddenPopupMenuNotification = @"kTopicHiddenPopupMenuNotification";

@interface QTTopicController ()
<
UITableViewDataSource, UITableViewDelegate, QBPopupMenuDelegate
>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) EwenTextView *inputView;
@property (nonatomic, strong) NSMutableArray *dataList;
@property (nonatomic, assign) CGFloat viewWidth;
@property (nonatomic, assign) CGFloat viewHeight;
@property (nonatomic, assign) NSUInteger page;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, strong) QBPopupMenu *popupMenu;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UIButton *updataButton;

- (void)initViews;
- (void)loadData;
- (void)loadMoreData;
- (void)sendComment:(NSString *)text;
- (void)sendAgreeOrDisAgree:(QTCommentModel *)model action:(NSString *)actionStr;
- (void)checkNewData;

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
    
    [[NSNotificationCenter defaultCenter] addObserverForName:kTopicHiddenPopupMenuNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        [weakSelf.popupMenu dismissAnimated:YES];
    }];
    
    self.inputView.EwenTextViewBlock = ^(NSString *text){
        if ([[QTUserInfo sharedInstance] checkLoginStatus:weakSelf]) {
            [weakSelf sendComment:text];
        }
    };
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
    UITableViewCell *cell = nil;
    QTCommentModel *model = [self.dataList objectAtIndex:indexPath.row];
    if ([model.userUUID isEqualToString:[QTUserInfo sharedInstance].uuid]) {
        QTTopicRightCell *rightCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([QTTopicRightCell class])];
        [rightCell loadData:model.content avatar:model.avatar];
        cell = rightCell;
    } else {
        QTTopicLeftCell *leftCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([QTTopicLeftCell class])];
        
        [leftCell loadData:model.content avatar:model.avatar];
        cell = leftCell;
    }
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
    self.selectedIndex = indexPath.row;
    QTCommentModel *model = [self.dataList objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    CGRect frame = cell.frame;
    CGPoint point = [self.tableView contentOffset];//在内容视图的起源到滚动视图的原点偏移。
    frame.origin.y = cell.frame.origin.y - point.y;
    
    NSString *likeStr = [NSString stringWithFormat:@"  赞同(%@)", [Tools countTransition:model.like]];
    QBPopupMenuItem *item = [QBPopupMenuItem itemWithTitle:likeStr target:self
                                                    action:@selector(popupAgreeAction)];
    NSString *dislikeStr = [NSString stringWithFormat:@"不赞同(%@)", [Tools countTransition:model.dislike]];
    QBPopupMenuItem *item2 = [QBPopupMenuItem itemWithTitle:dislikeStr target:self
                                                     action:@selector(popupDisagreeAction)];
    self.popupMenu = [[QBPopupMenu alloc] initWithItems:@[item, item2]];
    self.popupMenu.cornerRadius = 6;
    self.popupMenu.height = 36;
    self.popupMenu.highlightedColor = [[UIColor colorWithRed:0 green:0.478 blue:1.0 alpha:1.0] colorWithAlphaComponent:0.8];
    [self.popupMenu showInView:self.tableView targetRect:frame animated:YES];
}

- (void)popupAgreeAction
{
    QTCommentModel *model = [self.dataList objectAtIndex:self.selectedIndex];
    [self sendAgreeOrDisAgree:model action:@"1"];
}

- (void)popupDisagreeAction
{
    QTCommentModel *model = [self.dataList objectAtIndex:self.selectedIndex];
    [self sendAgreeOrDisAgree:model action:@"2"];
}

#pragma mark - Touches Event

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.popupMenu dismissAnimated:YES];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.popupMenu dismissAnimated:YES];
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
