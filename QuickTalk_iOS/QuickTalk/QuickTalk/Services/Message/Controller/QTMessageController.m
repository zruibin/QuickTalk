//
//  QTMessageController.m
//  QuickTalk
//
//  Created by  Ruibin.Chow on 2017/12/25.
//  Copyright © 2017年 www.creactism.com. All rights reserved.
//

#import "QTMessageController.h"
#import "QTMessageCell.h"
#import "QTMessageModel.h"
#import "QTUserPostModel.h"
#import "QTUserController.h"
#import "QTUserPostCommentController.h"

@interface QTMessageController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataList;
@property (nonatomic, strong) QTErrorView *errorView;
@property (nonatomic, assign) NSInteger page;

- (void)initViews;
- (void)loadData;

@end

@implementation QTMessageController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initViews];
    
    YYCache *cache = [YYCache cacheWithName:QTDataCache];
    [cache setObject:[NSNumber numberWithInteger:0] forKey:QTMessageCount];
    
    __weak typeof(self) weakSelf = self;
    [self.tableView headerWithRefreshingBlock:^{
        weakSelf.errorView.hidden = YES;
        weakSelf.page = 1;
        weakSelf.dataList = [NSMutableArray array];
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
    self.title = @"消息";
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.view addSubview:self.errorView];
}

- (void)loadData
{
    [QTMessageModel requestMessageData:self.page userUUID:self.userUUID completionHandler:^(NSArray<QTMessageModel *> *list, NSError *error) {
        if (error) {
            [QTProgressHUD showHUDText:error.userInfo[ERROR_MESSAGE] view:self.view];
            [self.tableView showFooter];
            [self.tableView endFooterRefreshing];
            [self.tableView endHeaderRefreshing];
        } else {
            [self.tableView showFooter];
            if (list.count < 10) {
                [self.tableView endRefreshingWithNoMoreData];
            } else {
                [self.tableView endFooterRefreshing];
            }
            [self.tableView endHeaderRefreshing];
            [QTProgressHUD showHUDSuccess];
            [self.dataList addObjectsFromArray:list];
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
    QTTableViewCellMake(QTMessageCell, cell)
    cell.tag = indexPath.section;
    QTMessageModel *model = self.dataList[indexPath.section];
    [cell loadData:model];
    __weak typeof(self) weakSelf = self;
    [cell setOnHrefHandler:^(NSInteger index) {
        QTMessageModel *hrefModel = weakSelf.dataList[index];
        NSString *url = hrefModel.content;
        [Tools openWeb:url viewController:weakSelf];
    }];
    [cell setOnInfoHandler:^(NSInteger index) {
        QTMessageModel *userModel = weakSelf.dataList[index];
        QTUserController *userController = [[QTUserController alloc] init];
        userController.userUUID = userModel.userUUID;
        userController.nickname = userModel.nickname;
        [weakSelf.navigationController pushViewController:userController animated:YES];
    }];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QTTableViewCellMake(QTMessageCell, cell)
    QTMessageModel *model = self.dataList[indexPath.section];
    
    return [cell heightForCell:model];
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
    QTMessageModel *model = self.dataList[indexPath.section];
    if (model.type == QTMessageUserPostLike || model.type == QTMessageUserPostComment) {
        QTUserPostCommentController *userPostCommentController = [[QTUserPostCommentController alloc] init];
        userPostCommentController.uuid = model.userPostUUID;
        [self.navigationController pushViewController:userPostCommentController animated:YES];
    } else {
        QTUserController *userController = [[QTUserController alloc] init];
        userController.userUUID = model.userUUID;
        userController.nickname = model.nickname;
        [self.navigationController pushViewController:userController animated:YES];
    }
    
}

#pragma mark - Action


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
            tableView.showsHorizontalScrollIndicator = NO;
            tableView.exclusiveTouch = YES;
            tableView.backgroundColor = [UIColor clearColor];
            tableView.contentInset = UIEdgeInsetsMake(5, 0, 0, 0);
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            tableView.tableFooterView = [UIView new];
            QTTableViewCellRegister(tableView, QTMessageCell)
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
