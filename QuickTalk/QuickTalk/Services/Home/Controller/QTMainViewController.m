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
#import "QTIntroController.h"
#import "QTMainCell.h"
#import "QTTopicSpeaker.h"

@interface QTMainViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataList;
@property (nonatomic, assign) CGFloat viewWidth;
@property (nonatomic, assign) CGFloat viewHeight;
@property (nonatomic, strong) QTErrorView *errorView;
@property (nonatomic, assign) NSInteger page;

- (void)initViews;
- (void)loadData;
- (void)speakingTopicContent:(NSString *)uuid index:(NSInteger)index;

@end

@implementation QTMainViewController

- (void)dealloc
{
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:QTRefreshDataNotification object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initViews];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:QTRefreshDataNotification object:nil];

    __weak typeof(self) weakSelf = self;
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
    
    self.errorView.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initViews
{
    self.title = @"快言";
    self.viewWidth = CGRectGetWidth([[UIScreen mainScreen] bounds]);
    self.viewHeight = CGRectGetHeight([[UIScreen mainScreen] bounds]);
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];

    [self.view addSubview:self.errorView];
    
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"first"] == nil) {
        QTIntroController *introController = [[QTIntroController alloc] init];
        [self presentViewController:introController animated:YES completion:nil];
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"first"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)loadData
{
    [QTProgressHUD showHUD:self.view];
    [QTTopicModel requestTopicData:self.page completionHandler:^(NSArray<QTTopicModel *> *list, NSError *error) {
        if (error) {
            [QTProgressHUD showHUDWithText:error.userInfo[ERROR_MESSAGE]];
            if (self.page == 1) {
                self.errorView.hidden = NO;
            }
        } else {
            [QTProgressHUD hide];
            self.errorView.hidden = YES;
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

- (void)speakingTopicContent:(NSString *)uuid index:(NSInteger)index
{
    if (![QTNetworking checkingNetworkStatus]) {
        [QTProgressHUD showHUDText:@"网络开了点小差，请稍后再试!" view:self.view];
        return ;
    }
    
    QTTopicModel *model = self.dataList[index];
    QTMainCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index]];
    QTTopicSpeaker *topicSpeaker = [QTTopicSpeaker sharedInstance];
    if ([topicSpeaker.name isEqualToString:model.uuid]) {
        if (topicSpeaker.speaker.status == QTSpeakerNone ||
            topicSpeaker.speaker.status == QTSpeakerDestory) {
            topicSpeaker.name = model.uuid;
            topicSpeaker.title = model.title;
            [topicSpeaker speakingForRequest:model.uuid view:self.view completionHandler:^(BOOL action, NSError *error) {
                if (action) {
                    cell.speaking = NO;
                    [self.tableView reloadData];
                }
            }];
        } else {
            if (topicSpeaker.speaker.status == QTSpeakerPause) {
                cell.speaking = YES;
                [topicSpeaker resumeSpeaking];
            } else {
                cell.speaking = NO;
                [topicSpeaker pauseSpeaking];
            }
            [self.tableView reloadData];
        }
    } else {
        topicSpeaker.name = model.uuid;
        topicSpeaker.title = model.title;
        [topicSpeaker speakingForRequest:model.uuid view:self.view completionHandler:^(BOOL action, NSError *error) {
            if (action) {
                cell.speaking = NO;
                [self.tableView reloadData];
            }
        }];
    }
}

#pragma mark - Private

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
    QTMainCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([QTMainCell class])];
    cell.tag = indexPath.section;
    QTTopicModel *model = self.dataList[indexPath.section];
    [cell loadData:model.title time:model.time uuid:model.uuid];
    __weak typeof(self) weakSelf = self;
    [cell setOnPlayActionHandler:^(NSString *uuid, NSInteger index) {
        [weakSelf speakingTopicContent:uuid index:index];
    }];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0.0f;
    QTMainCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([QTMainCell class])];
    QTTopicModel *model = self.dataList[indexPath.section];
    height = [cell heightForCell:model.title];
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
    QTTopicModel *model = self.dataList[indexPath.section];
    QTTopicController *topicController = [[QTTopicController alloc] init];
    topicController.model = model;
    [self.navigationController pushViewController:topicController animated:YES];
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
            [tableView registerClass:[QTMainCell class] forCellReuseIdentifier:NSStringFromClass([QTMainCell class])];
            tableView;
        });
    }
    return _tableView;
}

- (QTErrorView *)errorView
{
    if (_errorView == nil) {
        _errorView = ({
            QTErrorView *view = [[QTErrorView alloc] initWithFrame:self.view.bounds];
            __weak typeof(self) weakSelf = self;
            [view setOnRefreshHandler:^{
                [weakSelf loadData];
            }];
            view;
        });
    }
    return _errorView;
}

@end
