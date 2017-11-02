//
//  QTUserAgreementController.m
//  QuickTalk
//
//  Created by  Ruibin.Chow on 2017/11/2.
//  Copyright © 2017年 www.creactism.com. All rights reserved.
//

#import "QTUserAgreementController.h"

@interface QTUserAgreementController ()

@property (nonatomic, strong) UITextView *textView;

- (void)initViews;

@end

@implementation QTUserAgreementController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initViews];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"userAgreement" ofType:@"txt"];
    NSString *text = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    self.textView.text = text;
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
    self.title = @"服务协议";
    [self.view addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - setter and getter

- (UITextView *)textView
{
    if (_textView == nil) {
        _textView = ({
            UITextView *textView = [[UITextView alloc] init];
            textView.editable = NO;
            textView.showsHorizontalScrollIndicator = NO;
            textView.font = [UIFont systemFontOfSize:13];
            textView;
        });
    }
    return _textView;
}

@end
