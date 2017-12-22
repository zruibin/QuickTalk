//
//  QTUserController.m
//  QuickTalk
//
//  Created by  Ruibin.Chow on 2017/12/14.
//  Copyright © 2017年 www.creactism.com. All rights reserved.
//

#import "QTUserController.h"
#import "QTUserPostMainController.h"
#import "QTAccountInfoEditController.h"
#import "RBImagebrowse.h"
#import "QTUserModel.h"
#import "QTUserLikeListController.h"

@interface QTUserController () <UIScrollViewDelegate>

@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, assign) CGFloat headerHeight;
@property (nonatomic, strong) UIButton *avatarView;
@property (nonatomic, strong) UIButton *nicknameButton;
@property (nonatomic, strong) UIImageView *genderView;
@property (nonatomic, strong) UILabel *areaLabel;

@property (nonatomic, strong) HMSegmentedControl *segmentedControl;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *childControllers;
@property (nonatomic, strong) QTUserModel *userModel;

- (void)initViews;
- (void)makeUserData;
- (void)makeUserView;
- (void)calcuateOnScrolling:(CGFloat)offsetY;

@end

@implementation QTUserController


- (void)dealloc
{
    DLog(@"QTUserController dealloc...");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initViews];
    
    self.childControllers = [NSMutableArray arrayWithCapacity:self.count];
    [self makeUserData];
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
    self.title = self.nickname;
    self.count = 2;
    self.headerHeight = 144;
    
    [self.view addSubview:self.scrollView];
    self.scrollView.frame = CGRectMake(0, self.headerHeight, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-self.headerHeight-64);
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.scrollView.bounds)*self.count,
                                             CGRectGetHeight(self.scrollView.bounds)-64);
    
    [self.view addSubview:self.headerView];
    self.segmentedControl.frame = CGRectMake(0, 100, CGRectGetWidth(self.view.bounds), 44);
    [self.headerView addSubview:self.segmentedControl];
}

- (void)makeUserData
{
    [QTUserModel requestUserInfo:self.userUUID completionHandler:^(QTUserModel *userModel, NSError *error) {
        if (error) {
            [QTProgressHUD showHUDText:error.userInfo[ERROR_MESSAGE] view:self.view];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [self selectedOnSegment:0];
            self.userModel = userModel;
            [self makeUserView];
        }
    }];
}

- (void)makeUserView
{
    self.title = self.userModel.nickname;
    [self.avatarView cra_setBackgroundImage:self.userModel.avatar];
    [self.nicknameButton setTitle:self.userModel.nickname forState:UIControlStateNormal];
    self.areaLabel.text = self.userModel.area;
    
    UIImage *male = [UIImage imageNamed:@"male"];
    UIImage *female = [UIImage imageNamed:@"female"];
    if (self.userModel.gender == 1) {
        self.genderView.image = male;
    }
    if (self.userModel.gender == 2) {
        self.genderView.image = female;
    }
    if (self.userModel.gender == 0) {
        [self.genderView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.and.height.mas_equalTo(0);
            make.left.equalTo(self.nicknameButton);
            make.top.equalTo(self.nicknameButton.mas_bottom).offset(4);
        }];
    } else {
        [self.genderView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.and.height.mas_equalTo(16);
            make.left.equalTo(self.nicknameButton);
            make.top.equalTo(self.nicknameButton.mas_bottom).offset(8);
        }];
    }
}

- (void)calcuateOnScrolling:(CGFloat)offsetY
{
//    DLog(@"y: %f", offsetY);
    if (offsetY <= 0) {
        self.headerView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), self.headerHeight);
        self.scrollView.frame = CGRectMake(0, self.headerHeight, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds));
        self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.scrollView.bounds)*self.count,
                                                 CGRectGetHeight(self.scrollView.bounds));
    }
    if (offsetY > 0 && offsetY <= self.headerHeight) {
        self.headerView.frame = CGRectMake(0, -offsetY, CGRectGetWidth(self.view.bounds), self.headerHeight);
        self.scrollView.frame = CGRectMake(0, self.headerHeight-offsetY, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-64+offsetY);
        self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.scrollView.bounds)*self.count,
                                                 CGRectGetHeight(self.scrollView.bounds));
    }
    if (offsetY > self.headerHeight) {
        self.headerView.frame = CGRectMake(0, -self.headerHeight, CGRectGetWidth(self.view.bounds), self.headerHeight);
        self.scrollView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds));
        self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.scrollView.bounds)*self.count,
                                                 CGRectGetHeight(self.scrollView.bounds));
    }
}

#pragma mark - Private

- (void)selectedOnSegment:(NSInteger)index
{
    [self.segmentedControl setSelectedSegmentIndex:index animated:YES];
    __weak typeof(self) weakSelf = self;
    if (index == 0) {
        if (self.childControllers.count == 0) {
            QTUserPostMainController *userPostController = [[QTUserPostMainController alloc] init];
            userPostController.userUUID = self.userUUID;
            [userPostController setOnScrollingHandler:^(CGFloat offsetY) {
                [weakSelf calcuateOnScrolling:offsetY];
            }];
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
            QTUserLikeListController *likeListController = [[QTUserLikeListController alloc] init];
            likeListController.userUUID = self.userUUID;
            [likeListController setOnScrollingHandler:^(CGFloat offsetY) {
                [weakSelf calcuateOnScrolling:offsetY];
            }];
            [self.childControllers addObject:likeListController];
            likeListController.view.frame = CGRectMake(CGRectGetWidth(self.scrollView.bounds), 0,
                                                            CGRectGetWidth(self.scrollView.bounds),
                                                            CGRectGetHeight(self.scrollView.bounds));
            likeListController.view.userInteractionEnabled = YES;
            [self.scrollView addSubview:likeListController.view];
            [self addChildViewController:likeListController];
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

- (void)avatarAction
{
    [[RBImagebrowse createBrowseWithImages:@[self.userModel.avatar]] show];
}

#pragma mark - getter and setter

- (UIView *)headerView
{
    if (_headerView == nil) {
        _headerView = ({
            UIView *view = [[UIView alloc] init];
            view.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), self.headerHeight);
            view.backgroundColor = [UIColor whiteColor];
            view.clipsToBounds = YES;
            
            [view addSubview:self.avatarView];
            [self.avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.and.height.mas_equalTo(80);
                make.left.mas_equalTo(10);
                make.top.equalTo(view).offset(10);
            }];
            [view addSubview:self.nicknameButton];
            [self.nicknameButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.avatarView).offset(10);
                make.left.equalTo(self.avatarView.mas_right).offset(10);
                make.right.equalTo(view).offset(-40);
                make.height.mas_equalTo(30);
            }];
            [view addSubview:self.genderView];
            [self.genderView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.and.height.mas_equalTo(16);
                make.left.equalTo(self.nicknameButton);
                make.top.equalTo(self.nicknameButton.mas_bottom).offset(8);
            }];
            [view addSubview:self.areaLabel];
            [self.areaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.nicknameButton.mas_bottom).offset(6);
                make.left.equalTo(self.genderView.mas_right).offset(8);
                make.width.mas_greaterThanOrEqualTo(100);
                make.height.mas_equalTo(22);
            }];
            
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
//            button.layer.cornerRadius = 40;
//            button.layer.masksToBounds = YES;
            button.userInteractionEnabled = YES;
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
            button.titleLabel.font = [UIFont boldSystemFontOfSize:18];
            button.userInteractionEnabled = NO;
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            button;
        });
    }
    return _nicknameButton;
}

- (UIImageView *)genderView
{
    if (_genderView == nil) {
        _genderView = ({
            UIImageView *imageView = [[UIImageView alloc] init];
            //            imageView.backgroundColor = [UIColor yellowColor];
            imageView;
        });
    }
    return _genderView;
}

- (UILabel *)areaLabel
{
    if (_areaLabel == nil) {
        _areaLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.font = [UIFont systemFontOfSize:14];
            label.textAlignment = NSTextAlignmentLeft;
            label.textColor = [UIColor colorFromHexValue:0x999999];
            label;
        });
    }
    return _areaLabel;
}

- (HMSegmentedControl *)segmentedControl
{
    if (_segmentedControl == nil) {
        _segmentedControl = ({
            HMSegmentedControl *segmentedControl = [[HMSegmentedControl alloc]
                                                    initWithSectionTitles:@[@"快言"]];
            if (self.count > 1) {
                segmentedControl = [[HMSegmentedControl alloc]
                                    initWithSectionTitles:@[@"快言", @"赞"]];
            }
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
