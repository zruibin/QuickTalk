//
//  QTMainViewController.m
//  QuickTalk
//
//  Created by  Ruibin.Chow on 2017/10/16.
//  Copyright © 2017年 www.creactism.com. All rights reserved.
//

#import "QTMainViewController.h"
#import "QTTopicController.h"
#import "QTTopicModel.h"
#import "QTIntroController.h"
#import "QTMainCell.h"

@interface QTMainViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableDictionary *actionDict;
@property (nonatomic, strong) NSMutableArray *childControllers;
@property (nonatomic, strong) NSMutableArray *dataList;
@property (nonatomic, assign) CGFloat viewWidth;
@property (nonatomic, assign) CGFloat viewHeight;
@property (nonatomic, strong) UIView *errorView;
@property (nonatomic, assign) NSInteger page;

- (void)initViews;
- (void)loadData;

@end

@implementation QTMainViewController

- (void)dealloc
{
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:QTRefreshDataNotification object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initViews];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:QTRefreshDataNotification object:nil];

    __weak typeof(self) weakSelf = self;
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
    
    self.errorView.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initViews
{
    self.title = @"快言";
    self.viewWidth = CGRectGetWidth([[UIScreen mainScreen] bounds]);
    self.viewHeight = CGRectGetHeight([[UIScreen mainScreen] bounds]);
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];

    [self.view addSubview:self.errorView];
    
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"first"] == nil) {
        QTIntroController *introController = [[QTIntroController alloc] init];
        QTNavigationController *nav = [[QTNavigationController alloc] initWithRootViewController:introController];
        nav.view.backgroundColor = [UIColor clearColor];
        [self presentViewController:nav animated:NO completion:nil];
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"first"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)loadData
{
    [QTProgressHUD showHUD:self.view];
    [QTTopicModel requestTopicData:self.page completionHandler:^(NSArray<QTTopicModel *> *list, NSError *error) {
        if (error) {
            [QTProgressHUD showHUDWithText:error.userInfo[ERROR_MESSAGE]];
            if (self.page == 1) {
                self.errorView.hidden = NO;
            }
        } else {
            [QTProgressHUD hide];
            self.errorView.hidden = YES;
            [self.dataList addObjectsFromArray:[list copy]];
            if (self.page == 1) {
                [self.tableView endHeaderRefreshing];
                if (list.count < 10) {
                    [self.tableView hiddenFooter];
                }
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

#pragma mark - Private

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
    QTMainCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([QTMainCell class])];
    
    QTTopicModel *model = self.dataList[indexPath.section];
    [cell loadData:model.title time:model.time];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0.0f;
    QTMainCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([QTMainCell class])];
    QTTopicModel *model = self.dataList[indexPath.section];
    height = [cell heightForCell:model.title];
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
    QTTopicModel *model = self.dataList[indexPath.section];
    QTTopicController *topicController = [[QTTopicController alloc] init];
    topicController.model = model;
    [self.navigationController pushViewController:topicController animated:YES];
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
            [tableView registerClass:[QTMainCell class] forCellReuseIdentifier:NSStringFromClass([QTMainCell class])];
            tableView;
        });
    }
    return _tableView;
}

- (UIView *)errorView
{
    if (_errorView == nil) {
        _errorView = ({
            UIView *view = [[UIView alloc] initWithFrame:self.view.bounds];
            view.backgroundColor = [UIColor whiteColor];
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button addTarget:self action:@selector(loadData) forControlEvents:UIControlEventTouchUpInside];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont boldSystemFontOfSize:14];
            [button setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
            [button setTitle:@"重新加载" forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage createImageWithColor:[UIColor colorFromHexValue:0xEFEFEF]]
                              forState:UIControlStateNormal];
            [view addSubview:button];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.and.centerY.equalTo(view);
                make.width.mas_equalTo(140);
                make.height.mas_equalTo(40);
            }];
            
            view;
        });
    }
    return _errorView;
}

@end
