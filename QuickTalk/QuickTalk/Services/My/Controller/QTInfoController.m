//
//  QTInfoController.m
//  QuickTalk
//
//  Created by  Ruibin.Chow on 2017/10/20.
//  Copyright © 2017年 www.creactism.com. All rights reserved.
//

#import "QTInfoController.h"
#import "QTAvatarEditController.h"
#import "QTInfoEditController.h"


@interface QTInfoController ()

@property (nonatomic, strong) UIButton *weiboButton;
@property (nonatomic, strong) UIButton *wechatButton;
@property (nonatomic, strong) UIButton *qqButton;
@property (nonatomic, strong) UIButton *testButton;
@property (nonatomic, strong) UIButton *avatarView;
@property (nonatomic, strong) UIButton *nicknameButton;
@property (nonatomic, strong) UIButton *logoutButton;

- (void)initViews;
- (void)configureData;
- (void)loginWithPlatform:(SSDKPlatformType)platformType;

@end

@implementation QTInfoController

- (void)dealloc
{
//    DLog(@"QTInfoController dealloc...");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initViews];
    [self configureData];
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
    self.title = @"个人信息";
    
    if (self.presentingViewController) {
        self.title = @"登录";
    }
    
    [self.view addSubview:self.weiboButton];
    [self.weiboButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(100);
        make.centerX.equalTo(self.view);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.height.mas_equalTo(50);
    }];
    [self.view addSubview:self.wechatButton];
    [self.wechatButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.weiboButton.mas_bottom).offset(10);
        make.centerX.equalTo(self.view);
        make.left.and.right.equalTo(self.weiboButton);
        make.height.equalTo(self.weiboButton);
    }];
    [self.view addSubview:self.qqButton];
    [self.qqButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.wechatButton.mas_bottom).offset(10);
        make.centerX.equalTo(self.view);
        make.left.and.right.equalTo(self.weiboButton);
        make.height.equalTo(self.weiboButton);
    }];
    [self.view addSubview:self.testButton];
    [self.testButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.qqButton.mas_bottom).offset(10);
        make.centerX.equalTo(self.view);
        make.left.and.right.equalTo(self.weiboButton);
        make.height.equalTo(self.weiboButton);
    }];
    
    [self.view addSubview:self.avatarView];
    [self.avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.and.height.mas_equalTo(100);
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(100);
    }];
    [self.view addSubview:self.nicknameButton];
    [self.nicknameButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.avatarView.mas_bottom).offset(20);
        make.centerX.equalTo(self.view);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.height.mas_equalTo(40);
    }];
    [self.view addSubview:self.logoutButton];
    [self.logoutButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nicknameButton.mas_bottom).offset(60);
        make.centerX.equalTo(self.view);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.height.mas_equalTo(50);
    }];
}

- (void)configureData
{
    if ([QTUserInfo sharedInstance].isLogin) {
        self.weiboButton.hidden = YES;
        self.wechatButton.hidden = YES;
        self.qqButton.hidden = YES;
        self.testButton.hidden = YES;
        
        self.avatarView.hidden = NO;
        self.nicknameButton.hidden = NO;
        self.logoutButton.hidden = NO;
        
        NSString *avatar = [QTUserInfo sharedInstance].avatar;
        [self.avatarView cra_setBackgroundImage:avatar];
        [self.nicknameButton setTitle:[QTUserInfo sharedInstance].nickname forState:UIControlStateNormal];
    } else {
        self.avatarView.hidden = YES;
        self.nicknameButton.hidden = YES;
        self.logoutButton.hidden = YES;
        
        self.weiboButton.hidden = NO;
        self.wechatButton.hidden = NO;
        self.qqButton.hidden = NO;
        self.testButton.hidden = NO;
        
        if ([QTUserInfo sharedInstance].hiddenData) {
            self.testButton.hidden = YES;
        }
    }
}

- (void)loginWithPlatform:(SSDKPlatformType)platformType
{
    NSString *type = @"8";
    if (platformType == SSDKPlatformTypeQQ) {
        type = @"9";
    }
    if (platformType == SSDKPlatformTypeSinaWeibo) {
        type = @"10";
    }
    /*
     TYPE_FOR_AUTH_WECHAT = “8”
     TYPE_FOR_AUTH_QQ = “9”
     TYPE_FOR_AUTH_WEIBO = “10”
     */
    [ShareSDK getUserInfo:platformType
           onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
     {
         if (state == SSDKResponseStateSuccess) {
//             DLog(@"dd%@",user.rawData);
//             DLog(@"dd%@",user.credential);
//             DLog(@"uid=%@",user.uid);
//             DLog(@"icon: %@", user.icon);
//             DLog(@"nickname=%@",user.nickname);
             [QTProgressHUD showHUD:self.view];
             [QTUserInfo requestLogin:user.uid type:type avatar:user.icon nickName:user.nickname completionHandler:^(QTUserInfo *userInfo, NSError *error) {
                 if (error) {
                     [QTProgressHUD showHUDWithText:error.userInfo[ERROR_MESSAGE]];
                 } else {
                     [[QTUserInfo sharedInstance] login:userInfo.uuid avatar:userInfo.avatar nickname:userInfo.nickname];
                     [self configureData];
                     [QTProgressHUD hide];
                     if (self.presentingViewController) {
                         [self dismissViewControllerAnimated:YES completion:nil];
                     }
                 }
             }];
         } else {
             [QTMessage showErrorNotification:@"登录失败!"];
         }
     }];
}

#pragma mark - Action

- (void)weiboLoginAction
{
    [self loginWithPlatform:SSDKPlatformTypeSinaWeibo];
}

- (void)wechatLoginAction
{
    [self loginWithPlatform:SSDKPlatformTypeWechat];
}

- (void)qqLoginAction
{
    [self loginWithPlatform:SSDKPlatformTypeQQ];
}

- (void)testButtonAction
{
    /*
     "uuid":"cea8b1c3aebe31823fa86e069de496b9"
     "avatar":"http://creactism.com/medias/u/cea8b1c3aebe31823fa86e069de496b9/2017102011013512hgLe.png"
     
     "uuid":"22908c712545dca68ae6a09383f47bc3"
     "avatar":"http://creactism.com/medias/u/22908c712545dca68ae6a09383f47bc3/201710201102566Ieb5r.png"
     
     "uuid":"deb98a5555f6d5780467f7bebf61eb5b"
     "avatar":"http://creactism.com/medias/u/deb98a5555f6d5780467f7bebf61eb5b/20171020110322gEJKj6.png"
     */
    NSString *uuid = @"cea8b1c3aebe31823fa86e069de496b9";
    NSString *avatar = [[NSUserDefaults standardUserDefaults] objectForKey:@"test_avatar"];
    if (avatar.length == 0) {
        avatar = @"http://creactism.com/medias/u/cea8b1c3aebe31823fa86e069de496b9/2017102011013512hgLe.png";
    }
    NSString *nickname = [[NSUserDefaults standardUserDefaults] objectForKey:@"test_nickname"];
    if (nickname.length == 0) {
        nickname = @"用户1234444";
    }
    [[QTUserInfo sharedInstance] login:uuid avatar:avatar nickname:nickname];
    [self configureData];
    [self.avatarView cra_setBackgroundImage:avatar];
    
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)logoutButtonAction
{
    [[QTUserInfo sharedInstance] logout];
    [self configureData];
}

- (void)avatarAction
{
    QTAvatarEditController *avatarEditController = [QTAvatarEditController new];
    __weak typeof(self) weakSelf = self;
    [avatarEditController setOnAvatarChangeHandler:^{
        [weakSelf.avatarView cra_setBackgroundImage:[QTUserInfo sharedInstance].avatar];
        if ([@"cea8b1c3aebe31823fa86e069de496b9" isEqualToString:[QTUserInfo sharedInstance].uuid]) {
            [[NSUserDefaults standardUserDefaults] setObject:[QTUserInfo sharedInstance].avatar forKey:@"test_avatar"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }];
    [self.navigationController pushViewController:avatarEditController animated:YES];
}

- (void)infoEditAction
{
    QTInfoEditController *infoEditController = [QTInfoEditController new];
    __weak typeof(self) weakSelf = self;
    [infoEditController setOnChangeBlock:^(NSString *text) {
        [weakSelf.nicknameButton setTitle:text forState:UIControlStateNormal];
        if ([@"cea8b1c3aebe31823fa86e069de496b9" isEqualToString:[QTUserInfo sharedInstance].uuid]) {
            [[NSUserDefaults standardUserDefaults] setObject:text forKey:@"test_nickname"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }];
    [self.navigationController pushViewController:infoEditController animated:YES];
}

#pragma mark - setter and getter

- (UIButton *)weiboButton
{
    if (_weiboButton == nil) {
        _weiboButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setImage:[UIImage imageNamed:@"weibo_login"]
                    forState:UIControlStateNormal];
            [button setTitle:@"   微博登录" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:16];
            [button setBackgroundImage:[UIImage createImageWithColor:[UIColor whiteColor]]
                              forState:UIControlStateNormal];
            button.layer.cornerRadius = 4;
            button.layer.masksToBounds = YES;
            button.translatesAutoresizingMaskIntoConstraints = YES;
            [button setContentMode:UIViewContentModeScaleAspectFit];
            [button addTarget:self action:@selector(weiboLoginAction) forControlEvents:UIControlEventTouchUpInside];
            button;
        });
    }
    return _weiboButton;
}

- (UIButton *)wechatButton
{
    if (_wechatButton == nil) {
        _wechatButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setImage:[UIImage imageNamed:@"wechat_login"]
                    forState:UIControlStateNormal];
            [button setTitle:@"   微信登录" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:16];
            [button setBackgroundImage:[UIImage createImageWithColor:[UIColor whiteColor]]
                              forState:UIControlStateNormal];
            button.layer.cornerRadius = 4;
            button.layer.masksToBounds = YES;
            button.translatesAutoresizingMaskIntoConstraints = YES;
            [button setContentMode:UIViewContentModeScaleAspectFit];
            [button addTarget:self action:@selector(wechatLoginAction) forControlEvents:UIControlEventTouchUpInside];
            button;
        });
    }
    return _wechatButton;
}

- (UIButton *)qqButton
{
    if (_qqButton == nil) {
        _qqButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setImage:[UIImage imageNamed:@"qq_login"]
                    forState:UIControlStateNormal];
            [button setTitle:@"   QQ登录" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:16];
            [button setBackgroundImage:[UIImage createImageWithColor:[UIColor whiteColor]]
                              forState:UIControlStateNormal];
            button.layer.cornerRadius = 4;
            button.layer.masksToBounds = YES;
            button.translatesAutoresizingMaskIntoConstraints = YES;
            [button setContentMode:UIViewContentModeScaleAspectFit];
            [button addTarget:self action:@selector(qqLoginAction) forControlEvents:UIControlEventTouchUpInside];
            button;
        });
    }
    return _qqButton;
}

- (UIButton *)testButton
{
    if (_testButton == nil) {
        _testButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:@"一键登录" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:16];
            [button setBackgroundImage:[UIImage createImageWithColor:[UIColor whiteColor]]
                              forState:UIControlStateNormal];
            button.layer.cornerRadius = 4;
            button.layer.masksToBounds = YES;
            button.translatesAutoresizingMaskIntoConstraints = YES;
            [button setContentMode:UIViewContentModeScaleAspectFit];
            [button addTarget:self action:@selector(testButtonAction) forControlEvents:UIControlEventTouchUpInside];
            button;
        });
    }
    return _testButton;
}

- (UIButton *)avatarView
{
    if (_avatarView == nil) {
        _avatarView = ({
            UIButton *button = [UIButton new];
            button.layer.cornerRadius = 50;
            button.layer.masksToBounds = YES;
            [button addTarget:self action:@selector(avatarAction) forControlEvents:UIControlEventTouchUpInside];
            button;
        });
    }
    return _avatarView;
}

- (UIButton *)nicknameButton
{
    if (_nicknameButton == nil) {
        _nicknameButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.titleLabel.font = [UIFont systemFontOfSize:16];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
            [button addTarget:self action:@selector(infoEditAction) forControlEvents:UIControlEventTouchUpInside];
            button;
        });
    }
    return _nicknameButton;
}

- (UIButton *)logoutButton
{
    if (_logoutButton == nil) {
        _logoutButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:@"退出登录" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:16];
            [button setBackgroundImage:[UIImage createImageWithColor:[UIColor whiteColor]]
                              forState:UIControlStateNormal];
            button.layer.cornerRadius = 4;
            button.layer.masksToBounds = YES;
            button.translatesAutoresizingMaskIntoConstraints = YES;
            [button setContentMode:UIViewContentModeScaleAspectFit];
            [button addTarget:self action:@selector(logoutButtonAction) forControlEvents:UIControlEventTouchUpInside];
            button;
        });
    }
    return _logoutButton;
}

@end


