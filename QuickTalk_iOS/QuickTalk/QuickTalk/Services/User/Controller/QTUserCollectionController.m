//
//  QTUserCollectionController.m
//  QuickTalk
//
//  Created by  Ruibin.Chow on 2017/12/20.
//  Copyright © 2017年 www.creactism.com. All rights reserved.
//

#import "QTUserCollectionController.h"
#import "QTUserPostModel.h"
#import "QTUserPostMainCell.h"
#import "QTUserController.h"
#import "QTUserPostCommentController.h"

@interface QTUserCollectionController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataList;
@property (nonatomic, strong) NSMutableDictionary *cacheHeightDict;
@property (nonatomic, strong) QTErrorView *errorView;
@property (nonatomic, assign) NSInteger page;

- (void)initViews;
- (void)loadData;
- (void)arrowHandlerAction:(NSInteger)index;
- (void)unCollectionData:(QTUserPostModel *)model;
- (void)addReadCountAction:(NSInteger)index;
- (void)likeOrUnLikeAction:(NSInteger)index;

@end

@implementation QTUserCollectionController

- (void)viewDidLoad
{
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initViews
{
    self.title = @"我的收藏";
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.view addSubview:self.errorView];
}

- (void)loadData
{
    [QTUserPostModel requestCollectionData:self.page userUUID:self.userUUID type:@"1" completionHandler:^(NSArray<QTUserPostModel *> *list, NSError *error) {
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
    void(^deleteHandler)(NSInteger index) = ^(NSInteger index){
        [weakSelf unCollectionData:model];
    };
    NSArray *items = @[
                       MMItemMake(@"取消收藏", MMItemTypeHighlight, deleteHandler)
                       ];
    MMSheetView *sheetView = [[MMSheetView alloc] initWithTitle:@""
                                                          items:items];
    sheetView.attachedView.mm_dimBackgroundBlurEnabled = NO;
    [sheetView show];
}

- (void)unCollectionData:(QTUserPostModel *)model
{
    [QTUserPostModel requestUserCollectionAction:model.uuid userUUID:[QTUserInfo sharedInstance].uuid action:COLLECTION_ACTION_OFF completionHandler:^(BOOL action, NSError *error) {
        if (action) {
            [QTProgressHUD showHUDText:@"取消收藏成功" view:self.view];
            [self.dataList removeObject:model];
            [self.tableView reloadData];
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
