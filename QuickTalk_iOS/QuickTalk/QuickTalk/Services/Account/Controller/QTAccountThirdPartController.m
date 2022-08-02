//
//  QTAccountThirdPartController.m
//  QuickTalk
//
//  Created by  Ruibin.Chow on 2017/12/13.
//  Copyright © 2017年 www.creactism.com. All rights reserved.
//

#import "QTAccountThirdPartController.h"
#import "QTAccountInfo.h"

@interface QTAccountThirdPartController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

- (void)initViews;
- (void)unbind:(NSString *)type;
- (void)bind:(NSString *)type openId:(NSString *)openId;
- (void)bindWithPlatform:(SSDKPlatformType)platformType;
- (BOOL)checkingBindOnlyOneCount;

@end

@implementation QTAccountThirdPartController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initViews
{
    self.title = @"第三方帐号";
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)unbind:(NSString *)type
{
    [QTAccountInfo requestForThirdPart:[QTUserInfo sharedInstance].uuid type:type method:@"2" openId:nil completionHandler:^(BOOL action, NSError *error) {
        if (error) {
            [QTProgressHUD showHUDText:error.userInfo[ERROR_MESSAGE] view:self.view];
        } else {
            if ([type isEqualToString:QuickTalk_ACCOUNT_WECHAT]) [QTUserInfo sharedInstance].wechat = nil;
            if ([type isEqualToString:QuickTalk_ACCOUNT_QQ]) [QTUserInfo sharedInstance].qq = nil;
            if ([type isEqualToString:QuickTalk_ACCOUNT_WEIBO]) [QTUserInfo sharedInstance].weibo = nil;
            [self.tableView reloadData];
        }
    }];
}

- (void)bind:(NSString *)type openId:(NSString *)openId
{
    [QTAccountInfo requestForThirdPart:[QTUserInfo sharedInstance].uuid type:type method:@"1" openId:openId completionHandler:^(BOOL action, NSError *error) {
        if (error) {
            [QTProgressHUD showHUDText:error.userInfo[ERROR_MESSAGE] view:self.view];
        } else {
            if ([type isEqualToString:QuickTalk_ACCOUNT_WECHAT]) [QTUserInfo sharedInstance].wechat = openId;
            if ([type isEqualToString:QuickTalk_ACCOUNT_QQ]) [QTUserInfo sharedInstance].qq = openId;
            if ([type isEqualToString:QuickTalk_ACCOUNT_WEIBO]) [QTUserInfo sharedInstance].weibo = openId;
            [self.tableView reloadData];
        }
    }];
}

- (void)bindWithPlatform:(SSDKPlatformType)platformType
{
    NSString *type = QuickTalk_ACCOUNT_WECHAT;
    if (platformType == SSDKPlatformTypeQQ) {
        type = QuickTalk_ACCOUNT_QQ;
    }
    if (platformType == SSDKPlatformTypeSinaWeibo) {
        type = QuickTalk_ACCOUNT_WEIBO;
    }
    [ShareSDK getUserInfo:platformType
           onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
     {
         if (state == SSDKResponseStateSuccess) {
             [self bind:type openId:[user.uid md5]];
             [ShareSDK cancelAuthorize:platformType];
         } else {
             [QTMessage showErrorNotification:@"授权失败!"];
         }
     }];
}

- (BOOL)checkingBindOnlyOneCount
{
    NSInteger count = 0;
    if ([QTUserInfo sharedInstance].wechat.length > 0) {
        ++count;
    }
    if ([QTUserInfo sharedInstance].qq.length > 0) {
        ++count;
    }
    if ([QTUserInfo sharedInstance].weibo.length > 0) {
        ++count;
    }
    if (count == 1) {
        return YES;
    } else {
        return NO;
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCell"];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
        cell.detailTextLabel.textColor = [UIColor colorFromHexValue:0x585858];
        cell.imageView.frame =CGRectMake(0,0,44,44);
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            cell.layoutMargins = UIEdgeInsetsZero;
        }
        if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
            cell.preservesSuperviewLayoutMargins = NO;
        }
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    if (indexPath.row == 0) {
        cell.textLabel.text = @"微信";
        if ([QTUserInfo sharedInstance].wechat.length == 0) {
            cell.detailTextLabel.textColor = [UIColor colorFromHexValue:0x999999];
            cell.imageView.image = [UIImage imageNamed:@"wechat_unbind"];
            cell.detailTextLabel.text = @"未绑定";
        } else {
            cell.detailTextLabel.textColor = [UIColor colorFromHexValue:0x585858];
            cell.imageView.image = [UIImage imageNamed:@"wechat_bind"];
            cell.detailTextLabel.text = @"已绑定";
        }
    }
    if (indexPath.row == 1) {
        cell.textLabel.text = @"QQ";
        if ([QTUserInfo sharedInstance].qq.length == 0) {
            cell.detailTextLabel.textColor = [UIColor colorFromHexValue:0x999999];
            cell.imageView.image = [UIImage imageNamed:@"qq_unbind"];
            cell.detailTextLabel.text = @"未绑定";
        } else {
            cell.detailTextLabel.textColor = [UIColor colorFromHexValue:0x585858];
            cell.imageView.image = [UIImage imageNamed:@"qq_bind"];
            cell.detailTextLabel.text = @"已绑定";
        }
    }
    if (indexPath.row == 2) {
        cell.textLabel.text = @"微博";
        if ([QTUserInfo sharedInstance].weibo.length == 0) {
            cell.detailTextLabel.textColor = [UIColor colorFromHexValue:0x999999];
            cell.imageView.image = [UIImage imageNamed:@"weibo_unbind"];
            cell.detailTextLabel.text = @"未绑定";
        } else {
            cell.detailTextLabel.textColor = [UIColor colorFromHexValue:0x585858];
            cell.imageView.image = [UIImage imageNamed:@"weibo_bind"];
            cell.detailTextLabel.text = @"已绑定";
        }
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
    __weak typeof(self) weakSelf = self;
    if (indexPath.row == 0) {
        if ([QTUserInfo sharedInstance].wechat.length == 0) {
            [self bindWithPlatform:SSDKPlatformTypeWechat];
        } else {
            if ([self checkingBindOnlyOneCount]) {
                [QTProgressHUD showHUDText:@"无法解除当前绑定" view:self.view];
                return ;
            }
            MMPopupItemHandler block = ^(NSInteger index) {
                [weakSelf unbind:QuickTalk_ACCOUNT_WECHAT];
            };
            NSArray *items = @[MMItemMake(@"解除", MMItemTypeHighlight, block),
                               MMItemMake(@"取消", MMItemTypeNormal, nil)];
            MMAlertView *view = [[MMAlertView alloc] initWithTitle:@"解除微信绑定" detail:@"" items:items];
            [view show];
        }
    }
    
    if (indexPath.row == 1) {
        if ([QTUserInfo sharedInstance].qq.length == 0) {
            [self bindWithPlatform:SSDKPlatformTypeQQ];
        } else {
            if ([self checkingBindOnlyOneCount]) {
                [QTProgressHUD showHUDText:@"无法解除当前绑定" view:self.view];
                return ;
            }
            MMPopupItemHandler block = ^(NSInteger index) {
                [weakSelf unbind:QuickTalk_ACCOUNT_QQ];
            };
            NSArray *items = @[MMItemMake(@"解除", MMItemTypeHighlight, block),
                               MMItemMake(@"取消", MMItemTypeNormal, nil)];
            MMAlertView *view = [[MMAlertView alloc] initWithTitle:@"解除QQ绑定" detail:@"" items:items];
            [view show];
        }
    }
    
    if (indexPath.row == 2) {
        if ([QTUserInfo sharedInstance].weibo.length == 0) {
            [self bindWithPlatform:SSDKPlatformTypeSinaWeibo];
        } else {
            if ([self checkingBindOnlyOneCount]) {
                [QTProgressHUD showHUDText:@"无法解除当前绑定" view:self.view];
                return ;
            }
            MMPopupItemHandler block = ^(NSInteger index) {
                [weakSelf unbind:QuickTalk_ACCOUNT_WEIBO];
            };
            NSArray *items = @[MMItemMake(@"解除", MMItemTypeHighlight, block),
                               MMItemMake(@"取消", MMItemTypeNormal, nil)];
            MMAlertView *view = [[MMAlertView alloc] initWithTitle:@"解除微博绑定" detail:@"" items:items];
            [view show];
        }
    }
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
            tableView;
        });
    }
    return _tableView;
}


@end
