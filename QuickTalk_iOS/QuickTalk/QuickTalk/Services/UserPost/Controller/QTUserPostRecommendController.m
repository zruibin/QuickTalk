//
//  QTUserPostRecommendController.m
//  QuickTalk
//
//  Created by  Ruibin.Chow on 08/01/2018.
//  Copyright © 2018 www.creactism.com. All rights reserved.
//

#import "QTUserPostRecommendController.h"
#import "QTUserPostAddController.h"
#import "QTUserPostModel.h"
#import "QTUserPostMainCell.h"
#import "QTUserPostCommentController.h"
#import "QTIntroController.h"
#import "QTUserController.h"

@interface QTUserPostRecommendController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataList;
@property (nonatomic, strong) NSMutableDictionary *cacheHeightDict;
@property (nonatomic, strong) QTErrorView *errorView;
@property (nonatomic, assign) NSInteger page;

- (void)initViews;
- (void)loadData;
- (void)arrowHandlerAction:(NSInteger)index;
- (void)deleteData:(QTUserPostModel *)model;
- (void)shareData:(QTUserPostModel *)model;
- (void)collectionData:(QTUserPostModel *)model;
- (void)addReadCountAction:(NSInteger)index;
- (void)likeOrUnLikeAction:(NSInteger)index;


@end

@implementation QTUserPostRecommendController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:QTLoginStatusChangeNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initViews];
    
    __weak typeof(self) weakSelf = self;
    [self.tableView headerWithRefreshingBlock:^{
        weakSelf.errorView.hidden = YES;
        weakSelf.page = 1;
        weakSelf.dataList = [NSMutableArray array];
        weakSelf.cacheHeightDict = [NSMutableDictionary dictionary];
        [weakSelf loadData];
    }];
    [self.tableView beginHeaderRefreshing];
    
    [self.tableView footerWithRefreshingBlock:^{
        weakSelf.page += 1;
        [weakSelf loadData];
    }];
    
    self.errorView.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)initViews
{
    self.title = @"推荐";
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.view addSubview:self.errorView];
    
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc]
                                initWithImage:[UIImage imageNamed:@"add"]
                                style:UIBarButtonItemStylePlain target:self action:@selector(addAction)];
    self.navigationItem.rightBarButtonItem = addItem;
}

- (void)loadData
{
    [QTUserPostModel requestRecommendUserPostData:self.page relationUserUUID:[QTUserInfo sharedInstance].uuid completionHandler:^(NSArray<QTUserPostModel *> *list, NSError *error) {
        if (error) {
            [QTProgressHUD showHUDText:error.userInfo[ERROR_MESSAGE] view:self.view];
            if (self.page == 1) {
                self.errorView.hidden = NO;
            }
            [self.tableView endHeaderRefreshing];
            [self.tableView endFooterRefreshing];
        } else {
            self.errorView.hidden = YES;
            [self.dataList addObjectsFromArray:[list copy]];
            if (self.page == 1) {
                [self.tableView endHeaderRefreshing];
                if (list.count < 10) {
                    [self.tableView hiddenFooter];
                }
                [self.tableView endFooterRefreshing];
            } else {
                if (list.count < 10) {
                    [self.tableView endRefreshingWithNoMoreData];
                } else {
                    [self.tableView endFooterRefreshing];
                }
            }
            [self.tableView reloadData];
        }
    }];
}

- (void)arrowHandlerAction:(NSInteger)index
{
    QTUserPostModel *model = self.dataList[index];
    
    __weak typeof(self) weakSelf = self;
    void(^reportHandler)(NSInteger index) = ^(NSInteger index){
        [QTProgressHUD showHUD:weakSelf.view];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [QTProgressHUD showHUDWithText:@"举报成功" delay:2.0f];
        });
    };
    void(^deleteHandler)(NSInteger index) = ^(NSInteger index){
        MMPopupItemHandler block = ^(NSInteger index) {
            [weakSelf deleteData:model];
        };
        NSArray *items = @[MMItemMake(@"删除", MMItemTypeHighlight, block),
                           MMItemMake(@"取消", MMItemTypeNormal, nil)];
        MMAlertView *view = [[MMAlertView alloc] initWithTitle:@"是否删除" detail:@"" items:items];
        [view show];
    };
    void(^collectionHandler)(NSInteger index) = ^(NSInteger index){
        [weakSelf collectionData:model];
    };
    
    NSArray *items = @[];
    if ([model.userUUID isEqualToString:[QTUserInfo sharedInstance].uuid]) {
        items = @[
                  MMItemMake(@"删除", MMItemTypeHighlight, deleteHandler)
                  ,MMItemMake(@"收藏", MMItemTypeNormal, collectionHandler)
                  ];
    } else {// if ([[QTUserInfo sharedInstance] hiddenData] == NO) {
        items = @[
                  MMItemMake(@"举报", MMItemTypeHighlight, reportHandler)
                  ,MMItemMake(@"收藏", MMItemTypeNormal, collectionHandler)
                  ];
    }
    MMSheetView *sheetView = [[MMSheetView alloc] initWithTitle:@""
                                                          items:items];
    sheetView.attachedView.mm_dimBackgroundBlurEnabled = NO;
    [sheetView show];
}

- (void)deleteData:(QTUserPostModel *)model
{
    [QTUserPostModel requestDeleteUserPost:[QTUserInfo sharedInstance].uuid userPostUUID:model.uuid completionHandler:^(BOOL action, NSError *error) {
        if (action) {
            [self.dataList removeObject:model];
            [self.cacheHeightDict removeAllObjects];
            [self.tableView reloadData];;
        } else {
            [QTProgressHUD showHUDText:error.userInfo[ERROR_MESSAGE] view:self.view];
        }
    }];
}

- (void)shareData:(QTUserPostModel *)model
{
    
}

- (void)collectionData:(QTUserPostModel *)model
{
    if ([[QTUserInfo sharedInstance] checkLoginStatus:self] == NO) {
        return ;
    }
    [QTUserPostModel requestUserCollectionAction:model.uuid userUUID:[QTUserInfo sharedInstance].uuid action:COLLECTION_ACTION_ON completionHandler:^(BOOL action, NSError *error) {
        if (action) {
            [QTProgressHUD showHUDText:@"收藏成功" view:self.view];
        } else {
            [QTProgressHUD showHUDText:error.userInfo[ERROR_MESSAGE] view:self.view];
        }
    }];
}

- (void)addReadCountAction:(NSInteger)index
{
    QTUserPostModel *model = self.dataList[index];
    [QTUserPostModel requestAddUserPostReadCount:model.uuid completionHandler:nil];
}

- (void)likeOrUnLikeAction:(NSInteger)index
{
    if ([[QTUserInfo sharedInstance] checkLoginStatus:self] == NO) {
        return ;
    }
    QTUserPostModel *model = self.dataList[index];
    NSString *action = LIKE_ACTION_AGREE;
    if (model.liked == YES) {
        action = LIKE_ACTION_DISAGREE;
    }
    [QTUserPostModel requestForUserPostLikeOrUnLike:[QTUserInfo sharedInstance].uuid contentUUID:model.uuid action:action completionHandler:^(BOOL action, NSError *error) {
        if (error) {
            [QTProgressHUD showHUDText:error.userInfo[ERROR_MESSAGE] view:self.view];
        } else {
            if (model.liked) {
                NSMutableArray *likeList = [NSMutableArray array];
                for (QTUserPostLikeModel *likeMode in model.likeList) {
                    if ([likeMode.userUUID isEqualToString:[QTUserInfo sharedInstance].uuid] == NO) {
                        [likeList addObject:likeMode];
                    }
                }
                model.likeList = [likeList copy];
            } else {
                QTUserPostLikeModel *likeMode = [[QTUserPostLikeModel alloc] init];
                likeMode.userUUID = [QTUserInfo sharedInstance].uuid;
                likeMode.nickname = [QTUserInfo sharedInstance].nickname;
                likeMode.avatar = [QTUserInfo sharedInstance].avatar;
                likeMode.userId = [QTUserInfo sharedInstance]._id;
                NSMutableArray *likeList = [NSMutableArray arrayWithArray:model.likeList];
                [likeList addObject:likeMode];
                model.likeList = [likeList copy];
            }
            [self.cacheHeightDict removeAllObjects];
            model.liked = !model.liked;
            [self.tableView reloadData];
        }
    }];
}

#pragma mark - TableView Delegate And DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QTTableViewCellMake(QTUserPostMainCell, cell);
    cell.tag = indexPath.section;
    QTUserPostModel *model = self.dataList[indexPath.section];
    [cell loadData:model];
    __weak typeof(self) weakSelf = self;
    [cell setOnHrefHandler:^(NSInteger index) {
        QTUserPostModel *hrefModel = weakSelf.dataList[index];
        NSString *url = hrefModel.content;
        [Tools openWeb:url viewController:weakSelf];
        [weakSelf addReadCountAction:index];
    }];
    [cell setOnArrowHandler:^(NSInteger index) {
        [weakSelf arrowHandlerAction:index];
    }];
    [cell setOnInfoHandler:^(NSInteger index) {
        QTUserPostModel *userModel = weakSelf.dataList[index];
        QTUserController *userController = [[QTUserController alloc] init];
        userController.userUUID = userModel.userUUID;
        userController.nickname = userModel.nickname;
        [weakSelf.navigationController pushViewController:userController animated:YES];
    }];
    [cell setOnlikeIconTouchHandler:^(NSInteger index, NSInteger likeIndex) {
        QTUserPostModel *userModel = weakSelf.dataList[index];
        QTUserPostLikeModel *likeModel = userModel.likeList[likeIndex];
        QTUserController *userController = [[QTUserController alloc] init];
        userController.userUUID = likeModel.userUUID;
        userController.nickname = likeModel.nickname;
        [weakSelf.navigationController pushViewController:userController animated:YES];
    }];
    [cell setOnDidLikeHandler:^(NSInteger index) {
        [weakSelf likeOrUnLikeAction:index];
    }];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 60.0f;
    QTTableViewCellMake(QTUserPostMainCell, cell);
    if ([self.cacheHeightDict.allKeys containsObject:[NSNumber numberWithInteger:indexPath.section]]) {
        height = [[self.cacheHeightDict objectForKey:[NSNumber numberWithInteger:indexPath.section]] floatValue];
    } else {
        QTUserPostModel *model = self.dataList[indexPath.section];
        height = [cell heightForCell:model];
        [self.cacheHeightDict setObject:[NSNumber numberWithFloat:height]
                                 forKey:[NSNumber numberWithInteger:indexPath.section]];
    }
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    /*顶部和第一行数据之间的间隔要将0改为一个非0的数值即可实现*/
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    QTUserPostModel *model = self.dataList[indexPath.section];
    QTUserPostCommentController *userPostCommentController = [[QTUserPostCommentController alloc] init];
    userPostCommentController.uuid = model.uuid;
    [self.navigationController pushViewController:userPostCommentController animated:YES];
    [self addReadCountAction:indexPath.section];
}

#pragma mark - Action

- (void)addAction
{
    if ([[QTUserInfo sharedInstance] checkLoginStatus:self]) {
        QTUserPostAddController *addController = [[QTUserPostAddController alloc] init];
        QTNavigationController *nav = [[QTNavigationController alloc] initWithRootViewController:addController];
        [self presentViewController:nav animated:YES completion:nil];
    }
}

#pragma mark - getter and setter

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = ({
            UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
            tableView.estimatedRowHeight = 0;
            tableView.estimatedSectionHeaderHeight = 0;
            tableView.estimatedSectionFooterHeight = 0;
            tableView.delegate = self;
            tableView.dataSource = self;
            tableView.translatesAutoresizingMaskIntoConstraints = NO;
            tableView.showsVerticalScrollIndicator = NO;
            tableView.exclusiveTouch = YES;
            tableView.backgroundColor = [UIColor clearColor];
            tableView.contentInset = UIEdgeInsetsMake(5, 0, 0, 0);
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            QTTableViewCellRegister(tableView, QTUserPostMainCell);
            tableView;
        });
    }
    return _tableView;
}

- (QTErrorView *)errorView
{
    if (_errorView == nil) {
        _errorView = ({
            QTErrorView *view = [[QTErrorView alloc] initWithFrame:self.view.bounds];
            __weak typeof(self) weakSelf = self;
            [view setOnRefreshHandler:^{
                [weakSelf.tableView beginHeaderRefreshing];
            }];
            view;
        });
    }
    return _errorView;
}

@end



