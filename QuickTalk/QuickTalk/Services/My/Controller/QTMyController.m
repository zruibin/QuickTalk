//
//  QTMyController.m
//  QuickTalk
//
//  Created by  Ruibin.Chow on 2017/11/7.
//  Copyright © 2017年 www.creactism.com. All rights reserved.
//

#import "QTMyController.h"
#import "QTSettingController.h"
#import "QTAvatarEditController.h"
#import "QTInfoEditController.h"
#import "QTTopicController.h"
#import "QTUserPostMainController.h"
#import "QTMyNewsCommentController.h"


@interface QTMyController () <UIScrollViewDelegate>

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIButton *avatarView;
@property (nonatomic, strong) UIButton *nicknameButton;

@property (nonatomic, strong) HMSegmentedControl *segmentedControl;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *childControllers;

@end

@implementation QTMyController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:QTLoginStatusChangeNotification object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initViews];
    
    self.childControllers = [NSMutableArray arrayWithCapacity:2];
    [self selectedOnSegment:0];
    
    __weak typeof(self) weakSelf = self;
    [[NSNotificationCenter defaultCenter] addObserverForName:QTLoginStatusChangeNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        [weakSelf.childControllers removeAllObjects];
        for (UIView *view in weakSelf.scrollView.subviews) {
            [view removeFromSuperview];
        }
        if ([QTUserInfo sharedInstance].isLogin == NO) {
            weakSelf.headerView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 0);
            weakSelf.segmentedControl.hidden = YES;
            weakSelf.scrollView.hidden = YES;
        } else {
            weakSelf.headerView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 100);
            [weakSelf.avatarView cra_setBackgroundImage:[QTUserInfo sharedInstance].avatar];
            [weakSelf.nicknameButton setTitle:[QTUserInfo sharedInstance].nickname forState:UIControlStateNormal];
            weakSelf.segmentedControl.hidden = NO;
            weakSelf.scrollView.hidden = NO;
            [self selectedOnSegment:0];
        }
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [Tools drawBorder:self.segmentedControl top:NO left:NO bottom:YES right:NO
               borderColor:[UIColor colorFromHexValue:0xE4E4E4] borderWidth:.5f];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initViews
{
    self.title = @"我";
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.segmentedControl];
    self.segmentedControl.frame = CGRectMake(0, 100, CGRectGetWidth(self.view.bounds), 44);
    [self.view addSubview:self.scrollView];
    self.scrollView.frame = CGRectMake(0, 144, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-144-49-64);
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.scrollView.bounds)*2,
                                             CGRectGetHeight(self.scrollView.bounds));
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"更多" style:UIBarButtonItemStylePlain target:self action:@selector(settingAction)];
    self.navigationItem.rightBarButtonItem = item;
    
    if ([QTUserInfo sharedInstance].isLogin == NO) {
        self.headerView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 0);
        self.segmentedControl.hidden = YES;
        self.scrollView.hidden = YES;
    } else {
        self.headerView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 100);
        [self.avatarView cra_setBackgroundImage:[QTUserInfo sharedInstance].avatar];
        [self.nicknameButton setTitle:[QTUserInfo sharedInstance].nickname forState:UIControlStateNormal];
        self.segmentedControl.hidden = NO;
        self.scrollView.hidden = NO;
    }
}

#pragma mark - Private

- (void)selectedOnSegment:(NSInteger)index
{
    [self.segmentedControl setSelectedSegmentIndex:index animated:YES];
    if (index == 0) {
        if (self.childControllers.count == 0) {
            QTUserPostMainController *userPostController = [[QTUserPostMainController alloc] init];
            userPostController.userUUID = [QTUserInfo sharedInstance].uuid;
            [self.childControllers addObject:userPostController];
            userPostController.view.frame = CGRectMake(0, 0,
                                                   CGRectGetWidth(self.scrollView.bounds),
                                                   CGRectGetHeight(self.scrollView.bounds));
            userPostController.view.userInteractionEnabled = YES;
            [self.scrollView addSubview:userPostController.view];
            [self addChildViewController:userPostController];
        }
        [self.scrollView scrollRectToVisible:CGRectMake(0, 0,
                                                        CGRectGetWidth(self.scrollView.bounds),
                                                        CGRectGetHeight(self.scrollView.bounds)) animated:YES];
    }
    if (index == 1) {
        if (self.childControllers.count == 1) {
            QTMyNewsCommentController *myNewsCommentController = [[QTMyNewsCommentController alloc] init];
            [self.childControllers addObject:myNewsCommentController];
            myNewsCommentController.view.frame = CGRectMake(CGRectGetWidth(self.scrollView.bounds), 0,
                                                      CGRectGetWidth(self.scrollView.bounds),
                                                      CGRectGetHeight(self.scrollView.bounds));
            myNewsCommentController.view.userInteractionEnabled = YES;
            [self.scrollView addSubview:myNewsCommentController.view];
            [self addChildViewController:myNewsCommentController];
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

- (void)settingAction
{
    QTSettingController *settingControlle = [QTSettingController new];
    [self.navigationController pushViewController:settingControlle animated:YES];
}

- (void)avatarAction
{
    QTAvatarEditController *avatarEditController = [QTAvatarEditController new];
    __weak typeof(self) weakSelf = self;
    [avatarEditController setOnAvatarChangeHandler:^{
        [weakSelf.avatarView cra_setBackgroundImage:[QTUserInfo sharedInstance].avatar];
        if ([@"cea8b1c3aebe31823fa86e069de496b9" isEqualToString:[QTUserInfo sharedInstance].uuid]) {
            [[NSUserDefaults standardUserDefaults] setObject:[QTUserInfo sharedInstance].avatar forKey:@"test_avatar"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }];
    [self.navigationController pushViewController:avatarEditController animated:YES];
}

- (void)infoEditAction
{
    QTInfoEditController *infoEditController = [QTInfoEditController new];
    __weak typeof(self) weakSelf = self;
    [infoEditController setOnChangeBlock:^(NSString *text) {
        [weakSelf.nicknameButton setTitle:text forState:UIControlStateNormal];
        if ([@"cea8b1c3aebe31823fa86e069de496b9" isEqualToString:[QTUserInfo sharedInstance].uuid]) {
            [[NSUserDefaults standardUserDefaults] setObject:text forKey:@"test_nickname"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }];
    [self.navigationController pushViewController:infoEditController animated:YES];
}

#pragma mark - getter and setter

- (UIView *)headerView
{
    if (_headerView == nil) {
        _headerView = ({
            UIView *view = [[UIView alloc] init];
            view.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 100);
            view.backgroundColor = [UIColor whiteColor];
            view.clipsToBounds = YES;
            
            [view addSubview:self.avatarView];
            [self.avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.and.height.mas_equalTo(80);
                make.left.mas_equalTo(10);
                make.centerY.equalTo(view);
            }];
            [self.avatarView cra_setBackgroundImage:[QTUserInfo sharedInstance].avatar];
            [view addSubview:self.nicknameButton];
            [self.nicknameButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(view);
                make.left.equalTo(self.avatarView.mas_right).offset(20);
                make.right.equalTo(view).offset(-20);
                make.height.mas_equalTo(60);
            }];
            [self.nicknameButton setTitle:[QTUserInfo sharedInstance].nickname forState:UIControlStateNormal];
            
            view;
        });
    }
    return _headerView;
}

- (UIButton *)avatarView
{
    if (_avatarView == nil) {
        _avatarView = ({
            UIButton *button = [UIButton new];
            button.layer.cornerRadius = 40;
            button.layer.masksToBounds = YES;
            [button addTarget:self action:@selector(avatarAction) forControlEvents:UIControlEventTouchUpInside];
            button;
        });
    }
    return _avatarView;
}

- (UIButton *)nicknameButton
{
    if (_nicknameButton == nil) {
        _nicknameButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.titleLabel.font = [UIFont systemFontOfSize:16];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            [button addTarget:self action:@selector(infoEditAction) forControlEvents:UIControlEventTouchUpInside];
            button;
        });
    }
    return _nicknameButton;
}

- (HMSegmentedControl *)segmentedControl
{
    if (_segmentedControl == nil) {
        _segmentedControl = ({
            HMSegmentedControl *segmentedControl = [[HMSegmentedControl alloc]
                                                    initWithSectionTitles:@[@"我的快言", @"新闻评论"]];
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
