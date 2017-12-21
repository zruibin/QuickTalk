//
//  QTUserStarAndFansController.m
//  QuickTalk
//
//  Created by  Ruibin.Chow on 2017/12/20.
//  Copyright © 2017年 www.creactism.com. All rights reserved.
//

#import "QTUserStarAndFansController.h"
#import "QTUserStarController.h"
#import "QTUserFansController.h"

@interface QTUserStarAndFansController () <UIScrollViewDelegate>

@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong) HMSegmentedControl *segmentedControl;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *childControllers;

- (void)initViews;

@end

@implementation QTUserStarAndFansController

- (void)dealloc
{
    DLog(@"QTUserStarAndFansController dealloc...");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initViews];
    
    self.childControllers = [NSMutableArray arrayWithCapacity:self.count];
    [self selectedOnSegment:0];
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
    self.count = 2;

    [self.view addSubview:self.scrollView];
    self.scrollView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-64);
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.scrollView.bounds)*self.count,
                                             CGRectGetHeight(self.scrollView.bounds)-64);
    
    self.segmentedControl.frame = CGRectMake(0, 0, 200, 44);
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    titleView.backgroundColor = [UIColor clearColor];
    [titleView addSubview:self.segmentedControl];
    self.navigationItem.titleView = titleView;
}


#pragma mark - Private

- (void)selectedOnSegment:(NSInteger)index
{
    [self.segmentedControl setSelectedSegmentIndex:index animated:YES];
    if (index == 0) {
        if (self.childControllers.count == 0) {
            QTUserStarController *userStarController = [[QTUserStarController alloc] init];
            userStarController.userUUID = self.userUUID;
            [self.childControllers addObject:userStarController];
            userStarController.view.frame = CGRectMake(0, 0,
                                                       CGRectGetWidth(self.scrollView.bounds),
                                                       CGRectGetHeight(self.scrollView.bounds));
            userStarController.view.userInteractionEnabled = YES;
            [self.scrollView addSubview:userStarController.view];
            [self addChildViewController:userStarController];
        }
        [self.scrollView scrollRectToVisible:CGRectMake(0, 0,
                                                        CGRectGetWidth(self.scrollView.bounds),
                                                        CGRectGetHeight(self.scrollView.bounds)) animated:YES];
    }
    if (index == 1) {
        if (self.childControllers.count == 1) {
            QTUserFansController *userFansController = [[QTUserFansController alloc] init];
            userFansController.userUUID = self.userUUID;
            [self.childControllers addObject:userFansController];
            userFansController.view.frame = CGRectMake(CGRectGetWidth(self.scrollView.bounds), 0,
                                                            CGRectGetWidth(self.scrollView.bounds),
                                                            CGRectGetHeight(self.scrollView.bounds));
            userFansController.view.userInteractionEnabled = YES;
            [self.scrollView addSubview:userFansController.view];
            [self addChildViewController:userFansController];
        }
        [self.scrollView scrollRectToVisible:CGRectMake(CGRectGetWidth(self.scrollView.bounds), 0,
                                                        CGRectGetWidth(self.scrollView.bounds),
                                                        CGRectGetHeight(self.scrollView.bounds)) animated:YES];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == self.scrollView) {
        CGFloat pageWidth = scrollView.frame.size.width;
        NSInteger page = scrollView.contentOffset.x / pageWidth;
        [self selectedOnSegment:page];
    }
}

#pragma mark - getter and setter

- (HMSegmentedControl *)segmentedControl
{
    if (_segmentedControl == nil) {
        _segmentedControl = ({
            HMSegmentedControl *segmentedControl = [[HMSegmentedControl alloc]
                                                    initWithSectionTitles:@[@"关注", @"粉丝"]];
            segmentedControl.backgroundColor = [UIColor clearColor];
            segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
            segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
            segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
            segmentedControl.selectionIndicatorHeight = 2.0f;
            segmentedControl.selectionIndicatorColor = QuickTalk_MAIN_COLOR;
            segmentedControl.borderWidth = .05f;
            [segmentedControl setTitleFormatter:^NSAttributedString *(HMSegmentedControl *segmentedControl,
                                                                      NSString *title, NSUInteger index, BOOL selected) {
                NSAttributedString *attString = [[NSAttributedString alloc] initWithString:title
                                                                                attributes:@{
                                                                                             NSForegroundColorAttributeName : [UIColor blackColor],
                                                                                             NSFontAttributeName: [UIFont boldSystemFontOfSize:14]
                                                                                             }];
                if (selected == NO) {
                    attString = [[NSAttributedString alloc] initWithString:title
                                                                attributes:@{
                                                                             NSForegroundColorAttributeName : [UIColor colorFromHexValue:0x999999],
                                                                             NSFontAttributeName: [UIFont systemFontOfSize:14]
                                                                             }];
                }
                return attString;
            }];
            segmentedControl.translatesAutoresizingMaskIntoConstraints = NO;
            __weak typeof(self) weakSelf = self;
            [segmentedControl setIndexChangeBlock:^(NSInteger index) {
                [weakSelf selectedOnSegment:index];
            }];
            segmentedControl;
        });
    }
    return _segmentedControl;
}

- (UIScrollView *)scrollView
{
    if (_scrollView == nil) {
        _scrollView = ({
            UIScrollView *scrollView = [[UIScrollView alloc] init];
            scrollView.backgroundColor = [UIColor colorFromHexValue:0xEFEFEF];
            scrollView.pagingEnabled = YES;
            scrollView.delegate = self;
            scrollView.showsVerticalScrollIndicator = NO;
            scrollView.showsHorizontalScrollIndicator = NO;
            scrollView;
        });
    }
    return _scrollView;
}

@end
