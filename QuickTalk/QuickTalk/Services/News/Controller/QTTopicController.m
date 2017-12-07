//
//  QTTopicController.m
//  QuickTalk
//
//  Created by  Ruibin.Chow on 2017/10/16.
//  Copyright © 2017年 www.creactism.com. All rights reserved.
//

#import "QTTopicController.h"
#import "QTTopicModel.h"
#import "QTTopicSpeaker.h"
#import "QTTopicContentController.h"
#import "QTTopicCommentController.h"

@interface QTTopicController () <UIScrollViewDelegate>

@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, strong) QTTopicSpeaker *topicSpeaker;
@property (nonatomic, strong) HMSegmentedControl *segmentedControl;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *childControllers;

- (void)initViews;

@end

@implementation QTTopicController

- (void)dealloc
{
//    DLog(@"QTTopicController dealloc...");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initViews];
    self.topicSpeaker = [QTTopicSpeaker sharedInstance];
    self.childControllers = [NSMutableArray arrayWithCapacity:2];
    
    if (self.topicUUID.length != 0) {
        [QTTopicModel requestTopic:self.topicUUID completionHandler:^(QTTopicModel *model, NSError *error) {
            if (error) {
                [QTProgressHUD showHUDText:error.userInfo[ERROR_MESSAGE]  view:self.view];
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                self.model = model;
                [self selectedOnSegment:0];
            }
        }];
    } else {
        self.topicUUID = self.model.uuid;
        [self selectedOnSegment:0];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [Tools drawBorder:self.segmentedControl top:NO left:NO bottom:YES right:NO
          borderColor:[UIColor colorFromHexValue:0xE4E4E4] borderWidth:.5f];
    if ([self.topicSpeaker.name isEqualToString:self.topicUUID]) {
        if (self.topicSpeaker.speaker.status == QTSpeakerPause) {
            [self.playButton setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
        } else {
            [self.playButton setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
        }
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initViews
{
    self.segmentedControl.frame = CGRectMake(0, 0, 200, 44);
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    [titleView addSubview:self.segmentedControl];
    self.navigationItem.titleView = titleView;
    
    [self.view addSubview:self.scrollView];
    self.scrollView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-64);
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.scrollView.bounds)*2,
                                             CGRectGetHeight(self.scrollView.bounds));
    
    self.playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.playButton.frame = CGRectMake(0, 0, 40, 40);
    [self.playButton setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    [self.playButton addTarget:self action:@selector(sayingAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:self.playButton];
    self.navigationItem.rightBarButtonItem = item;
    if ([self.topicSpeaker.name isEqualToString:self.topicUUID]) {
        if (self.topicSpeaker.speaker.status == QTSpeakerPause) {
            [self.playButton setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
        } else {
            [self.playButton setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
        }
    }
}

#pragma mark - Private

- (void)selectedOnSegment:(NSInteger)index
{
    [self.segmentedControl setSelectedSegmentIndex:index animated:YES];
    if (index == 0) {
        if (self.childControllers.count == 0) {
            QTTopicContentController *topicContentController = [[QTTopicContentController alloc] init];
            topicContentController.model = self.model;
            [self.childControllers addObject:topicContentController];
            topicContentController.view.frame = CGRectMake(0, 0,
                                                       CGRectGetWidth(self.scrollView.bounds),
                                                       CGRectGetHeight(self.scrollView.bounds));
            topicContentController.view.userInteractionEnabled = YES;
            [self.scrollView addSubview:topicContentController.view];
            [self addChildViewController:topicContentController];
        }
        [self.scrollView scrollRectToVisible:CGRectMake(0, 0,
                                                        CGRectGetWidth(self.scrollView.bounds),
                                                        CGRectGetHeight(self.scrollView.bounds)) animated:YES];
    }
    if (index == 1) {
        if (self.childControllers.count == 1) {
            QTTopicCommentController *commentController = [[QTTopicCommentController alloc] init];
            commentController.topicUUID = self.topicUUID;
            commentController.model = self.model;
            [self.childControllers addObject:commentController];
            commentController.view.frame = CGRectMake(CGRectGetWidth(self.scrollView.bounds), 0,
                                                            CGRectGetWidth(self.scrollView.bounds),
                                                            CGRectGetHeight(self.scrollView.bounds));
            commentController.view.userInteractionEnabled = YES;
            [self.scrollView addSubview:commentController.view];
            [self addChildViewController:commentController];
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

#pragma mark - Action

- (void)sayingAction
{
    if (![QTNetworking checkingNetworkStatus]) {
        [QTProgressHUD showHUDText:@"网络开了点小差，请稍后再试!" view:self.view];
        return ;
    }
    if ([self.topicSpeaker.name isEqualToString:self.topicUUID]) {
        if (self.topicSpeaker.speaker.status == QTSpeakerNone ||
            self.topicSpeaker.speaker.status == QTSpeakerDestory) {
            self.topicSpeaker.name = self.topicUUID;
            self.topicSpeaker.title = self.model.title;
            [self.topicSpeaker speakingForRequest:self.topicUUID view:self.view completionHandler:^(BOOL action, NSError *error) {
                if (action) {
                    [self.playButton setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
                }
            }];
        } else {
            if (self.topicSpeaker.speaker.status == QTSpeakerPause) {
                [self.playButton setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
                [self.topicSpeaker resumeSpeaking];
            } else {
                [self.playButton setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
                [self.topicSpeaker pauseSpeaking];
            }
        }
    } else {
        self.topicSpeaker.name = self.topicUUID;
        self.topicSpeaker.title = self.model.title;
        [self.topicSpeaker speakingForRequest:self.topicUUID view:self.view completionHandler:^(BOOL action, NSError *error) {
            if (action) {
                [self.playButton setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
            }
        }];
    }
}

#pragma mark - setter and getter

- (HMSegmentedControl *)segmentedControl
{
    if (_segmentedControl == nil) {
        _segmentedControl = ({
            HMSegmentedControl *segmentedControl = [[HMSegmentedControl alloc]
                                                    initWithSectionTitles:@[@"内容", @"评论"]];
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
