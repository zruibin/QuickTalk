//
//  QTAccountChangePasswordController.m
//  QuickTalk
//
//  Created by  Ruibin.Chow on 2017/12/13.
//  Copyright © 2017年 www.creactism.com. All rights reserved.
//

#import "QTAccountChangePasswordController.h"
#import "QTAccountInfo.h"

@interface QTAccountChangePasswordController ()

@property (nonatomic, strong) UITextField *oldField;
@property (nonatomic, strong) UITextField *inputField;
@property (nonatomic, strong) UITextField *comfirField;
@property (nonatomic, strong) UIButton *submitButton;

@end

@implementation QTAccountChangePasswordController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initViews];
    [self.oldField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private

- (void)initViews
{
    self.title = @"修改密码";
    
    for (UITextField *textField in @[self.oldField, self.inputField, self.comfirField]) {
        CGRect frame = [textField frame];
        frame.size.width = 7.0f;
        UIView *leftview = [[UIView alloc] initWithFrame:frame];
        textField.leftViewMode = UITextFieldViewModeAlways;
        textField.leftView = leftview;
    }
    
    [self.view addSubview:self.oldField];
    [self.oldField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(20);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.height.equalTo(@44);
    }];
    [self.view addSubview:self.inputField];
    [self.inputField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.oldField.mas_bottom).offset(2);
        make.left.and.right.equalTo(self.oldField);
        make.height.equalTo(self.oldField);
    }];
    [self.view addSubview:self.comfirField];
    [self.comfirField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.inputField.mas_bottom).offset(2);
        make.left.and.right.equalTo(self.oldField);
        make.height.equalTo(self.oldField);
    }];
    
    UILabel *textLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:12];
        label.minimumScaleFactor = 10;
        label.textColor = [UIColor colorFromHexValue:0x999999];
        label.translatesAutoresizingMaskIntoConstraints = NO;
        label.textAlignment = NSTextAlignmentLeft;
        label.text = @"若是通过第三方登录则初始密码为空";
        label;
    });
    [self.view addSubview:textLabel];
    [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.comfirField.mas_bottom).offset(5);
        make.left.and.right.equalTo(self.comfirField);
        make.height.equalTo(@30);
    }];
    
    [self.view addSubview:self.submitButton];
    [self.submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(textLabel.mas_bottom).offset(20);
        make.left.and.right.equalTo(self.comfirField);
        make.height.equalTo(@44);
    }];
}

#pragma mark - Action

- (void)submitButtonAction
{
    [self.oldField resignFirstResponder];
    [self.inputField resignFirstResponder];
    [self.comfirField resignFirstResponder];
    
    NSString *oldPassword = self.oldField.text;
    NSString *inputPassword = self.inputField.text;
    NSString *comfirPassword = self.comfirField.text;
    if (inputPassword.length == 0) {
        [QTMessage showErrorNotification:@"新密码不能为空"];
        return ;
    }
    if (comfirPassword.length == 0) {
        [QTMessage showErrorNotification:@"新密码确认不能为空"];
        return ;
    }
    if ([oldPassword isEqualToString:inputPassword]) {
        [QTMessage showErrorNotification:@"新密码不能与旧密码一样"];
        return ;
    }
    if ([comfirPassword isEqualToString:inputPassword] == NO) {
        [QTMessage showErrorNotification:@"新密码与确认密码必须一样"];
        return ;
    }
    if (comfirPassword.length < 6) {
        [QTMessage showErrorNotification:@"新密码不能少于6位"];
        return ;
    }
    
    NSString *userUUID = [QTUserInfo sharedInstance].uuid;
    [QTProgressHUD showHUD:self.view];
    [QTAccountInfo requestForChangePassword:userUUID oldpassword:oldPassword newpassword:inputPassword completionHandler:^(BOOL action, NSError *error) {
        if (action) {
            [QTProgressHUD showHUDSuccess];
            [[QTUserInfo sharedInstance] logout];
            self.tabBarController.selectedIndex = 1;
            [self.navigationController popToRootViewControllerAnimated:YES];
        } else {
            [QTProgressHUD showHUDWithText:error.userInfo[ERROR_MESSAGE]];
        }
    }];
}

#pragma mark - Touches Event

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (![self.oldField isExclusiveTouch] ||
        ![self.inputField isExclusiveTouch] ||
        ![self.comfirField isExclusiveTouch]) {
        [self.oldField resignFirstResponder];
        [self.inputField resignFirstResponder];
        [self.comfirField resignFirstResponder];
    }
}

#pragma mark - setter and getter

- (UITextField *)oldField
{
    if (_oldField == nil) {
        _oldField = ({
            UITextField *textField = [[UITextField alloc] init];
            textField.clearButtonMode = UITextFieldViewModeAlways;
            textField.secureTextEntry = YES;
            textField.backgroundColor = [UIColor whiteColor];
            textField.textColor = [UIColor colorFromHexValue:0x999999];
            textField.font = [UIFont systemFontOfSize:14];
            textField.translatesAutoresizingMaskIntoConstraints = NO;
            textField.placeholder = @"请输入旧密码";
            textField;
        });
    }
    return _oldField;
}

- (UITextField *)inputField
{
    if (_inputField == nil) {
        _inputField = ({
            UITextField *textField = [[UITextField alloc] init];
            textField.clearButtonMode = UITextFieldViewModeAlways;
            textField.secureTextEntry = YES;
            textField.backgroundColor = [UIColor whiteColor];
            textField.textColor = [UIColor colorFromHexValue:0x999999];
            textField.font = [UIFont systemFontOfSize:14];
            textField.translatesAutoresizingMaskIntoConstraints = NO;
            textField.placeholder = @"请输入新的密码";
            textField;
        });
    }
    return _inputField;
}

- (UITextField *)comfirField
{
    if (_comfirField == nil) {
        _comfirField = ({
            UITextField *textField = [[UITextField alloc] init];
            textField.clearButtonMode = UITextFieldViewModeAlways;
            textField.secureTextEntry = YES;
            textField.backgroundColor = [UIColor whiteColor];
            textField.textColor = [UIColor colorFromHexValue:0x999999];
            textField.font = [UIFont systemFontOfSize:14];
            textField.translatesAutoresizingMaskIntoConstraints = NO;
            textField.placeholder = @"确认新密码";
            textField;
        });
    }
    return _comfirField;
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
