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
#import "QTMessageController.h"
#import "QTUserStarController.h"
#import "QTUserFansController.h"

@interface QTUserController () <UIScrollViewDelegate>

@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, assign) CGFloat headerHeight;
@property (nonatomic, strong) UIButton *avatarView;
@property (nonatomic, strong) UIButton *nicknameButton;
@property (nonatomic, strong) UIImageView *genderView;
@property (nonatomic, strong) UILabel *areaLabel;
@property (nonatomic, strong) YYLabel *countLabel;
@property (nonatomic, strong) UIView *messageView;
@property (nonatomic, strong) UIButton *countView;
@property (nonatomic, assign) NSInteger messageCount;
@property (nonatomic, strong) UIButton *actionButton;

@property (nonatomic, strong) HMSegmentedControl *segmentedControl;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *childControllers;
@property (nonatomic, strong) QTUserModel *userModel;
@property (nonatomic, assign) CGFloat offsetY;

- (void)initViews;
- (void)makeUserData;
- (void)makeUserView;
- (void)calcuateOnScrolling:(CGFloat)offsetY;
- (void)calcuateHeaderView;
- (void)makeStarActionData;
- (void)makeStarActionView;

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
    [Tools drawBorder:self.messageView top:NO left:NO bottom:YES right:NO
          borderColor:[UIColor colorFromHexValue:0xE4E4E4] borderWidth:.5f];
    [self calcuateHeaderView];
    [self calcuateOnScrolling:self.offsetY];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initViews
{
    self.title = self.nickname;
    self.count = 2;
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.headerView];
    [self calcuateHeaderView];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]
                                initWithImage:[UIImage imageNamed:@"more"]
                                style:UIBarButtonItemStylePlain target:self action:@selector(moreAction)];
    self.navigationItem.rightBarButtonItem = item;
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
            [self makeStarActionData];
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
    
    //关注
    NSString *fowllowString = [[Tools countTransition:self.userModel.followCount]
                               stringByAppendingString:@" 关注"];
    //粉丝
    NSString *fowllowingString = [[Tools countTransition:self.userModel.followingCount]
                                  stringByAppendingString:@" 粉丝"];
    //获赞数
    NSString *userPostLikeString = [[Tools countTransition:self.userModel.userPostLikeCount]
                                    stringByAppendingString:@"  获赞数"];
    
    NSString *string = [NSString stringWithFormat:@" %@   %@   %@",
                        fowllowString, fowllowingString, userPostLikeString];
    NSRange fowllowRange = [string rangeOfString:@"关注"];
    NSRange fowllowingRange = [string rangeOfString:@"粉丝"];
    NSRange userPostLikeRange = [string rangeOfString:@"获赞数"];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18]
                             range:NSMakeRange(0, string.length)];
    UIFont *font = [UIFont systemFontOfSize:13];
    UIColor *color = [UIColor colorFromHexValue:0x585858];
    [attributedString addAttribute:NSFontAttributeName value:font range:fowllowRange];
    [attributedString addAttribute:NSForegroundColorAttributeName value:color range:fowllowRange];
    [attributedString addAttribute:NSFontAttributeName value:font range:fowllowingRange];
    [attributedString addAttribute:NSForegroundColorAttributeName value:color range:fowllowingRange];
    [attributedString addAttribute:NSFontAttributeName value:font range:userPostLikeRange];
    [attributedString addAttribute:NSForegroundColorAttributeName value:color range:userPostLikeRange];
    __weak typeof(self) weakSelf = self;
    [attributedString yy_setTextHighlightRange:[string rangeOfString:fowllowString] color:nil backgroundColor:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        DLog(@"关注");
        QTUserStarController *userStarController = [[QTUserStarController alloc] init];
        userStarController.userUUID = weakSelf.userModel.uuid;
        [weakSelf.navigationController pushViewController:userStarController animated:YES];
    }];
    [attributedString yy_setTextHighlightRange:[string rangeOfString:fowllowingString] color:nil backgroundColor:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        DLog(@"粉丝");
        QTUserFansController *userFansController = [[QTUserFansController alloc] init];
        userFansController.userUUID = weakSelf.userModel.uuid;
        [weakSelf.navigationController pushViewController:userFansController animated:YES];
    }];
    self.countLabel.attributedText = [attributedString copy];
}

- (void)calcuateOnScrolling:(CGFloat)offsetY
{
//    DLog(@"y: %f", offsetY);
    if (offsetY <= 0) {
        self.headerView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), self.headerHeight);
        self.scrollView.frame = CGRectMake(0, self.headerHeight, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-self.headerHeight);
    }
    if (offsetY > 0 && offsetY <= self.headerHeight) {
        self.headerView.frame = CGRectMake(0, -offsetY, CGRectGetWidth(self.view.bounds), self.headerHeight);
        self.scrollView.frame = CGRectMake(0, self.headerHeight-offsetY, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-64+offsetY);
    }
    if (offsetY > self.headerHeight) {
        self.headerView.frame = CGRectMake(0, -self.headerHeight, CGRectGetWidth(self.view.bounds), self.headerHeight);
        self.scrollView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds));
    }
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.scrollView.bounds)*self.count,
                                             CGRectGetHeight(self.scrollView.bounds)-64);
    self.offsetY = offsetY;
}

- (void)calcuateHeaderView
{
    self.headerHeight = 144 + 40;
    if ([self.userUUID isEqualToString:[QTUserInfo sharedInstance].uuid]) {
        YYCache *cache = [YYCache cacheWithName:QTDataCache];
        self.messageCount = [(NSNumber *)[cache objectForKey:QTMessageCount] integerValue];
        if (self.messageCount > 0) {
            self.headerHeight = 144 + 40 + 40;
            self.messageView.hidden = NO;
            [self.countView setTitle:[NSString stringWithFormat:@"  %@条新通知  ", [Tools countTransition:self.messageCount]] forState:UIControlStateNormal];
            [self.messageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.and.top.and.right.equalTo(self.headerView);
                make.height.mas_equalTo(40);
            }];
        } else {
            self.messageView.hidden = YES;
            [self.messageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.and.top.and.right.equalTo(self.headerView);
                make.height.mas_equalTo(0);
            }];
        }
    } else {
        [self.messageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.and.top.and.right.equalTo(self.headerView);
            make.height.mas_equalTo(0);
        }];
        self.messageView.hidden = YES;
    }
    self.headerView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), self.headerHeight);
    self.scrollView.frame = CGRectMake(0, self.headerHeight, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-self.headerHeight);
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.scrollView.bounds)*self.count,
                                             CGRectGetHeight(self.scrollView.bounds)-64);
}

- (void)makeStarActionData
{
    if ([QTUserInfo sharedInstance].isLogin) {
        [QTUserModel requestStarRelation:[QTUserInfo sharedInstance].uuid uuidList:@[self.userModel.uuid] completionHandler:^(NSDictionary *dict, NSError *error) {
            if ([dict.allKeys containsObject:self.userModel.uuid]) {
                self.userModel.relationStatus = QTUserRelationStar;
            }
            [self makeStarActionView];
        }];
    } else {
        [self makeStarActionView];
    }
}

- (void)makeStarActionView
{
    if ([self.userUUID isEqualToString:[QTUserInfo sharedInstance].uuid]) {
        self.actionButton.hidden = YES;
    } else {
        if (self.userModel.relationStatus == QTUserRelationStar) {
            self.actionButton.hidden = NO;
            self.actionButton.layer.borderColor = [QuickTalk_SECOND_COLOR CGColor];
            [self.actionButton setTitleColor:QuickTalk_SECOND_COLOR forState:UIControlStateNormal];
            [self.actionButton setTitle:@"已关注" forState:UIControlStateNormal];
        } else {
            self.actionButton.hidden = NO;
            self.actionButton.layer.borderColor = [QuickTalk_MAIN_COLOR CGColor];
            [self.actionButton setTitleColor:QuickTalk_MAIN_COLOR forState:UIControlStateNormal];
            [self.actionButton setTitle:@"关注" forState:UIControlStateNormal];
        }
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
    [UIView animateWithDuration:.25f animations:^{
        [self calcuateOnScrolling:0];
    }];
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

- (void)moreAction
{
    if ([self.userUUID isEqualToString:[QTUserInfo sharedInstance].uuid]) {
        QTMessageController *messageController = [[QTMessageController alloc] init];
        messageController.userUUID = [QTUserInfo sharedInstance].uuid;
        [self.navigationController pushViewController:messageController animated:YES];
    } else if ([[QTUserInfo sharedInstance] checkLoginStatus:self]) {
        __weak typeof(self) weakSelf = self;
        void(^reportHandler)(NSInteger index) = ^(NSInteger index){
            [QTProgressHUD showHUD:weakSelf.view];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [QTProgressHUD showHUDWithText:@"举报成功" delay:2.0f];
            });
        };
        void(^blockHandler)(NSInteger index) = ^(NSInteger index){
            [QTProgressHUD showHUD:weakSelf.view];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [QTProgressHUD showHUDWithText:@"拉黑成功，系统将在24小时内处理" delay:2.0f];
            });
        };
        
        NSArray *items = @[
                           MMItemMake(@"举报", MMItemTypeHighlight, reportHandler)
                           ,MMItemMake(@"拉黑", MMItemTypeHighlight, blockHandler)
                           ];
        MMSheetView *sheetView = [[MMSheetView alloc] initWithTitle:@""
                                                              items:items];
        sheetView.attachedView.mm_dimBackgroundBlurEnabled = NO;
        [sheetView show];
    }
}

- (void)starOrUnStarAction
{
    if ([[QTUserInfo sharedInstance] checkLoginStatus:self] == NO) {
        return;
    }
    NSString *action = STAR_ACTION_FOR_STAR;
    if (self.userModel.relationStatus == QTUserRelationStar) {
        action = STAR_ACTION_FOR_UNSTAR;
    }
    [QTUserModel requestForStarOrUnStar:[QTUserInfo sharedInstance].uuid contentUUID:self.userModel.uuid action:action completionHandler:^(BOOL action, NSError *error) {
        if (error) {
            [QTProgressHUD showHUDText:error.userInfo[ERROR_MESSAGE] view:self.view];
        } else {
            if (self.userModel.relationStatus == QTUserRelationStar) {
                self.userModel.relationStatus = QTUserRelationDefault;
            } else {
                self.userModel.relationStatus = QTUserRelationStar;
            }
            [self makeStarActionView];
        }
    }];
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
            
            [view addSubview:self.messageView];
            [self.messageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.and.top.and.right.equalTo(view);
                make.height.mas_equalTo(40);
            }];
            [self.messageView addSubview:self.countView];
            [self.countView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.and.centerY.equalTo(self.messageView);
                make.height.mas_equalTo(30);
                make.width.mas_greaterThanOrEqualTo(100);
            }];
            
            [view addSubview:self.avatarView];
            [self.avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.and.height.mas_equalTo(80);
                make.left.mas_equalTo(10);
                make.top.equalTo(self.messageView.mas_bottom).offset(10);
            }];
            [view addSubview:self.nicknameButton];
            [self.nicknameButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.avatarView).offset(10);
                make.left.equalTo(self.avatarView.mas_right).offset(10);
                make.right.equalTo(view).offset(-90);
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
            [view addSubview:self.actionButton];
            [self.actionButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(70);
                make.height.mas_equalTo(32);
                make.centerY.equalTo(self.avatarView);
                make.right.equalTo(view).offset(-15);
            }];
            [view addSubview:self.countLabel];
            [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(view).offset(10);
                make.right.equalTo(view).offset(-10);
                make.top.equalTo(self.avatarView.mas_bottom).offset(10);
                make.height.mas_equalTo(40);
            }];
            [view addSubview:self.segmentedControl];
            [self.segmentedControl mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.and.bottom.and.right.equalTo(view);
                make.height.mas_equalTo(44);
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
            button.layer.cornerRadius = 4;
            button.layer.masksToBounds = YES;
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
            button.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
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

- (YYLabel *)countLabel
{
    if (_countLabel == nil) {
        _countLabel = ({
            YYLabel *label = [[YYLabel alloc] init];
//            label.font = [UIFont systemFontOfSize:14];
            label.userInteractionEnabled = YES;
            label.textAlignment = NSTextAlignmentLeft;
            label;
        });
    }
    return _countLabel;
}

- (UIView *)messageView
{
    if (_messageView == nil) {
        _messageView = ({
            UIView *view = [[UIView alloc] init];
//            view.backgroundColor = [UIColor redColor];
            view;
        });
    }
    return _messageView;
}

- (UIButton *)countView
{
    if (_countView == nil) {
        _countView = ({
            UIButton *countView = [UIButton buttonWithType:UIButtonTypeCustom];
            [countView setBackgroundImage:[UIImage createImageWithColor:[UIColor colorFromHexValue:0xFF4F4F]] forState:UIControlStateNormal];
            countView.titleLabel.textColor = [UIColor whiteColor];
            countView.titleLabel.font = [UIFont systemFontOfSize:12];
            countView.layer.cornerRadius = 4;
            countView.layer.masksToBounds = YES;
            [countView addTarget:self action:@selector(moreAction) forControlEvents:UIControlEventTouchUpInside];
            countView;
        });
    }
    return _countView;
}

- (UIButton *)actionButton
{
    if (_actionButton == nil) {
        _actionButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setBackgroundImage:[UIImage createImageWithColor:[UIColor colorFromHexValue:0x000 withAlpha:.4]]
                              forState:UIControlStateHighlighted];
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            button.userInteractionEnabled = YES;
            button.layer.borderWidth = 1;
            button.layer.cornerRadius = 2;
            button.layer.borderColor = [QuickTalk_MAIN_COLOR CGColor];
            [button setTitleColor:QuickTalk_MAIN_COLOR forState:UIControlStateNormal];
            [button setTitle:@"关注" forState:UIControlStateNormal];
            [button addTarget:self action:@selector(starOrUnStarAction) forControlEvents:UIControlEventTouchUpInside];
            button;
        });
    }
    return _actionButton;
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
