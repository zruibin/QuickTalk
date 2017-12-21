//
//  QTAccountNotificationController.m
//  QuickTalk
//
//  Created by  Ruibin.Chow on 2017/12/21.
//  Copyright © 2017年 www.creactism.com. All rights reserved.
//

#import "QTAccountNotificationController.h"
#import "QTAccountInfo.h"

@interface QTAccountNotificationController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray *titleArray;
@property (nonatomic, copy) NSDictionary *dataDict;

- (void)initViews;
- (void)loadData;

@end

@implementation QTAccountNotificationController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initViews];
    
    self.titleArray = @[
                        @"评论",
                        @"赞",
                        @"新的关注",
                        @"新的分享"
                        ];
    self.dataDict = @{
                      NOTIFICATION_FOR_LIKE: [NSNumber numberWithInteger:1],
                      NOTIFICATION_FOR_COMMENT: [NSNumber numberWithInteger:1],
                      NOTIFICATION_FOR_NEW_STAR: [NSNumber numberWithInteger:1],
                      NOTIFICATION_FOR_NEW_SHARE: [NSNumber numberWithInteger:0]
                      };
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initViews
{
    self.title = @"新消息通知";
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)loadData
{
    NSString *userUUID = [QTUserInfo sharedInstance].uuid;
    [QTAccountInfo requestForSettingList:userUUID completionHandler:^(NSDictionary *dict, NSError *error) {
        if (error) {
            [QTProgressHUD showHUDText:error.userInfo[ERROR_MESSAGE] view:self.view];
        } else {
            self.dataDict = dict;
            [self.tableView reloadData];
        }
    }];
}

#pragma mark - TableView Delegate And DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) {
        return [self.titleArray count];
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCell"];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            cell.layoutMargins = UIEdgeInsetsZero;
        }
        if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
            cell.preservesSuperviewLayoutMargins = NO;
        }
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
        [switchView addTarget:self action:@selector(updateSwitch:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView = switchView;
    }
    
    if (indexPath.section == 0) {
        cell.textLabel.text = @"消息推送";
        cell.accessoryView = nil;
        UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
        if (UIUserNotificationTypeNone == setting.types) {
            cell.detailTextLabel.text = @"已关闭，去设置";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
        } else {
            cell.detailTextLabel.text = @"已开启";
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    } else {
        NSUInteger index = indexPath.row+1;
        cell.textLabel.text = [self.titleArray objectAtIndex:index-1];
        cell.accessoryType = UITableViewCellAccessoryNone;
        UISwitch *switchView = (UISwitch *)cell.accessoryView;
        switchView.tag = index;
        switchView.on = [[self.dataDict objectForKey:[NSString stringWithFormat:@"%lu", (unsigned long)index]] boolValue];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
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

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, CGRectGetWidth(tableView.bounds)-20, 20)];
        label.text = @"请在iPhone的“设置“-”通知“-”可行“中进行设置";
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = [UIColor colorFromHexValue:0x999999];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.bounds), 60)];
        [view addSubview:label];
        return view;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
        if (UIUserNotificationTypeNone == setting.types) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }
    }
}

#pragma mark - Action

- (void)updateSwitch:(UISwitch *)switchView
{
    //    DLog(@"index:%@ -- status:%d", [self.titleArray objectAtIndex:switchView.tag], switchView.on);
    NSString *userUUID = [QTUserInfo sharedInstance].uuid;
    NSString *type = [NSString stringWithFormat:@"%ld", (long)switchView.tag];
    NSString *status = [NSString stringWithFormat:@"%ld", (long)switchView.on];
    [QTAccountInfo requestForSetting:userUUID type:type status:status completionHandler:^(BOOL action, NSError *error) {
        if (action == NO) {
            switchView.on = !switchView.on;
            [QTProgressHUD showHUDText:@"修改失败" view:self.view];
        }
    }];
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
