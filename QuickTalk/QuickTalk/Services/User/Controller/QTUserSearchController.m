//
//  QTUserSearchController.m
//  QuickTalk
//
//  Created by  Ruibin.Chow on 2017/12/20.
//  Copyright © 2017年 www.creactism.com. All rights reserved.
//

#import "QTUserSearchController.h"
#import "QTUserCell.h"
#import "QTUserModel.h"
#import "QTUserController.h"

@interface QTUserSearchController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataList;
@property (nonatomic, assign) NSInteger page;

- (void)initViews;
- (void)loadData;
- (void)starOrUnStarAction:(NSInteger)index;

@end

@implementation QTUserSearchController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initViews];
    [self.textField becomeFirstResponder];
    
    __weak typeof(self) weakSelf = self;
    [self.tableView footerWithRefreshingBlock:^{
        weakSelf.page += 1;
        [weakSelf loadData];
    }];
    [self.tableView hiddenFooter];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initViews
{    
    CGFloat width = CGRectGetWidth([[UIScreen mainScreen] bounds]) - 80;
    self.textField.frame = CGRectMake(36, 6, width-36, 32);
    UIView *searchView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 44)];
    [searchView addSubview:self.textField];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[[UIImage imageNamed:@"back"] imageWithTintColor:[UIColor blackColor]]
                forState:UIControlStateNormal];
    backButton.frame = CGRectMake(0, 0, 36, 44);
    backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [backButton addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [searchView addSubview:backButton];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:searchView];;
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]
                             initWithTitle:@"搜索" style:UIBarButtonItemStylePlain target:self action:@selector(searchAction)];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)loadData
{
    [QTProgressHUD showHUD:self.view];
    [QTUserModel requestForSearchUser:self.textField.text page:self.page userUUID:[QTUserInfo sharedInstance].uuid completionHandler:^(NSArray<QTUserModel *> *list, NSError *error) {
        if (error) {
            [QTProgressHUD showHUDWithText:error.userInfo[ERROR_MESSAGE]];
        } else {
            [self.tableView showFooter];
            if (list.count < 10) {
                [self.tableView endRefreshingWithNoMoreData];
            } else {
                [self.tableView endFooterRefreshing];
            }
            [QTProgressHUD showHUDSuccess];
            [self.dataList addObjectsFromArray:list];
            [self.tableView reloadData];
        }
    }];
}

- (void)starOrUnStarAction:(NSInteger)index
{
    QTUserModel *model = self.dataList[index];
    NSString *action = STAR_ACTION_FOR_STAR;
    if (model.relationStatus == QTUserRelationStar) {
        action = STAR_ACTION_FOR_UNSTAR;
    }
    [QTUserModel requestForStarOrUnStar:[QTUserInfo sharedInstance].uuid contentUUID:model.uuid action:action completionHandler:^(BOOL action, NSError *error) {
        if (error) {
            [QTProgressHUD showHUDText:error.userInfo[ERROR_MESSAGE] view:self.view];
        } else {
            if (model.relationStatus == QTUserRelationStar) {
                model.relationStatus = QTUserRelationDefault;
            } else {
                model.relationStatus = QTUserRelationStar;
            }
            [self.tableView reloadData];
        }
    }];
}

#pragma mark - Action

- (void)backButtonAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)searchAction
{
    if (self.textField.text.length == 0) {
        return ;
    }
    if ([self.textField.text stringContainsEmoji]) {
        [QTMessage showWarningNotification:@"暂不支持Emoji表情"];
        return;
    }
    [self.textField resignFirstResponder];
    self.page = 1;
    self.dataList = [NSMutableArray array];
    [self loadData];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self searchAction];
    return YES;
}

#pragma mark - TableView Delegate And DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QTTableViewCellMake(QTUserCell, cell)
    cell.tag = indexPath.row;
    QTUserModel *model = self.dataList[indexPath.row];
    [cell loadData:model.avatar nickname:model.nickname subname:nil];
    if (model.relationStatus == QTUserRelationDefault) {
        cell.relationStatus = QTViewRelationDefault;
    } else {
        cell.relationStatus = QTViewRelationStar;
    }

    __weak typeof(self) weakSelf = self;
    [cell setOnAvatarHandler:^(NSInteger index) {
        QTUserController *userController = [[QTUserController alloc] init];
        QTUserModel *userModel = weakSelf.dataList[index];
        userController.userUUID = userModel.uuid;
        [weakSelf.navigationController pushViewController:userController animated:YES];
    }];
    [cell setOnActionHandler:^(NSInteger index) {
        [weakSelf starOrUnStarAction:index];
    }];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    QTUserController *userController = [[QTUserController alloc] init];
    QTUserModel *userModel = self.dataList[indexPath.row];
    userController.userUUID = userModel.uuid;
    [self.navigationController pushViewController:userController animated:YES];
}

#pragma mark - getter and setter

- (UITextField *)textField
{
    if (_textField == nil) {
        _textField = ({
            UITextField *textField = [[UITextField alloc] init];
            textField.clearButtonMode = UITextFieldViewModeAlways;
            textField.backgroundColor = [UIColor clearColor];
//            textField.textColor = [UIColor colorFromHexValue:0x999999];
            textField.font = [UIFont systemFontOfSize:15];
            textField.layer.borderWidth = .5f;
            textField.layer.cornerRadius = 6;
            textField.layer.borderColor = [QuickTalk_SECOND_COLOR CGColor];
            textField.placeholder = @"手机号/昵称";
            textField.returnKeyType = UIReturnKeyDone;
            textField.delegate = self;

            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search"]];
            imageView.frame = CGRectMake(9, 9, 16, 16);
            UIView *leftview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
            [leftview addSubview:imageView];
            textField.leftViewMode = UITextFieldViewModeAlways;
            textField.leftView = leftview;
            
            textField;
        });
    }
    return _textField;
}


- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = ({
            UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
            tableView.estimatedRowHeight = 0;
            tableView.estimatedSectionHeaderHeight = 0;
            tableView.estimatedSectionFooterHeight = 0;
            tableView.delegate = self;
            tableView.dataSource = self;
            tableView.translatesAutoresizingMaskIntoConstraints = NO;
            tableView.showsVerticalScrollIndicator = NO;
            tableView.exclusiveTouch = YES;
            tableView.backgroundColor = [UIColor clearColor];
            tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
            QTTableViewCellRegister(tableView, QTUserCell)
            tableView.tableFooterView = [UIView new];
            tableView;
        });
    }
    return _tableView;
}



@end
