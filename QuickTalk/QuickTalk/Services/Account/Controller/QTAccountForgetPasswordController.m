//
//  QTAccountForgetPasswordController.m
//  QuickTalk
//
//  Created by  Ruibin.Chow on 2017/12/13.
//  Copyright © 2017年 www.creactism.com. All rights reserved.
//

#import "QTAccountForgetPasswordController.h"
#import "QTAccountInfo.h"

static NSUInteger timeNumber = 60;

@interface QTAccountForgetPasswordController ()

@property (nonatomic, strong) UITextField *accountField;
@property (nonatomic, strong) UITextField *passwordField;
@property (nonatomic, strong) UITextField *verifyCodeField;
@property (nonatomic, strong) UIButton *verifyCodeButton;
@property (nonatomic, strong) UIButton *submitButton;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, copy) NSString *type;

- (void)initViews;

@end

@implementation QTAccountForgetPasswordController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initViews];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.timer invalidate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private

- (void)initViews
{
    self.title = @"忘记密码";
    
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
    for (UITextField *textField in @[self.accountField, self.passwordField, self.verifyCodeField]) {
        CGRect frame = [textField frame];
        frame.size.width = 7.0f;
        UIView *leftview = [[UIView alloc] initWithFrame:frame];
        textField.leftViewMode = UITextFieldViewModeAlways;
        textField.leftView = leftview;
    }
    
    [self.view addSubview:self.verifyCodeField];
    [self.verifyCodeField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.passwordField.mas_bottom).offset(20);
        make.left.equalTo(self.passwordField);
        make.height.equalTo(@44);
        make.width.equalTo(@150);
    }];
    [self.view addSubview:self.verifyCodeButton];
    [self.verifyCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.verifyCodeField);
        make.right.equalTo(self.passwordField);
        make.height.equalTo(self.verifyCodeField);
        make.width.equalTo(@120);
    }];
    
    [self.view addSubview:self.submitButton];
    [self.submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.verifyCodeField.mas_bottom).offset(20);
        make.left.and.right.equalTo(self.accountField);
        make.height.equalTo(@44);
    }];
}

#pragma mark - Button Action

- (void)verifyCodeButtonAction
{
    [self.accountField resignFirstResponder];
    [self.verifyCodeField resignFirstResponder];
    [self.passwordField resignFirstResponder];
    
    NSString *account = self.accountField.text;
    if ([account isEmailAddress] || [account isMobileNumber]) {
        self.verifyCodeButton.enabled = NO;
        timeNumber = 60;
        if (self.timer == nil) {
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(calcuateTime:) userInfo:nil repeats:YES];
        }
        [self sendVerifyCodeEvent];
    } else {
        [QTMessage showErrorNotification:@"请输入正确手机号" viewController:self];
    }
}

- (void)calcuateTime:(NSTimer *)timer
{
    --timeNumber;
    if (timeNumber == 0) {
        [self.timer invalidate];
        self.timer = nil;
        self.verifyCodeButton.enabled = YES;
        [self.verifyCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    } else {
        [self.verifyCodeButton setTitle:[NSString stringWithFormat:@"%lu秒后再次获取", (unsigned long)timeNumber] forState:UIControlStateNormal];
    }
}

- (void)sendVerifyCodeEvent
{
    NSString *account = self.accountField.text;
    if (account.length == 0) {
        [QTMessage showErrorNotification:@"请输入手机号" viewController:self];
        return ;
    }
    if ([account isMobileNumber]) {
        self.type = QuickTalk_ACCOUNT_PHONE;
        [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:account
                                       zone:@"86" result:^(NSError *error) {
                                           if (error) {
                                               [QTMessage showErrorNotification:@"发送验证码失败" viewController:self];
                                           }
                                       }];
    } else {
        [QTMessage showErrorNotification:@"请输入正确手机号" viewController:self];
    }
}

- (void)submitButtonAction
{
    [self.accountField resignFirstResponder];
    [self.verifyCodeField resignFirstResponder];
    [self.passwordField resignFirstResponder];
    
    NSString *account = self.accountField.text;
    NSString *verifyCode = self.verifyCodeField.text;
    NSString *password = self.passwordField.text;
    if (account.length == 0) {
        [QTMessage showErrorNotification:@"请输入手机号" viewController:self];
        return ;
    }
    if (password.length == 0) {
        [QTMessage showErrorNotification:@"请输入新密码" viewController:self];
        return ;
    }
    if (password.length < 6) {
        [QTMessage showErrorNotification:@"新密码长度至少6位" viewController:self];
        return ;
    }
    if (verifyCode.length == 0) {
        [QTMessage showErrorNotification:@"请输入验证码" viewController:self];
        return ;
    }
    if ([account isMobileNumber]) {
        self.type = QuickTalk_ACCOUNT_PHONE;
        [SMSSDK commitVerificationCode:verifyCode phoneNumber:account zone:@"86" result:^(NSError *error) {
            if (error) {
                [QTMessage showErrorNotification:@"验证码错误" viewController:self];
            } else {
                [self submitData];
            }
        }];
    } else {
        [QTMessage showErrorNotification:@"请输入正确手机号" viewController:self];
    }
}

- (void)submitData
{
    NSString *account = self.accountField.text;
    NSString *password = self.passwordField.text;
    [QTProgressHUD showHUD:self.view];
    [QTAccountInfo requestForgetPassword:account type:self.type password:password completionHandler:^(BOOL action, NSError *error) {
        if (action) {
            [QTProgressHUD showHUDSuccess];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [QTProgressHUD showHUDWithText:error.userInfo[ERROR_MESSAGE]];
        }
    }];
}

#pragma mark - Touches Event

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (![self.accountField isExclusiveTouch] || ![self.passwordField isExclusiveTouch] || ![self.verifyCodeField isExclusiveTouch]) {
        [self.accountField resignFirstResponder];
        [self.passwordField resignFirstResponder];
        [self.verifyCodeField resignFirstResponder];
    }
}

#pragma mark - Setter

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
            textField.placeholder = @"设置新密码";
            textField;
        });
    }
    return _passwordField;
}

- (UITextField *)verifyCodeField
{
    if (_verifyCodeField == nil) {
        _verifyCodeField = ({
            UITextField *textField = [[UITextField alloc] init];
            textField.clearButtonMode = UITextFieldViewModeAlways;
            textField.backgroundColor = [UIColor whiteColor];
            textField.textColor = [UIColor colorFromHexValue:0x999999];
            textField.font = [UIFont systemFontOfSize:14];
            textField.translatesAutoresizingMaskIntoConstraints = NO;
            textField.placeholder = @"验证码";
            textField;
        });
    }
    return _verifyCodeField;
}

- (UIButton *)verifyCodeButton
{
    if (_verifyCodeButton == nil) {
        _verifyCodeButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setBackgroundImage:[UIImage createImageWithColor:QuickTalk_MAIN_COLOR]
                              forState:UIControlStateNormal];
            [button setTitle:@"获取验证码" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            button.layer.cornerRadius = 4;
            button.layer.masksToBounds = YES;
            button.translatesAutoresizingMaskIntoConstraints = YES;
            [button addTarget:self action:@selector(verifyCodeButtonAction) forControlEvents:UIControlEventTouchUpInside];
            button;
        });
    }
    return _verifyCodeButton;
}

- (UIButton *)submitButton
{
    if (_submitButton == nil) {
        _submitButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setBackgroundImage:[UIImage createImageWithColor:QuickTalk_MAIN_COLOR]
                              forState:UIControlStateNormal];
            [button setTitle:@"提交" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            button.layer.cornerRadius = 4;
            button.layer.masksToBounds = YES;
            button.translatesAutoresizingMaskIntoConstraints = YES;
            [button addTarget:self action:@selector(submitButtonAction) forControlEvents:UIControlEventTouchUpInside];
            button;
        });
    }
    return _submitButton;
}


@end
