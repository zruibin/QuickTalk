//
//  QTUserStarController.m
//  QuickTalk
//
//  Created by  Ruibin.Chow on 2017/12/20.
//  Copyright © 2017年 www.creactism.com. All rights reserved.
//

#import "QTUserStarController.h"
#import "QTUserStarButton.h"
#import "QTUserSearchController.h"
#import "QTUserContactBookController.h"
#import "QTUserCell.h"
#import "QTUserModel.h"
#import "QTUserController.h"


@interface QTUserStarController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataList;
@property (nonatomic, strong) QTErrorView *errorView;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) UIView *headerView;

- (void)initViews;
- (void)loadData;

@end

@implementation QTUserStarController

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
    [self.tableView hiddenFooter];
    
    self.errorView.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initViews
{
    self.title = @"关注";

    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.view addSubview:self.errorView];
    
    if (self.showHeader) {
        self.tableView.tableHeaderView = self.headerView;
    }
}

- (void)loadData
{
    [QTUserModel requestForStarUser:self.page userUUID:self.userUUID
                   relationUserUUID:[QTUserInfo sharedInstance].uuid
                  completionHandler:^(NSArray<QTUserModel *> *list, NSError *error) {
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
            [self.dataList addObjectsFromArray:list];
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
    return self.dataList.count;;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QTTableViewCellMake(QTUserCell, cell)
    cell.tag = indexPath.row;
    QTUserModel *model = self.dataList[indexPath.row];
    [cell loadData:model.avatar nickname:model.nickname subname:nil];
    cell.relationStatus = QTViewRelationHidden;
    
    __weak typeof(self) weakSelf = self;
    [cell setOnAvatarHandler:^(NSInteger index) {
        QTUserController *userController = [[QTUserController alloc] init];
        QTUserModel *userModel = weakSelf.dataList[index];
        userController.userUUID = userModel.uuid;
        [weakSelf.navigationController pushViewController:userController animated:YES];
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
    QTUserController *userController = [[QTUserController alloc] init];
    QTUserModel *userModel = self.dataList[indexPath.row];
    userController.userUUID = userModel.uuid;
    [self.navigationController pushViewController:userController animated:YES];
}

#pragma mark - Action

- (void)searchAction
{
    QTUserSearchController *searchController = [[QTUserSearchController alloc] init];
    [self.navigationController pushViewController:searchController animated:YES];
}


- (void)contactBookAction
{
    QTUserContactBookController *contactBookController = [[QTUserContactBookController alloc] init];
    [self.navigationController pushViewController:contactBookController animated:YES];
}

#pragma mark - getter and setter

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = ({
            UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
            tableView.backgroundColor = [UIColor redColor];
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

- (UIView *)headerView
{
    if (_headerView == nil) {
        _headerView = ({
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 150)];
            
            QTUserStarButton *searchButton = [[QTUserStarButton alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 55)];
            searchButton.backgroundColor = [UIColor whiteColor];
            [searchButton setBackgroundImage:[UIImage createImageWithColor:[UIColor colorFromHexValue:0x000 withAlpha:.4]] forState:UIControlStateHighlighted];
            searchButton.icon = [UIImage imageNamed:@"search"];
            searchButton.text = @"搜索";
            searchButton.detailText = @"通过手机号与昵称搜索";
            [searchButton addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:searchButton];
            [Tools drawBorder:searchButton top:NO left:NO bottom:YES right:NO
                  borderColor:[UIColor colorFromHexValue:0xE4E4E4] borderWidth:.5f];
            
            QTUserStarButton *contactButton = [[QTUserStarButton alloc] initWithFrame:CGRectMake(0, 55 , CGRectGetWidth(self.view.bounds), 55)];
            contactButton.backgroundColor = [UIColor whiteColor];
            [contactButton setBackgroundImage:[UIImage createImageWithColor:[UIColor colorFromHexValue:0x000 withAlpha:.4]] forState:UIControlStateHighlighted];
            contactButton.icon = [UIImage imageNamed:@"contact"];
            contactButton.text = @"通讯录";
            contactButton.detailText = @"添加通讯录的朋友";
            [contactButton addTarget:self action:@selector(contactBookAction) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:contactButton];
            
            UILabel *label = [UILabel new];
            label.frame = CGRectMake(10, 125, CGRectGetWidth(self.view.bounds)-20, 20);
            label.textColor = [UIColor colorFromHexValue:0x585858];
            label.font = [UIFont systemFontOfSize:12];
            label.text = @"我的关注";
            [view addSubview:label];
            
            view;
        });
    }
    return _headerView;
}


@end
