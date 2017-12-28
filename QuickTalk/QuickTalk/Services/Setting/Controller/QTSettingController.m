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
#import "QTIntroController.h"
#import "QTAccountSettingController.h"
#import "QTAccountNotificationController.h"

@interface QTSettingController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *logoutButton;

- (void)initViews;
- (void)shareAction;

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
            [QTProgressHUD showHUDText:@"登录成功" view:weakSelf.view];
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
    
    self.logoutButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.logoutButton.frame = CGRectMake(0, 10, CGRectGetWidth(self.view.bounds), 44);
    [self.logoutButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    self.logoutButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [self.logoutButton setBackgroundImage:[UIImage createImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [self.logoutButton addTarget:self action:@selector(logoutButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    [footView addSubview:self.logoutButton];
    self.tableView.tableFooterView = footView;
    
    if ([QTUserInfo sharedInstance].isLogin) {
        [self.logoutButton setTitle:@"退出登录" forState:UIControlStateNormal];
    } else {
        [self.logoutButton setTitle:@"登录" forState:UIControlStateNormal];
    }
}

#pragma mark - Action

- (void)logoutButtonAction
{
    if ([QTUserInfo sharedInstance].isLogin) {
        void(^handler)(NSInteger index) = ^(NSInteger index){
            if (index == 0) {
                [[QTUserInfo sharedInstance] logout];
            }
        };
        NSArray *items =
        @[MMItemMake(@"退出", MMItemTypeHighlight, handler)];
        MMSheetView *sheetView = [[MMSheetView alloc] initWithTitle:@""
                                                              items:items];
        sheetView.attachedView.mm_dimBackgroundBlurEnabled = NO;
        [sheetView show];
    } else {
        [[QTUserInfo sharedInstance] checkLoginStatus:self];
    }
}

#pragma mark - TableView Delegate And DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    }
    return 5;
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
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"账号与安全";
        }
        if (indexPath.row == 1) {
            cell.textLabel.text = @"消息通知";
        }
    } else {
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
        if (indexPath.row == 3) {
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.text = @"推荐一下";
        }
        if (indexPath.row == 4) {
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.text = @"清除缓存";
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
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            if ([[QTUserInfo sharedInstance] checkLoginStatus:self] == NO) {
                return ;
            }
            QTAccountSettingController *accountSettingController = [[QTAccountSettingController alloc] init];
            [self.navigationController pushViewController:accountSettingController animated:YES];
        }
        if (indexPath.row == 1) {
            QTAccountNotificationController *notificationController = [[QTAccountNotificationController alloc] init];
            [self.navigationController pushViewController:notificationController animated:YES];
        }
        return ;
    }
    
    if (indexPath.row == 0) {
        QTIntroController *introController = [[QTIntroController alloc] init];
        [self presentViewController:introController animated:YES completion:nil];
    }
    if (indexPath.row == 1) {
        QTUserAgreementController *userAgreementController = [QTUserAgreementController new];
        [self.navigationController pushViewController:userAgreementController animated:YES];
    }
    if (indexPath.row == 2) {
        QTFeedbackController *feedbackController = [QTFeedbackController new];
        [self.navigationController pushViewController:feedbackController animated:YES];
    }
    if (indexPath.row == 3) {
        [self shareAction];
    }
    if (indexPath.row == 4) {
        __weak typeof(self) weakSelf = self;
        void(^handler)(NSInteger index) = ^(NSInteger index){
            if (index == 0) {
                [[QTCleaner sharedInstance] asynchronousCleanUpCache];
                [QTProgressHUD showHUDText:@"清除成功" view:weakSelf.view];
            }
        };
        NSString *sizeStr = [IFLY_PATH fileSizeString];
        if (sizeStr != nil) {
            sizeStr = [NSString stringWithFormat:@"共%@", [IFLY_PATH fileSizeString]];
            NSArray *items =
            @[MMItemMake(@"清除", MMItemTypeHighlight, handler)];
            MMSheetView *sheetView = [[MMSheetView alloc] initWithTitle:sizeStr
                                                                  items:items];
            sheetView.attachedView.mm_dimBackgroundBlurEnabled = NO;
            [sheetView show];
        } else {
            NSArray *items =
            @[MMItemMake(@"确定", MMItemTypeNormal, handler)];
            MMSheetView *sheetView = [[MMSheetView alloc] initWithTitle:@"暂无缓存"
                                                                  items:items];
            sheetView.attachedView.mm_dimBackgroundBlurEnabled = NO;
            [sheetView show];
        }
        
    }
}

- (void)shareAction
{
    NSArray* imageArray = @[[UIImage imageNamed:@"AppIcon"]];
    //1、构造分享内容
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params SSDKSetupShareParamsByText:@"快言"
                                images:imageArray
                                   url:[NSURL URLWithString:@"http://www.creactism.com"]
                                 title:@"分享标题"
                                  type:SSDKContentTypeAuto];
    [params SSDKEnableUseClientShare];
    
    [SSUIShareActionSheetStyle setShareActionSheetStyle:ShareActionSheetStyleSimple];
    //2、弹出分享菜单栏
    [ShareSDK showShareActionSheet:nil
                             items:nil
                       shareParams:params
               onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
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

