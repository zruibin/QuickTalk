//
//  QTMainViewController.m
//  QuickTalk
//
//  Created by  Ruibin.Chow on 2017/10/16.
//  Copyright © 2017年 www.creactism.com. All rights reserved.
//

#import "QTMainViewController.h"
#import "QTTopicController.h"
#import "QTTopicModel.h"
#import "QTPopoverView.h"
#import "QTInfoController.h"
#import <SafariServices/SafariServices.h>
#import "QTIntroController.h"

@interface QTMainViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableDictionary *actionDict;
@property (nonatomic, strong) NSMutableArray *childControllers;
@property (nonatomic, copy) NSArray *dataList;
@property (nonatomic, strong) UIButton *titleButton;
@property (nonatomic, strong) QTPopoverView *popoverView;
@property (nonatomic, assign) NSUInteger index;
@property (nonatomic, assign) CGFloat viewWidth;
@property (nonatomic, assign) CGFloat viewHeight;
@property (nonatomic, strong) UIView *errorView;

- (void)initViews;
- (void)loadData;

@end

@implementation QTMainViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:QTRefreshDataNotification object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initViews];
    [self loadData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:QTRefreshDataNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initViews
{
    self.viewWidth = CGRectGetWidth([[UIScreen mainScreen] bounds]);
    self.viewHeight = CGRectGetHeight([[UIScreen mainScreen] bounds]);
    [self.view addSubview:self.scrollView];
    self.scrollView.frame = CGRectMake(0, 0, self.viewWidth, self.viewHeight);
    self.navigationItem.titleView = self.titleButton;
    
    UIBarButtonItem *moreItem = [[UIBarButtonItem alloc]
                                 initWithImage:[UIImage imageNamed:@"more"] style:UIBarButtonItemStylePlain target:self action:@selector(moreAction)];
    self.navigationItem.rightBarButtonItem = moreItem;
    
    [self.view addSubview:self.errorView];
    
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"first"] == nil) {
        QTIntroController *introController = [[QTIntroController alloc] init];
        QTNavigationController *nav = [[QTNavigationController alloc] initWithRootViewController:introController];
        nav.view.backgroundColor = [UIColor clearColor];
        [self presentViewController:nav animated:NO completion:nil];
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"first"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)loadData
{
    [QTProgressHUD showHUD:self.view];
    [QTTopicModel requestTopicData:1 completionHandler:^(NSArray<QTTopicModel *> *list, NSError *error) {
        if (error) {
            [QTProgressHUD showHUDWithText:error.userInfo[ERROR_MESSAGE]];
            self.errorView.hidden = NO;
        } else {
            [QTProgressHUD hide];
            self.errorView.hidden = YES;
            self.dataList = [list copy];
            if (self.dataList.count > 0) {
                self.scrollView.contentSize = CGSizeMake(self.viewWidth*self.dataList.count, self.viewHeight);
                for (NSInteger i=0; i<self.dataList.count; ++i) {
                    QTTopicController *topicController = [QTTopicController new];
                    [self.childControllers addObject:topicController];
                }
                [self selectedSubController:self.index];
            }
        }
    }];
}

- (void)moreAction
{
    QTInfoController *infoController = [[QTInfoController alloc] init];
    [self.navigationController pushViewController:infoController animated:YES];
}

#pragma mark - Private

- (void)selectedSubController:(NSUInteger)index
{
    DLog(@"index: %ld", index);
    if (index < self.dataList.count) {
        self.index = index;
        QTTopicModel *model = (QTTopicModel *)[self.dataList objectAtIndex:index];
        [self.titleButton setTitle:model.title forState:UIControlStateNormal];
        BOOL action = [[self.actionDict objectForKey:[NSNumber numberWithInteger:index]] boolValue];
        if (action == NO) {
            QTTopicController *topicController = (QTTopicController *)self.childControllers[index];
            topicController.view.frame = CGRectMake(self.viewWidth*index, 0,
                                                    self.viewWidth, self.viewHeight);
            [self.scrollView addSubview:topicController.view];
            [self addChildViewController:topicController];
            [self.actionDict setObject:[NSNumber numberWithBool:YES] forKey:[NSNumber numberWithInteger:index]];
            topicController.model = model;
        }
        self.popoverView = nil;
    }
}


#pragma mark - Action

- (void)titleButtonAction:(UIButton *)sender
{
    if (self.dataList.count > 0) {
        if (self.popoverView == nil) {
            QTTopicModel *model = (QTTopicModel *)[self.dataList objectAtIndex:self.index];
            self.popoverView = [QTPopoverView popoverInView:self.view];
            self.popoverView.textAlignment = NSTextAlignmentCenter;
            self.popoverView.items = @[model.detail];
            self.popoverView.multilineText = YES;
            self.popoverView.animationTime = .4;
            __weak typeof(self) weakSelf = self;
            [self.popoverView setOnSelectedHandler:^(NSUInteger index, NSString *title) {
                QTTopicModel *model = (QTTopicModel *)[weakSelf.dataList objectAtIndex:weakSelf.index];
                NSString *url = model.href;
                SFSafariViewController *safariController = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:url]];
                [weakSelf presentViewController:safariController animated:YES completion:nil];
            }];
        }
        if (self.popoverView.hidden) {
            [self.popoverView show];
        } else {
            [self.popoverView hide];
        }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kTopicHiddenPopupMenuNotification object:nil];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == self.scrollView) {
        CGFloat pageWidth = scrollView.frame.size.width;
        NSInteger index = scrollView.contentOffset.x / pageWidth;
        [self selectedSubController:index];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kTopicHiddenPopupMenuNotification object:nil];
}

#pragma mark - getter and setter

- (UIScrollView *)scrollView
{
    if (_scrollView == nil) {
        _scrollView = ({
            UIScrollView *scrollView = [[UIScrollView alloc] init];
            scrollView.pagingEnabled = YES;
            //scrollView.bounces = NO;
            scrollView.delegate = self;
            scrollView.showsVerticalScrollIndicator = NO;
            scrollView.showsHorizontalScrollIndicator = NO;
            scrollView;
        });
    }
    return _scrollView;
}

- (NSMutableDictionary *)actionDict
{
    if (_actionDict == nil) {
        _actionDict = [NSMutableDictionary dictionary];
    }
    return _actionDict;
}

- (NSMutableArray *)childControllers
{
    if (_childControllers == nil) {
        _childControllers = [NSMutableArray array];
    }
    return _childControllers;
}

- (UIButton *)titleButton
{
    if (_titleButton == nil) {
        _titleButton = ({
            UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 200, 44)];
            [button addTarget:self action:@selector(titleButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont boldSystemFontOfSize:17.5];
            button.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
            [button setTitleColor:[UIColor colorFromHexValue:0x999999] forState:UIControlStateHighlighted];
            button;
        });
    }
    return _titleButton;
}

- (UIView *)errorView
{
    if (_errorView == nil) {
        _errorView = ({
            UIView *view = [[UIView alloc] initWithFrame:self.view.bounds];
            view.backgroundColor = [UIColor whiteColor];
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button addTarget:self action:@selector(loadData) forControlEvents:UIControlEventTouchUpInside];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont boldSystemFontOfSize:14];
            [button setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
            [button setTitle:@"重新加载" forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage createImageWithColor:[UIColor colorFromHexValue:0xEFEFEF]]
                              forState:UIControlStateNormal];
            [view addSubview:button];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.and.centerY.equalTo(view);
                make.width.mas_equalTo(140);
                make.height.mas_equalTo(40);
            }];
            
            view;
        });
    }
    return _errorView;
}

@end
