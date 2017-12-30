//
//  QTIntroController.m
//  QuickTalk
//
//  Created by  Ruibin.Chow on 2017/10/27.
//  Copyright © 2017年 www.creactism.com. All rights reserved.
//

#import "QTIntroController.h"

@interface QTIntroController () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
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
    [UIApplication sharedApplication].statusBarHidden = YES;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [UIApplication sharedApplication].statusBarHidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initViews
{
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    CGFloat viewWidth = CGRectGetWidth([[UIScreen mainScreen] bounds]);
    CGFloat viewHeight = CGRectGetHeight([[UIScreen mainScreen] bounds]);
    self.scrollView.contentSize = CGSizeMake(viewWidth*3, viewHeight);
    
    for (NSInteger i=0; i<3; ++i) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake(i*viewWidth, 140, viewWidth, viewWidth/1.2);
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"引导页%ld", (long)i+1]];
        [self.scrollView addSubview:imageView];
    }
    [self.view addSubview:self.pageControl];
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.and.height.mas_equalTo(20);
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-120);
    }];
    
    [self.view addSubview:self.button];
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-20);
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(26);
    }];
}

- (void)animateAction
{
    [UIView beginAnimations:nil context:nil];
    if (self.pageControl.currentPage == 2) {
        [self.button setTitle:@"进入快言" forState:UIControlStateNormal];
        [self.button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.button setBackgroundImage:[UIImage createImageWithColor:QuickTalk_MAIN_COLOR] forState:UIControlStateNormal];
        [self.button setBackgroundImage:[UIImage createImageWithColor:[UIColor colorWithWhite:0 alpha:.2f]] forState:UIControlStateHighlighted];
        self.button.titleLabel.font = [UIFont systemFontOfSize:15];
        self.button.layer.cornerRadius = 4;
        self.button.layer.borderWidth = 0;
        self.button.layer.masksToBounds = YES;
        [self.button mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view).offset(-20);
            make.left.equalTo(self.view).offset(20);
            make.right.equalTo(self.view).offset(-20);
            make.height.mas_equalTo(50);
        }];
    } else {
        [self.button setTitle:@"跳过" forState:UIControlStateNormal];
        [self.button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [self.button setBackgroundImage:nil forState:UIControlStateNormal];
        [self.button setBackgroundImage:[UIImage createImageWithColor:[UIColor colorFromHexValue:0x00a0e9]] forState:UIControlStateHighlighted];
        self.button.titleLabel.font = [UIFont systemFontOfSize:12];
        self.button.layer.cornerRadius = 4;
        self.button.layer.borderColor = [[UIColor darkGrayColor] CGColor];
        self.button.layer.borderWidth = 0.5f;
        self.button.layer.masksToBounds = YES;
        [self.button mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view).offset(-20);
            make.centerX.equalTo(self.view);
            make.width.mas_equalTo(60);
            make.height.mas_equalTo(26);
        }];
    }
    [self.button layoutIfNeeded];
    //动画结束
    [UIView commitAnimations];
}

- (void)dismiss
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//pagecontroll的委托方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int page = scrollView.contentOffset.x / scrollView.frame.size.width;
    self.pageControl.currentPage = page;
    [self animateAction];
}

#pragma mark - setter and getter

- (UIScrollView *)scrollView
{
    if (_scrollView == nil) {
        _scrollView = ({
            UIScrollView *scrollView = [[UIScrollView alloc] init];
            scrollView.showsHorizontalScrollIndicator = NO;
            scrollView.delegate = self;
            scrollView.pagingEnabled = YES;
            scrollView;
        });
    }
    return _scrollView;
}

- (UIPageControl *)pageControl
{
    if (_pageControl == nil) {
        _pageControl = ({
            UIPageControl *pageControl = [[UIPageControl alloc] init];
            pageControl.numberOfPages = 3;
            pageControl.pageIndicatorTintColor = [UIColor grayColor];
            pageControl.currentPageIndicatorTintColor = QuickTalk_MAIN_COLOR;
            pageControl;
        });
    }
    return _pageControl;
}

- (UIButton *)button
{
    if (_button == nil) {
        _button = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:@"跳过" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            [button setBackgroundImage:nil forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage createImageWithColor:[UIColor colorFromHexValue:0x00a0e9]] forState:UIControlStateHighlighted];
            button.titleLabel.font = [UIFont systemFontOfSize:12];
            button.layer.cornerRadius = 4;
            button.layer.borderColor = [[UIColor darkGrayColor] CGColor];
            button.layer.borderWidth = 0.5f;
            button.layer.masksToBounds = YES;
            [button addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
            button;
        });
    }
    return _button;
}

@end
