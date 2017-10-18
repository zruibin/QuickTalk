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

- (void)initViews;
- (void)loadData;

@end

@implementation QTMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initViews];
//    [self loadData];
    
    
    QTTopicController *topicController = [QTTopicController new];
    [self addChildViewController:topicController];
    self.scrollView.contentSize = CGSizeMake(self.viewWidth, self.viewHeight);
    topicController.view.frame = CGRectMake(0, 0, self.viewWidth, self.viewHeight);
    [self.scrollView addSubview:topicController.view];
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
}

- (void)loadData
{
    [QTProgressHUD showHUD:self.view];
    [QTTopicModel requestTopicData:1 completionHandler:^(NSArray<QTTopicModel *> *list, NSError *error) {
        if (error) {
            [QTProgressHUD showHUDWithText:error.userInfo[ERROR_MESSAGE]];
        } else {
            self.dataList = [list copy];
            
            self.scrollView.contentSize = CGSizeMake(self.viewWidth*10, self.viewHeight);
            for (NSInteger i=0; i<self.dataList.count; ++i) {
                QTTopicController *topicController = [QTTopicController new];
                [self.childControllers addObject:topicController];
            }
            [self selectedSubController:self.index];
        }
    }];
}

#pragma mark - Private

- (void)selectedSubController:(NSUInteger)index
{
    DLog(@"index: %ld", index);
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


#pragma mark - Action

- (void)titleButtonAction:(UIButton *)sender
{
    if (self.popoverView == nil) {
        QTTopicModel *model = (QTTopicModel *)[self.dataList objectAtIndex:self.index];
        self.popoverView = [QTPopoverView popoverInView:self.view];
        self.popoverView.textAlignment = NSTextAlignmentCenter;
        self.popoverView.items = @[model.detail];
        self.popoverView.multilineText = YES;
        self.popoverView.animationTime = .4;
//        __weak typeof(self) weakSelf = self;
        [self.popoverView setOnSelectedHandler:^(NSUInteger index, NSString *title) {
            
        }];
    }
    if (self.popoverView.hidden) {
        [self.popoverView show];
    } else {
        [self.popoverView hide];
    }
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == self.scrollView) {
        CGFloat pageWidth = scrollView.frame.size.width;
        NSInteger index = scrollView.contentOffset.x / pageWidth;
//        [self selectedSubController:index];
    }
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
            UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 150, 44)];
            [button addTarget:self action:@selector(titleButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//            [button setTitleColor:CREACTION_MAIN_COLOR forState:UIControlStateHighlighted];
            button.titleLabel.font = [UIFont boldSystemFontOfSize:17.5];
            button;
        });
    }
    return _titleButton;
}

@end
