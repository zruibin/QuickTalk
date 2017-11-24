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
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    CGFloat viewWidth = CGRectGetWidth([[UIScreen mainScreen] bounds]);
    CGFloat viewHeight = CGRectGetHeight([[UIScreen mainScreen] bounds]);
    self.scrollView.contentSize = CGSizeMake(viewWidth*3, viewHeight);
    
    for (NSInteger i=0; i<3; ++i) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake(i*viewWidth, 0, viewWidth, viewHeight);
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%ld", (long)i+1]];
        [self.scrollView addSubview:imageView];
    }
    [self.scrollView addSubview:self.button];
    self.button.frame = CGRectMake(2*viewWidth+(viewWidth-100)/2, viewHeight-60, 100, 30);
    
    [self.view addSubview:self.pageControl];
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.and.height.mas_equalTo(20);
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-10);
    }];
}

- (void)dismiss
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

//pagecontroll的委托方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int page = scrollView.contentOffset.x / scrollView.frame.size.width;
    self.pageControl.currentPage = page;
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
//            pageControl.currentPageIndicatorTintColor = [UIColor blueColor];
            pageControl;
        });
    }
    return _pageControl;
}

- (UIButton *)button
{
    if (_button == nil) {
        _button = ({
            UIButton *buttton = [UIButton buttonWithType:UIButtonTypeCustom];
            [buttton setTitle:@"进入" forState:UIControlStateNormal];
            [buttton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [buttton setBackgroundImage:[UIImage createImageWithColor:[UIColor colorFromHexValue:0x00a0e9]] forState:UIControlStateHighlighted];
            buttton.titleLabel.font = [UIFont systemFontOfSize:15];
            buttton.layer.cornerRadius = 4;
            buttton.layer.borderColor = [[UIColor grayColor] CGColor];
            buttton.layer.borderWidth = 0.5f;
            buttton.layer.masksToBounds = YES;
            [buttton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
            buttton;
        });
    }
    return _button;
}

@end
