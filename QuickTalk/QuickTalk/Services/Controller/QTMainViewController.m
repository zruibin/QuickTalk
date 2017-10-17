//
//  QTMainViewController.m
//  QuickTalk
//
//  Created by  Ruibin.Chow on 2017/10/16.
//  Copyright © 2017年 www.creactism.com. All rights reserved.
//

#import "QTMainViewController.h"

@interface QTMainViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;

- (void)initViews;

@end

@implementation QTMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initViews
{
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - getter and setter

- (UIScrollView *)scrollView
{
    if (_scrollView == nil) {
        _scrollView = ({
            UIScrollView *scrollView = [[UIScrollView alloc] init];
            scrollView.showsVerticalScrollIndicator = NO;
            scrollView.showsHorizontalScrollIndicator = NO;
            scrollView;
        });
    }
    return _scrollView;
}


@end
