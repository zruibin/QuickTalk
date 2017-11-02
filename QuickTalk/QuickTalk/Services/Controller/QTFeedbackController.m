//
//  QTFeedbackController.m
//  QuickTalk
//
//  Created by  Ruibin.Chow on 2017/11/2.
//  Copyright © 2017年 www.creactism.com. All rights reserved.
//

#import "QTFeedbackController.h"

@interface QTFeedbackController ()

@property (nonatomic, strong) UITextView *textView;

- (void)initViews;

@end

@implementation QTFeedbackController

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
    self.title = @"意见与反馈";
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
    [QTProgressHUD showHUD:self.view];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [QTProgressHUD showHUDSuccess];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    });
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
