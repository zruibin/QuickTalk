//
//  QTMyNewsCommentController.m
//  QuickTalk
//
//  Created by  Ruibin.Chow on 2017/12/6.
//  Copyright © 2017年 www.creactism.com. All rights reserved.
//

#import "QTMyNewsCommentController.h"
#import "QTMyNewsCommentCell.h"
#import "QTCommentModel.h"
#import "QTTopicController.h"

@interface QTMyNewsCommentController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataList;
@property (nonatomic, assign) NSInteger page;

- (void)loadData;

@end

@implementation QTMyNewsCommentController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:QTLoginStatusChangeNotification object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initViews];
    
    __weak typeof(self) weakSelf = self;
    [[NSNotificationCenter defaultCenter] addObserverForName:QTLoginStatusChangeNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        if ([QTUserInfo sharedInstance].isLogin == NO) {
            [weakSelf.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(weakSelf.view);
            }];
            [weakSelf.dataList removeAllObjects];
            [weakSelf.tableView reloadData];
        } else {
            [weakSelf.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.and.right.and.bottom.equalTo(weakSelf.view);
                make.top.equalTo(weakSelf.view).offset(100);
            }];
            [weakSelf.tableView beginHeaderRefreshing];
        }
    }];
    
    [self.tableView headerWithRefreshingBlock:^{
        weakSelf.page = 1;
        weakSelf.dataList = [NSMutableArray array];
        [weakSelf loadData];
    }];
    [self.tableView beginHeaderRefreshing];
    
    [self.tableView footerWithRefreshingBlock:^{
        weakSelf.page += 1;
        [weakSelf loadData];
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initViews
{    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.bottom.equalTo(self.view);
        make.top.equalTo(self.view);
    }];
}

- (void)loadData
{
    if ([[QTUserInfo sharedInstance] checkLoginStatus:self] == NO) {
        [self.tableView endHeaderRefreshing];
        [self.tableView endFooterRefreshing];
        return;
    }
    [QTCommentModel requestMyCommentData:[QTUserInfo sharedInstance].uuid page:self.page completionHandler:^(NSArray<QTCommentModel *> *list, NSError *error) {
        if (error) {
            [QTProgressHUD showHUDText:error.userInfo[ERROR_MESSAGE] view:self.view];
        } else {
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
    QTTableViewCellMake(QTMyNewsCommentCell, cell);
    cell.tag = indexPath.section;
    QTCommentModel *model = self.dataList[indexPath.section];
    [cell loadData:model.content avatar:model.avatar time:model.time likeNum:model.like title:model.title];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 80.0f;
    QTTableViewCellMake(QTMyNewsCommentCell, cell);
    QTCommentModel *model = self.dataList[indexPath.section];
    height = [cell heightForCell:model.content];
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
    QTCommentModel *model = self.dataList[indexPath.section];
    QTTopicController *topicController = [[QTTopicController alloc] init];
    topicController.topicUUID = model.topicUUID;
    [self.navigationController pushViewController:topicController animated:YES];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.onScrollingHandler && self.dataList.count >= 10) {
        self.onScrollingHandler(scrollView.contentOffset.y);
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
            tableView.exclusiveTouch = YES;
            tableView.backgroundColor = [UIColor clearColor];
            tableView.contentInset = UIEdgeInsetsMake(5, 0, 0, 0);
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            QTTableViewCellRegister(tableView, QTMyNewsCommentCell);
            tableView;
        });
    }
    return _tableView;
}


@end
