//
//  QTAddCircleController.m
//  QuickTalk
//
//  Created by  Ruibin.Chow on 2017/11/7.
//  Copyright © 2017年 www.creactism.com. All rights reserved.
//

#import "QTAddCircleController.h"
#import "QTCircleModel.h"

@interface QTAddCircleController ()

@property (nonatomic, strong) UITextView *textView;

- (void)initViews;

@end

@implementation QTAddCircleController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initViews];
    [self.textView becomeFirstResponder];
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
    self.title = @"新增圈子";
    [self.view addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.and.right.equalTo(self.view);
        make.height.mas_equalTo(200);
    }];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(sendAction)];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)sendAction
{
    [self.textView resignFirstResponder];
    if (self.textView.text.length == 0) {
        [QTMessage showWarningNotification:@"内容不可为空" viewController:self];
        return;
    }
    [QTProgressHUD showHUD:self.view];
    NSString *userUUID = [QTUserInfo sharedInstance].uuid;
    [QTCircleModel requestForSendCircle:userUUID content:self.textView.text completionHandler:^(BOOL action, NSError *error) {
        if (action) {
            [QTProgressHUD showHUDSuccess];
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            [QTProgressHUD showHUDWithText:error.userInfo[ERROR_MESSAGE]];
        }
    }];
}

#pragma mark - setter and getter

- (UITextView *)textView
{
    if (_textView == nil) {
        _textView = ({
            UITextView *textView = [[UITextView alloc] init];
            textView.showsHorizontalScrollIndicator = NO;
            textView.font = [UIFont systemFontOfSize:16];
            textView;
        });
    }
    return _textView;
}
@end
