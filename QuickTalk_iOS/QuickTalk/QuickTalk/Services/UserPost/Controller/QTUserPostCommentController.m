//
//  QTUserPostCommentController.m
//  QuickTalk
//
//  Created by  Ruibin.Chow on 2017/12/6.
//  Copyright © 2017年 www.creactism.com. All rights reserved.
//

#import "QTUserPostCommentController.h"
#import "QTUserPostCommentCell.h"
#import "EwenTextView.h"
#import "QTTopicLeftCell.h"
#import "QTTopicRightCell.h"
#import "QTUserPostCommentModel.h"
#import "QTUserController.h"


@interface QTUserPostCommentController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) EwenTextView *inputView;
@property (nonatomic, strong) NSMutableArray *dataList;
@property (nonatomic, assign) CGFloat viewWidth;
@property (nonatomic, assign) CGFloat viewHeight;
@property (nonatomic, assign) NSInteger page;

- (void)initViews;
- (void)loadData;
- (void)loadMoreData;
- (void)sendComment:(NSString *)text;
- (void)checkNewData;
- (void)tapCellHandler:(NSInteger)index;
- (void)deleteComment:(QTUserPostCommentModel *)model;

@end

@implementation QTUserPostCommentController
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initViews];
    self.dataList = [NSMutableArray array];
    self.page = 1;
    [self loadData];
    [self setDataViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initViews
{
    self.title = @"讨论";
    
    self.viewWidth = CGRectGetWidth([[UIScreen mainScreen] bounds]);
    self.viewHeight = CGRectGetHeight([[UIScreen mainScreen] bounds]);
    [self.view addSubview:self.tableView];
    self.tableView.frame = CGRectMake(0, 0, self.viewWidth,
                                      self.viewHeight-64-50);
    
    [self.view addSubview:self.inputView];
    self.inputView.frame = CGRectMake(0, self.viewHeight-49-64, self.viewWidth, 49);
}

- (void)setDataViews
{
    __weak typeof(self) weakSelf = self;
    
    self.page = 1;
    [self.tableView headerWithRefreshingBlock:^{
        weakSelf.page +=1;
        [weakSelf loadMoreData];
    }];
    [self.tableView footerWithRefreshingBlock:^{
        [weakSelf checkNewData];
    }];
    
    self.inputView.EwenTextViewBlock = ^(NSString *text){
        if ([[QTUserInfo sharedInstance] checkLoginStatus:weakSelf]) {
            [weakSelf sendComment:text];
        }
    };
    [self.inputView setKeyboardActionBlock:^(BOOL hide, CGFloat height) {
        if (hide) {
            weakSelf.tableView.frame = CGRectMake(0, 0, weakSelf.viewWidth, weakSelf.viewHeight-64-50);
            if (weakSelf.tableView.contentSize.height > weakSelf.tableView.frame.size.height) {
                CGPoint offset = CGPointMake(0, weakSelf.tableView.contentSize.height - weakSelf.tableView.frame.size.height);
                [weakSelf.tableView setContentOffset:offset animated:YES];
            }
        } else {
            if (weakSelf.tableView.contentSize.height > weakSelf.tableView.frame.size.height) {
                weakSelf.tableView.frame = CGRectMake(0, -(height+20), weakSelf.viewWidth, weakSelf.viewHeight);
                CGPoint offset = CGPointMake(0, weakSelf.tableView.contentSize.height - weakSelf.tableView.frame.size.height);
                [weakSelf.tableView setContentOffset:offset animated:YES];
            }
        }
    }];
}

- (void)loadData
{
    [QTUserPostCommentModel requestUserPostCommentData:self.uuid page:self.page completionHandler:^(NSArray<QTUserPostCommentModel *> *list, NSError *error) {
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
            }
        }
    }];
}

- (void)loadMoreData
{
    [QTUserPostCommentModel requestUserPostCommentData:self.uuid page:self.page completionHandler:^(NSArray<QTUserPostCommentModel *> *list, NSError *error) {
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
    if ([[QTUserInfo sharedInstance] checkLoginStatus:self] == NO) {
        return ;
    }
    if (text.length > 300) {
        [QTMessage showErrorNotification:@"评论内容不能超过300个字!"];
        return;
    }

    NSString *userUUID = [QTUserInfo sharedInstance].uuid;
    [QTProgressHUD showHUD:self.view];
    [QTUserPostCommentModel requestForSendComment:self.uuid content:text userUUID:userUUID isReply:NO replyUUID:nil completionHandler:^(BOOL action, NSError *error) {
        if (action) {
            [QTProgressHUD showHUDSuccess];
            [self.inputView setOriginStatus];
            [self loadData];
        } else {
            [QTProgressHUD showHUDWithText:error.userInfo[ERROR_MESSAGE]];
        }
    }];
}

- (void)checkNewData
{
    [QTUserPostCommentModel requestUserPostCommentData:self.uuid page:1 completionHandler:^(NSArray<QTUserPostCommentModel *> *list, NSError *error) {
        if (error) {
            [QTProgressHUD showHUDText:error.userInfo[ERROR_MESSAGE]  view:self.view];
        } else {
            if (list.count > 0) {
                NSArray *dataArray = [[list reverseObjectEnumerator] allObjects];
                if (self.dataList.count > 0) {
                    QTUserPostCommentModel *oldModel = self.dataList.lastObject;
                    QTUserPostCommentModel *newModel = dataArray.lastObject;
                    if (newModel._id > oldModel._id) {
                        [self.tableView reloadData];
                    }
                }
            }
            [self.tableView endFooterRefreshing];
        }
    }];
}

- (void)tapCellHandler:(NSInteger)index
{
    QTUserPostCommentModel *model = [self.dataList objectAtIndex:index];
    __weak typeof(self) weakSelf = self;
    void(^reportHandler)(NSInteger index) = ^(NSInteger index){
        [QTProgressHUD showHUD:weakSelf.view];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [QTProgressHUD showHUDWithText:@"举报成功" delay:2.0f];
        });
    };
    void(^deleteHandler)(NSInteger index) = ^(NSInteger index){
        MMPopupItemHandler block = ^(NSInteger index) {
            [weakSelf deleteComment:model];
        };
        NSArray *items = @[MMItemMake(@"删除", MMItemTypeHighlight, block),
                           MMItemMake(@"取消", MMItemTypeNormal, nil)];
        MMAlertView *view = [[MMAlertView alloc] initWithTitle:@"是否删除" detail:@"" items:items];
        [view show];
    };
    if ([model.userUUID isEqualToString:[QTUserInfo sharedInstance].uuid]) {
        NSArray *items = @[MMItemMake(@"删除评论", MMItemTypeHighlight, deleteHandler)];
        MMSheetView *sheetView = [[MMSheetView alloc] initWithTitle:@""
                                                              items:items];
        sheetView.attachedView.mm_dimBackgroundBlurEnabled = NO;
        [sheetView show];
    } else if ([[QTUserInfo sharedInstance] hiddenData] == NO) {
        NSArray *items = @[MMItemMake(@"举报", MMItemTypeHighlight, reportHandler)];
        MMSheetView *sheetView = [[MMSheetView alloc] initWithTitle:@""
                                                              items:items];
        sheetView.attachedView.mm_dimBackgroundBlurEnabled = NO;
        [sheetView show];
    }
}

- (void)deleteComment:(QTUserPostCommentModel *)model
{
    [QTProgressHUD showHUD:self.view];
    [QTUserPostCommentModel requestForDeleteComment:self.uuid commentUUID:model.uuid userUUID:model.userUUID completionHandler:^(BOOL action, NSError *error) {
        if (action) {
            [QTProgressHUD showHUDSuccess];
            [self.dataList removeObject:model];
            [self.tableView reloadData];;
        } else {
            [QTProgressHUD showHUDWithText:error.userInfo[ERROR_MESSAGE]];
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
    __weak typeof(self) weakSelf = self;
    UITableViewCell *cell = nil;
    QTUserPostCommentModel *model = [self.dataList objectAtIndex:indexPath.row];
    if ([model.userUUID isEqualToString:[QTUserInfo sharedInstance].uuid]) {
        QTTopicRightCell *rightCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([QTTopicRightCell class])];
        [rightCell loadData:model.content avatar:model.avatar];
        [rightCell setOnAvatarHandler:^{
            QTUserController *userController = [[QTUserController alloc] init];
            userController.userUUID = model.userUUID;
            userController.nickname = model.nickname;
            [weakSelf.navigationController pushViewController:userController animated:YES];
        }];
        [rightCell setOnTapHandler:^(NSInteger index) {
            [weakSelf tapCellHandler:index];
        }];
        cell = rightCell;
    } else {
        QTTopicLeftCell *leftCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([QTTopicLeftCell class])];
        [leftCell loadData:model.content avatar:model.avatar];
        [leftCell setOnAvatarHandler:^{
            QTUserController *userController = [[QTUserController alloc] init];
            userController.userUUID = model.userUUID;
            userController.nickname = model.nickname;
            [weakSelf.navigationController pushViewController:userController animated:YES];
        }];
        [leftCell setOnTapHandler:^(NSInteger index) {
            [weakSelf tapCellHandler:index];
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
    
    QTUserPostCommentModel *model = [self.dataList objectAtIndex:indexPath.row];
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

#pragma mark - Action


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

@end
