//
//  QTCircleController.m
//  QuickTalk
//
//  Created by  Ruibin.Chow on 2017/11/7.
//  Copyright © 2017年 www.creactism.com. All rights reserved.
//

#import "QTCircleController.h"
#import "QTCircleCell.h"
#import "QTAddCircleController.h"
#import "QTCircleModel.h"

@interface QTCircleController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataList;
@property (nonatomic, strong) UIView *errorView;
@property (nonatomic, assign) NSInteger page;

- (void)initViews;
- (void)loadData;
- (void)likeActionRequest:(NSInteger)index;

@end

@implementation QTCircleController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initViews];

    if ([[QTUserInfo sharedInstance] hiddenOneClickLogin] == NO) {
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
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initViews
{
    self.title = @"圈子";
    
    if ([[QTUserInfo sharedInstance] hiddenOneClickLogin] == NO) {
        [self.view addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        
        [self.view addSubview:self.errorView];
        self.errorView.hidden = YES;
        UIBarButtonItem *addProjectItem = [[UIBarButtonItem alloc]
                                           initWithImage:[UIImage imageNamed:@"circle_add"]
                                           style:UIBarButtonItemStylePlain target:self action:@selector(addCircleAction)];
        self.navigationItem.rightBarButtonItem = addProjectItem;
    } else {
        UILabel *label = [UILabel new];
        label.text = @"即将开放";
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor blackColor];
        [self.view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.view);
            make.height.mas_equalTo(40);
            make.left.and.right.equalTo(self.view);
        }];
    }
}

- (void)loadData
{
    [QTProgressHUD showHUD:self.view];
    [QTCircleModel requestCircleData:self.page userUUID:nil completionHandler:^(NSArray<QTCircleModel *> *list, NSError *error) {
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

- (void)likeActionRequest:(NSInteger)index
{
    QTCircleModel *model = self.dataList[index];
    [QTCircleModel requestForLikeCircle:model.uuid completionHandler:^(BOOL action, NSError *error) {
        if (action) {
            model.like += 1;
            [self.tableView reloadData];
        } else {
            [QTProgressHUD showHUDText:error.userInfo[ERROR_MESSAGE] view:self.view];
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
    QTCircleCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([QTCircleCell class])];
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.tag = indexPath.section;
    QTCircleModel *model = self.dataList[indexPath.section];
    __weak typeof(self) weakSelf = self;
    [cell setOnDidTouchActionHandler:^(NSInteger index) {
        [weakSelf likeActionRequest:index];
    }];
    [cell loadData:model.content avatar:model.avatar time:model.time likeNum:model.like];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 80.0f;
    QTCircleCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([QTCircleCell class])];
    QTCircleModel *model = self.dataList[indexPath.section];
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
    QTCircleModel *model = self.dataList[indexPath.section];
    NSString *userUUID = [QTUserInfo sharedInstance].uuid;
    NSArray *items = nil;
    __weak typeof(self) weakSelf = self;
    if ([model.userUUID isEqualToString:userUUID]) {
        void(^handler)(NSInteger index) = ^(NSInteger index){
            if (index == 0) {
                [QTCircleModel requestForDeleteCircle:model.uuid userUUID:userUUID completionHandler:^(BOOL action, NSError *error) {
                    if (action) {
                        [weakSelf.tableView beginHeaderRefreshing];
                    } else {
                        [QTProgressHUD showHUDText:error.userInfo[ERROR_MESSAGE] view:self.view];
                    }
                }];
            }
        };
        items = @[MMItemMake(@"删除", MMItemTypeHighlight, handler)];
    } else {
        void(^handler)(NSInteger index) = ^(NSInteger index){
            if (index == 0) {
                [QTProgressHUD showHUD:weakSelf.view];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [QTProgressHUD showHUDWithText:@"举报成功"];
                });
            }
        };
        items = @[MMItemMake(@"举报", MMItemTypeHighlight, handler)];
    }
    MMSheetView *sheetView = [[MMSheetView alloc] initWithTitle:@""
                                                          items:items];
    sheetView.attachedView.mm_dimBackgroundBlurEnabled = NO;
    [sheetView show];
}

#pragma mark - Action

- (void)addCircleAction
{
    if ([[QTUserInfo sharedInstance] checkLoginStatus:self]) {
        QTAddCircleController *addCircleController = [[QTAddCircleController alloc] init];
        QTNavigationController *nav = [[QTNavigationController alloc] initWithRootViewController:addCircleController];
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
            [tableView registerClass:[QTCircleCell class] forCellReuseIdentifier:NSStringFromClass([QTCircleCell class])];
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
//            [button addTarget:self action:@selector(loadData) forControlEvents:UIControlEventTouchUpInside];
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
