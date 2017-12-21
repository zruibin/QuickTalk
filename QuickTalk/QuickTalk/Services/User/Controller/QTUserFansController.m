//
//  QTUserFansController.m
//  QuickTalk
//
//  Created by  Ruibin.Chow on 2017/12/20.
//  Copyright © 2017年 www.creactism.com. All rights reserved.
//

#import "QTUserFansController.h"
#import "QTUserCell.h"
#import "QTUserModel.h"
#import "QTUserController.h"

@interface QTUserFansController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataList;
@property (nonatomic, strong) QTErrorView *errorView;
@property (nonatomic, assign) NSInteger page;

- (void)initViews;
- (void)loadData;
- (void)starOrUnStarAction:(NSInteger)index;

@end

@implementation QTUserFansController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initViews];
    
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
    self.title = @"粉丝";
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.view addSubview:self.errorView];
}

- (void)loadData
{
    [QTUserModel requestForFans:self.page userUUID:self.userUUID relationUserUUID:[QTUserInfo sharedInstance].uuid completionHandler:^(NSArray<QTUserModel *> *list, NSError *error) {
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

- (void)starOrUnStarAction:(NSInteger)index
{
    QTUserModel *model = self.dataList[index];
    NSString *action = STAR_ACTION_FOR_STAR;
    if (model.relationStatus == QTUserRelationStar) {
        action = STAR_ACTION_FOR_UNSTAR;
    }
    [QTUserModel requestForStarOrUnStar:self.userUUID contentUUID:model.uuid action:action completionHandler:^(BOOL action, NSError *error) {
        if (error) {
            [QTProgressHUD showHUDText:error.userInfo[ERROR_MESSAGE] view:self.view];
        } else {
            if (model.relationStatus == QTUserRelationStar) {
                model.relationStatus = QTUserRelationDefault;
            } else {
                model.relationStatus = QTUserRelationStar;
            }
            [self.tableView reloadData];
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
    QTTableViewCellMake(QTUserCell, cell)
    cell.tag = indexPath.row;
    QTUserModel *model = self.dataList[indexPath.row];
    [cell loadData:model.avatar nickname:model.nickname subname:nil];
    if (model.relationStatus == QTUserRelationDefault) {
        cell.relationStatus = QTViewRelationDefault;
    } else {
        cell.relationStatus = QTViewRelationStarAndBeStar;
    }
    
    __weak typeof(self) weakSelf = self;
    [cell setOnAvatarHandler:^(NSInteger index) {
        QTUserController *userController = [[QTUserController alloc] init];
        QTUserModel *userModel = weakSelf.dataList[index];
        userController.userUUID = userModel.uuid;
        [weakSelf.navigationController pushViewController:userController animated:YES];
    }];
    [cell setOnActionHandler:^(NSInteger index) {
        [weakSelf starOrUnStarAction:index];
    }];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark - Action


#pragma mark - getter and setter

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = ({
            UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
            tableView.backgroundColor = [UIColor yellowColor];
            tableView.estimatedRowHeight = 0;
            tableView.estimatedSectionHeaderHeight = 0;
            tableView.estimatedSectionFooterHeight = 0;
            tableView.delegate = self;
            tableView.dataSource = self;
            tableView.translatesAutoresizingMaskIntoConstraints = NO;
            tableView.showsVerticalScrollIndicator = NO;
            tableView.exclusiveTouch = YES;
            tableView.backgroundColor = [UIColor clearColor];
            tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
            tableView.tableFooterView = [UIView new];
            QTTableViewCellRegister(tableView, QTUserCell)
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
