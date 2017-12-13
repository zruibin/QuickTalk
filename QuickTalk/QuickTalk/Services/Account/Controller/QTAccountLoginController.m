//
//  QTAccountLoginController.m
//  QuickTalk
//
//  Created by  Ruibin.Chow on 2017/12/13.
//  Copyright © 2017年 www.creactism.com. All rights reserved.
//

#import "QTAccountLoginController.h"
#import "QTAccountRegisterController.h"
#import "QTAccountForgetPasswordController.h"
#import "QTAccountInfo.h"

@interface QTAccountLoginController ()

@property (nonatomic, strong) UITextField *accountField;
@property (nonatomic, strong) UITextField *passwordField;
@property (nonatomic, strong) UIButton *loginButton;
@property (nonatomic, strong) UIButton *registerButton;
@property (nonatomic, strong) UIButton *forgetButton;
@property (nonatomic, strong) UILabel *thirdLabel;
@property (nonatomic, strong) UIButton *weiboButton;
@property (nonatomic, strong) UIButton *wechatButton;
@property (nonatomic, strong) UIButton *qqButton;
@property (nonatomic, copy) NSString *loginType;
@property (nonatomic, copy) NSString *authOpenId;

- (void)initViews;
- (void)submitData;

@end

@implementation QTAccountLoginController

- (void)dealloc
{
//    DLog(@"QTAccountLoginController dealloc...");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initViews];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private

- (void)initViews
{
    self.title = @"登录";
    
    [self.view addSubview:self.accountField];
    [self.accountField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(20);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.height.equalTo(@44);
    }];
    [self.view addSubview:self.passwordField];
    [self.passwordField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.accountField.mas_bottom).offset(2);
        make.left.and.right.equalTo(self.accountField);
        make.height.equalTo(@44);
    }];
    for (UITextField *textField in @[self.accountField, self.passwordField]) {
        CGRect frame = [textField frame];
        frame.size.width = 7.0f;
        UIView *leftview = [[UIView alloc] initWithFrame:frame];
        textField.leftViewMode = UITextFieldViewModeAlways;
        textField.leftView = leftview;
    }
    [self.view addSubview:self.loginButton];
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.passwordField.mas_bottom).offset(20);
        make.left.and.right.equalTo(self.accountField);
        make.height.equalTo(@44);
    }];
    
    [self.view addSubview:self.registerButton];
    [self.registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.loginButton.mas_bottom).offset(20);
        make.left.equalTo(self.loginButton);
        make.height.equalTo(@20);
        make.width.equalTo(@100);
    }];
    [self.view addSubview:self.forgetButton];
    [self.forgetButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.registerButton);
        make.right.equalTo(self.loginButton);
        make.width.and.height.equalTo(self.registerButton);
    }];
    [self.view addSubview:self.thirdLabel];
    [self.thirdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-100);
        make.height.mas_equalTo(20);
        make.left.and.right.equalTo(self.loginButton);
    }];
    [self.view addSubview:self.wechatButton];
    [self.wechatButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.thirdLabel.mas_bottom).offset(10);
        make.centerX.equalTo(self.view);
        make.width.equalTo(@50);
        make.height.equalTo(@50);
    }];
    [self.view addSubview:self.weiboButton];
    [self.weiboButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.wechatButton);
        make.right.equalTo(self.view).offset(-40);
        make.width.and.height.equalTo(self.wechatButton);
    }];
    [self.view addSubview:self.qqButton];
    [self.qqButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.wechatButton);
        make.left.equalTo(self.view).offset(40);
        make.width.and.height.equalTo(self.wechatButton);
    }];
}

- (void)loginWithPlatform:(SSDKPlatformType)platformType
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
 //             DLog(@"dd%@",user.rawData);
 //             DLog(@"dd%@",user.credential);
 //             DLog(@"uid=%@",user.uid);
 //             DLog(@"icon: %@", user.icon);
 //             DLog(@"nickname=%@",user.nickname);
             [QTProgressHUD showHUD:self.view];
             [QTAccountInfo requestLoginForThirdPart:[user.uid md5] type:type completionHandler:^(QTAccountInfo *userInfo, NSError *error) {
                 if (error) {
                     [QTProgressHUD showHUDWithText:error.userInfo[ERROR_MESSAGE]];
                 } else {
                     [[QTUserInfo sharedInstance] loginWithThirdPart:userInfo openId:[user.uid md5] type:type];
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

#pragma mark - Button Action

- (void)loginButtonAction
{
    [self.accountField resignFirstResponder];
    [self.passwordField resignFirstResponder];
    
    NSString *account = self.accountField.text;
    NSString *password = self.passwordField.text;
    if (account.length == 0) {
        [QTMessage showErrorNotification:@"请输入手机号" viewController:self.navigationController];
        return ;
    }
    if (password.length == 0) {
        [QTMessage showErrorNotification:@"请输入密码" viewController:self.navigationController];
        return ;
    }
    if ([account isEmailAddress]) {
        self.loginType = QuickTalk_ACCOUNT_EMAIL;
        [self submitData];
    } else if ([account isMobileNumber]) {
        self.loginType = QuickTalk_ACCOUNT_PHONE;
        [self submitData];
    } else {
        [QTMessage showErrorNotification:@"请输入正确手机号"  viewController:self.navigationController];
    }
}

- (void)registerButtonAction
{
    QTAccountRegisterController *viewController = [[QTAccountRegisterController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)forgetButtonAction
{
    QTAccountForgetPasswordController *viewController = [[QTAccountForgetPasswordController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)backAction
{
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

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

#pragma mark -

- (void)submitData
{
    NSString *account = self.accountField.text;
    NSString *password = self.passwordField.text;
    if ([self.loginType isEqualToString:QuickTalk_ACCOUNT_WECHAT] ||
        [self.loginType isEqualToString:QuickTalk_ACCOUNT_QQ] ||
        [self.loginType isEqualToString:QuickTalk_ACCOUNT_WEIBO]) {
        account = self.authOpenId; //第三方登录，wechat、qq、weibo
    }
    [QTProgressHUD showHUD:self.view];
    [QTAccountInfo requestLogin:account type:self.loginType password:password completionHandler:^(QTAccountInfo *userInfo, NSError *error) {
        if (error) {
            [QTProgressHUD showHUDWithText:error.userInfo[ERROR_MESSAGE]];
        } else {
            [QTProgressHUD showHUDSuccess];
            [[QTUserInfo sharedInstance] login:userInfo password:password type:[self.loginType copy]];
            [self backAction];
        }

    }];
}

#pragma mark - Touches Event

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (![self.accountField isExclusiveTouch] || ![self.passwordField isExclusiveTouch]) {
        [self.accountField resignFirstResponder];
        [self.passwordField resignFirstResponder];
    }
}

#pragma mark - setter and getter

- (UITextField *)accountField
{
    if (_accountField == nil) {
        _accountField = ({
            UITextField *textField = [[UITextField alloc] init];
            textField.clearButtonMode = UITextFieldViewModeAlways;
            textField.backgroundColor = [UIColor whiteColor];
            textField.textColor = [UIColor colorFromHexValue:0x999999];
            textField.font = [UIFont systemFontOfSize:14];
            textField.translatesAutoresizingMaskIntoConstraints = NO;
            textField.placeholder = @"手机号";
            textField;
        });
    }
    return _accountField;
}

- (UITextField *)passwordField
{
    if (_passwordField == nil) {
        _passwordField = ({
            UITextField *textField = [[UITextField alloc] init];
            textField.clearButtonMode = UITextFieldViewModeAlways;
            textField.backgroundColor = [UIColor whiteColor];
            textField.textColor = [UIColor colorFromHexValue:0x999999];
            textField.font = [UIFont systemFontOfSize:14];
            textField.translatesAutoresizingMaskIntoConstraints = NO;
            textField.secureTextEntry = YES;
            textField.placeholder = @"密码";
            textField;
        });
    }
    return _passwordField;
}

- (UIButton *)loginButton
{
    if (_loginButton == nil) {
        _loginButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setBackgroundImage:[UIImage createImageWithColor:QuickTalk_MAIN_COLOR]
                              forState:UIControlStateNormal];
            [button setTitle:@"登录" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            button.layer.cornerRadius = 4;
            button.layer.masksToBounds = YES;
            button.translatesAutoresizingMaskIntoConstraints = YES;
            [button addTarget:self action:@selector(loginButtonAction) forControlEvents:UIControlEventTouchUpInside];
            button;
        });
    }
    return _loginButton;
}

- (UIButton *)registerButton
{
    if (_registerButton == nil) {
        _registerButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:@"注册" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorFromHexValue:0x999999] forState:UIControlStateNormal];
            [button setTitleColor:QuickTalk_MAIN_COLOR forState:UIControlStateHighlighted];
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            button.translatesAutoresizingMaskIntoConstraints = YES;
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            [button addTarget:self action:@selector(registerButtonAction) forControlEvents:UIControlEventTouchUpInside];
            button;
        });
    }
    return _registerButton;
}

- (UIButton *)forgetButton
{
    if (_forgetButton == nil) {
        _forgetButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:@"忘记密码" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorFromHexValue:0x999999] forState:UIControlStateNormal];
            [button setTitleColor:QuickTalk_MAIN_COLOR forState:UIControlStateHighlighted];
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            button.translatesAutoresizingMaskIntoConstraints = YES;
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            [button addTarget:self action:@selector(forgetButtonAction) forControlEvents:UIControlEventTouchUpInside];
            button;
        });
    }
    return _forgetButton;
}

- (UILabel *)thirdLabel
{
    if (_thirdLabel == nil) {
        _thirdLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.text = @"第三方登录";
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:13];
            label.textColor = [UIColor colorFromHexValue:0x999999];
            label;
        });
    }
    return _thirdLabel;
}

- (UIButton *)weiboButton
{
    if (_weiboButton == nil) {
        _weiboButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setImage:[UIImage imageNamed:@"weibo_login"]
                    forState:UIControlStateNormal];
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
            button.translatesAutoresizingMaskIntoConstraints = YES;
            [button setContentMode:UIViewContentModeScaleAspectFit];
            [button addTarget:self action:@selector(qqLoginAction) forControlEvents:UIControlEventTouchUpInside];
            button;
        });
    }
    return _qqButton;
}


@end
