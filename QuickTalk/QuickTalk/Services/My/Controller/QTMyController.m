//
//  QTMyController.m
//  QuickTalk
//
//  Created by  Ruibin.Chow on 2017/11/7.
//  Copyright © 2017年 www.creactism.com. All rights reserved.
//

#import "QTMyController.h"
#import "QTMyCell.h"
#import "QTCommentModel.h"
#import "QTSettingController.h"
#import "QTAvatarEditController.h"
#import "QTInfoEditController.h"
#import "QTTopicController.h"


@interface QTMyController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataList;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIButton *avatarView;
@property (nonatomic, strong) UIButton *nicknameButton;


- (void)loadData;

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
    
    __weak typeof(self) weakSelf = self;
    [[NSNotificationCenter defaultCenter] addObserverForName:QTLoginStatusChangeNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        if ([QTUserInfo sharedInstance].isLogin == NO) {
            weakSelf.headerView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 0);
            [weakSelf.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(weakSelf.view);
            }];
            [weakSelf.dataList removeAllObjects];
            [weakSelf.tableView reloadData];
        } else {
            weakSelf.headerView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 100);
            [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.and.right.and.bottom.equalTo(weakSelf.view);
                make.top.equalTo(weakSelf.view).offset(100);
            }];
            [weakSelf.tableView beginHeaderRefreshing];
            [self.avatarView cra_setBackgroundImage:[QTUserInfo sharedInstance].avatar];
            [self.nicknameButton setTitle:[QTUserInfo sharedInstance].nickname forState:UIControlStateNormal];
        }
    }];

    [self.tableView headerWithRefreshingBlock:^{
        weakSelf.page = 1;
        weakSelf.dataList = [NSMutableArray array];
        [weakSelf loadData];
    }];
    [self.tableView beginHeaderRefreshing];
    
    [self.tableView footerWithRefreshingBlock:^{
        weakSelf.page += 1;
        [weakSelf loadData];
    }];
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
    self.title = @"我";
    [self.view addSubview:self.headerView];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.bottom.equalTo(self.view);
        make.top.equalTo(self.view).offset(100);
    }];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"更多" style:UIBarButtonItemStylePlain target:self action:@selector(settingAction)];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)loadData
{
    if ([[QTUserInfo sharedInstance] checkLoginStatus:self] == NO) {
        [self.tableView endHeaderRefreshing];
        [self.tableView endFooterRefreshing];
        return;
    }
    [QTCommentModel requestMyCommentData:[QTUserInfo sharedInstance].uuid page:self.page completionHandler:^(NSArray<QTCommentModel *> *list, NSError *error) {
        if (error) {
            [QTProgressHUD showHUDText:error.userInfo[ERROR_MESSAGE] view:self.view];
        } else {
            [self.dataList addObjectsFromArray:[list copy]];
            if (self.page == 1) {
                [self.tableView endHeaderRefreshing];
                if (list.count < 10) {
                    [self.tableView hiddenFooter];
                }
                [self.tableView endFooterRefreshing];
            } else {
                if (list.count < 10) {
                    [self.tableView endRefreshingWithNoMoreData];
                } else {
                    [self.tableView endFooterRefreshing];
                }
            }
            [self.tableView reloadData];
        }
    }];
}


#pragma mark - TableView Delegate And DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QTMyCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([QTMyCell class])];
    cell.tag = indexPath.section;
    QTCommentModel *model = self.dataList[indexPath.section];
    [cell loadData:model.content avatar:model.avatar time:model.time likeNum:model.like title:model.title];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 80.0f;
    QTMyCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([QTMyCell class])];
    QTCommentModel *model = self.dataList[indexPath.section];
    height = [cell heightForCell:model.content];
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    /*顶部和第一行数据之间的间隔要将0改为一个非0的数值即可实现*/
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    QTCommentModel *model = self.dataList[indexPath.section];
    QTTopicController *topicController = [[QTTopicController alloc] init];
    topicController.topicUUID = model.topicUUID;
    [self.navigationController pushViewController:topicController animated:YES];
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

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = ({
            UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
            tableView.estimatedRowHeight = 0;
            tableView.estimatedSectionHeaderHeight = 0;
            tableView.estimatedSectionFooterHeight = 0;
            tableView.delegate = self;
            tableView.dataSource = self;
            tableView.translatesAutoresizingMaskIntoConstraints = NO;
            tableView.showsVerticalScrollIndicator = NO;
            tableView.exclusiveTouch = YES;
            tableView.backgroundColor = [UIColor clearColor];
            tableView.contentInset = UIEdgeInsetsMake(5, 0, 0, 0);
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            [tableView registerClass:[QTMyCell class] forCellReuseIdentifier:NSStringFromClass([QTMyCell class])];
            tableView;
        });
    }
    return _tableView;
}

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

@end
