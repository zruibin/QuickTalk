//
//  QTAccountSettingController.m
//  QuickTalk
//
//  Created by  Ruibin.Chow on 2017/12/13.
//  Copyright © 2017年 www.creactism.com. All rights reserved.
//

#import "QTAccountSettingController.h"
#import "QTAccountChangePasswordController.h"
#import "QTAccountThirdPartController.h"
#import "QTAccountPhoneController.h"

@interface QTAccountSettingController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

- (void)initViews;

@end

@implementation QTAccountSettingController

- (void)dealloc
{
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:CRAUserInfoChangeNotification object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initViews];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloading)
//                                                 name:CRAUserInfoChangeNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initViews
{
    self.title = @"帐号与安全";
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)reloading
{
    [self.tableView reloadData];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCell"];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
        cell.detailTextLabel.textColor = [UIColor colorFromHexValue:0x585858];
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
        cell.textLabel.text = @"修改手机号码";
    }
    if (indexPath.row == 1) {
        cell.textLabel.text = @"修改密码";
    }
    if (indexPath.row == 2) {
        cell.textLabel.text = @"第三方帐号管理";
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
    return 60;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIViewController *viewController = nil;
    if (indexPath.row == 0) { //设置手机
        viewController = [QTAccountPhoneController new];
    }
    if (indexPath.row == 1) { //忘记密码
        if ([QTUserInfo sharedInstance].phone.length == 0) {
            [QTMessage showErrorNotification:@"修改密码前手机不能为空"];
            return;
        }
        viewController = [QTAccountChangePasswordController new];
    }
    if (indexPath.row == 2) { //第三方
        viewController = [QTAccountThirdPartController new];
    }
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - Action



#pragma mark - setter and getter

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
            tableView.exclusiveTouch = YES;
            tableView.backgroundColor = [UIColor colorFromHexValue:0xEFEFEF];
            tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
            tableView.scrollEnabled = NO;
            tableView;
        });
    }
    return _tableView;
}


@end
