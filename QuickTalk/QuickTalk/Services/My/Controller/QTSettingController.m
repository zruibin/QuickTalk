//
//  QTSettingController.m
//  QuickTalk
//
//  Created by  Ruibin.Chow on 2017/11/7.
//  Copyright © 2017年 www.creactism.com. All rights reserved.
//

#import "QTSettingController.h"
#import "QTUserAgreementController.h"
#import "QTFeedbackController.h"

@interface QTSettingController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *logoutButton;

- (void)initViews;

@end

@implementation QTSettingController

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
        if ([QTUserInfo sharedInstance].isLogin) {
            [weakSelf.logoutButton setTitle:@"退出登录" forState:UIControlStateNormal];
        } else {
            [weakSelf.logoutButton setTitle:@"登录" forState:UIControlStateNormal];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initViews
{
    self.title = @"更多";
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    UIView *footView = [[UIView alloc] init];
    footView.frame =CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 54);
    self.tableView.tableFooterView = footView;
    if ([QTUserInfo sharedInstance].isLogin) {
        self.logoutButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.logoutButton.frame = CGRectMake(0, 10, CGRectGetWidth(self.view.bounds), 44);
        [self.logoutButton setTitle:@"退出登录" forState:UIControlStateNormal];
        [self.logoutButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        self.logoutButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [self.logoutButton setBackgroundImage:[UIImage createImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [self.logoutButton addTarget:self action:@selector(logoutButtonAction) forControlEvents:UIControlEventTouchUpInside];
        
        UIView *footView = [[UIView alloc] init];
        footView.frame =CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 54);
        [footView addSubview:self.logoutButton];
        self.tableView.tableFooterView = footView;
    }
}

#pragma mark - Action

- (void)logoutButtonAction
{
    if ([QTUserInfo sharedInstance].isLogin) {
        [[QTUserInfo sharedInstance] logout];
    } else {
        [[QTUserInfo sharedInstance] checkLoginStatus:self];
    }
}

#pragma mark - TableView Delegate And DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([UITableViewCell class])];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            cell.layoutMargins = UIEdgeInsetsZero;
        }
        if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
            cell.preservesSuperviewLayoutMargins = NO;
        }
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    if (indexPath.row == 0) {
        NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        cell.textLabel.text = [NSString stringWithFormat:@"引导页(%@)", version];
    }
    if (indexPath.row == 1) {
        cell.textLabel.text = @"声明及用户协议协议";
    }
    if (indexPath.row == 2) {
        cell.textLabel.text = @"意见反馈";
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    /*顶部和第一行数据之间的间隔要将0改为一个非0的数值即可实现*/
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 1) {
        QTUserAgreementController *userAgreementController = [QTUserAgreementController new];
        [self.navigationController pushViewController:userAgreementController animated:YES];
    }
    if (indexPath.row == 2) {
        QTFeedbackController *feedbackController = [QTFeedbackController new];
        [self.navigationController pushViewController:feedbackController animated:YES];
    }
    
}

#pragma mark - setter and getter

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = ({
            UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
            tableView.estimatedRowHeight = 0;
            tableView.estimatedSectionHeaderHeight = 0;
            tableView.estimatedSectionFooterHeight = 0;
            tableView.scrollEnabled = NO;
            tableView.delegate = self;
            tableView.dataSource = self;
            tableView.translatesAutoresizingMaskIntoConstraints = NO;
            tableView.exclusiveTouch = YES;
            tableView.backgroundColor = [UIColor colorFromHexValue:0xEFEFEF];
            tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
            tableView;
        });
    }
    return _tableView;
}

@end
