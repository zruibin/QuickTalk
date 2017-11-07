//
//  QTIntroController.m
//  QuickTalk
//
//  Created by  Ruibin.Chow on 2017/10/27.
//  Copyright © 2017年 www.creactism.com. All rights reserved.
//

#import "QTIntroController.h"

@interface QTIntroController ()

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIButton *button;

- (void)initViews;

@end

@implementation QTIntroController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initViews];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationItem.leftBarButtonItem = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initViews
{
    self.title = @"欢迎来到快言";
    UIBarButtonItem *moreItem = [[UIBarButtonItem alloc]
                                 initWithImage:[UIImage imageNamed:@"more"] style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationItem.rightBarButtonItem = moreItem;
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:.5f];
    
    [self.view addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.and.right.equalTo(self.view);
        make.height.mas_equalTo(200);
    }];
    [self.view addSubview:self.button];
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(135);
        make.height.mas_equalTo(35);
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(150);
    }];
}

- (void)dismiss
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark - setter and getter

- (UITextView *)textView
{
    if (_textView == nil) {
        _textView = ({
            UITextView *textView = [UITextView new];
            textView.selectable = NO;
            textView.editable = NO;
            textView.scrollEnabled = NO;
            textView.font = [UIFont systemFontOfSize:16];
            textView.text = @"在快言上每天读一两篇新闻，和大伙分享自己的想法。\n\n我们的系统会根据热度决定评论的存留时间，无聊和低俗的评论会很快被净化掉，所以在这样更容易看到有意思的东西。";
            textView;
        });
    }
    return _textView;
}

- (UIButton *)button
{
    if (_button == nil) {
        _button = ({
            UIButton *buttton = [UIButton buttonWithType:UIButtonTypeCustom];
            [buttton setTitle:@"进入" forState:UIControlStateNormal];
            [buttton setBackgroundImage:[UIImage createImageWithColor:[UIColor colorFromHexValue:0x00a0e9]] forState:UIControlStateNormal];
            buttton.titleLabel.font = [UIFont systemFontOfSize:16];
            buttton.layer.cornerRadius = 4;
            buttton.layer.masksToBounds = YES;
            [buttton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
            buttton;
        });
    }
    return _button;
}

@end
