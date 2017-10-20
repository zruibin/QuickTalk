//
//  QTInfoController.m
//  QuickTalk
//
//  Created by  Ruibin.Chow on 2017/10/20.
//  Copyright © 2017年 www.creactism.com. All rights reserved.
//

#import "QTInfoController.h"

@interface QTInfoController ()

@property (nonatomic, strong) UIButton *weiboButton;
@property (nonatomic, strong) UIButton *wechatButton;
@property (nonatomic, strong) UIButton *qqButton;
@property (nonatomic, strong) UIButton *testButton;
@property (nonatomic, strong) UIImageView *avatarView;
@property (nonatomic, strong) UIButton *logoutButton;

- (void)initViews;
- (void)configureData;

@end

@implementation QTInfoController

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
    self.title = @"更多";
    
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
    [self.view addSubview:self.logoutButton];
    [self.logoutButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.avatarView.mas_bottom).offset(60);
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
        self.logoutButton.hidden = NO;
    } else {
        self.avatarView.hidden = YES;
        self.logoutButton.hidden = YES;
        
        self.weiboButton.hidden = NO;
        self.wechatButton.hidden = NO;
        self.qqButton.hidden = NO;
        self.testButton.hidden = NO;
    }
}

#pragma mark - Action

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
    NSString *avatar = @"http://creactism.com/medias/u/cea8b1c3aebe31823fa86e069de496b9/2017102011013512hgLe.png";
    [[QTUserInfo sharedInstance] login:uuid avatar:avatar];
    [self configureData];
    [self.avatarView cra_setImage:avatar];
    
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)logoutButtonAction
{
    [[QTUserInfo sharedInstance] logout];
    [self configureData];
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

- (UIImageView *)avatarView
{
    if (_avatarView == nil) {
        _avatarView = ({
            UIImageView *imageView = [UIImageView new];
            imageView.backgroundColor = [UIColor whiteColor];
            imageView.layer.cornerRadius = 50;
            imageView.layer.masksToBounds = YES;
            imageView;
        });
    }
    return _avatarView;
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


