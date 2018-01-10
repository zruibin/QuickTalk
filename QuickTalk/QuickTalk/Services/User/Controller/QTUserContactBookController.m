//
//  QTUserContactBookController.m
//  QuickTalk
//
//  Created by  Ruibin.Chow on 2017/12/20.
//  Copyright © 2017年 www.creactism.com. All rights reserved.
//

#import "QTUserContactBookController.h"
#import "QTUserCell.h"
#import "QTUserModel.h"
#import "QTUserController.h"

@interface QTUserContactBookController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataList;
@property (nonatomic, strong) QTErrorView *errorView;
@property (nonatomic, copy) NSDictionary *phoneDict;
@property (nonatomic, strong) NSArray *phoneList;

- (void)initViews;
- (void)getContactData;
- (void)loadData;
- (void)starOrUnStarAction:(NSInteger)index;

@end

@implementation QTUserContactBookController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initViews];
    [self getContactData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initViews
{
    self.title = @"通讯录";
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.view addSubview:self.errorView];
    self.errorView.hidden = YES;
}

//获取联系人信息，并赋值给listData数组中
- (void)getContactData
{
    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    if (status == CNAuthorizationStatusAuthorized) {
        CNContactStore *stroe = [[CNContactStore alloc] init];
        [stroe requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError* _Nullable error) {
            if (granted) {
                NSMutableDictionary *tempDict = [NSMutableDictionary dictionary];
                NSMutableArray *tempList = [NSMutableArray array];
                CNContactStore *stroe = [[CNContactStore alloc] init];
                NSArray *keys = @[CNContactGivenNameKey, CNContactPhoneNumbersKey];
                CNContactFetchRequest *request = [[CNContactFetchRequest alloc] initWithKeysToFetch:keys];
                [stroe enumerateContactsWithFetchRequest:request error:nil usingBlock:^(CNContact *_Nonnull contact, BOOL * _Nonnull stop) {
//                    DLog(@"name: %@", contact.givenName);
                    for (CNLabeledValue<CNPhoneNumber*>*phoneValue in contact.phoneNumbers) {
                        NSString *phone = [phoneValue.value.stringValue stringByReplacingOccurrencesOfString:@"-" withString:@""];
//                        DLog(@"phone: %@", phone);
                        if ([phone isMobileNumber]) {
                            [tempDict setObject:contact.givenName forKey:phone];
                            [tempList addObject:phone];
                        }
                    }
                }];
                self.phoneDict = [tempDict copy];
                self.phoneList = [tempList copy];
                dispatch_async(dispatch_get_main_queue(), ^{
                   [self loadData];
                });
                DLog(@"phones: %@", self.phoneDict);
            }else{
                DLog(@"error...");
            }
        }];
    } else{
        __weak typeof(self) weakSelf = self;
        MMPopupItemHandler block = ^(NSInteger index) {
            NSURL *settingUrl = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication] canOpenURL:settingUrl]) {
                [[UIApplication sharedApplication] openURL:settingUrl];
            }
        };
        MMPopupItemHandler cancel = ^(NSInteger index) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        };
        NSArray *items = @[MMItemMake(@"取消", MMItemTypeNormal, cancel), MMItemMake(@"去设置", MMItemTypeNormal, block),];
        MMAlertView *view = [[MMAlertView alloc] initWithTitle:@"提示" detail:@"未获得通讯录权限，是否去设置->隐私->通讯录中授予快言该权限？" items:items];
        [view show];
    }
}

- (void)loadData
{
    [QTProgressHUD showHUD:self.view];
    [QTUserModel requestPhoneUserData:[QTUserInfo sharedInstance].uuid phones:self.phoneList completionHandler:^(NSArray<QTUserModel *> *list, NSError *error) {
        if (error) {
            [QTProgressHUD showHUDWithText:error.userInfo[ERROR_MESSAGE]];
        } else {
            NSMutableArray *uuidList = [NSMutableArray arrayWithCapacity:list.count];
            for (QTUserModel *model in list) {
                [uuidList addObject:model.uuid];
            }
            /*查询是否已关注*/
            [QTUserModel requestStarRelation:[QTUserInfo sharedInstance].uuid uuidList:[uuidList copy] completionHandler:^(NSDictionary *dict, NSError *error) {
                if (error) {
                    [QTProgressHUD showHUDWithText:error.userInfo[ERROR_MESSAGE]];
                } else {
                    [QTProgressHUD showHUDSuccess];
                    self.dataList = [list copy];
                    NSArray *keys = dict.allKeys;
                    for (QTUserModel *model in self.dataList) {
                        if ([keys containsObject:model.uuid]) {
                            model.relationStatus = QTUserRelationStar;
                        }
                    }
                    [self.tableView reloadData];
                }
            }];
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
    NSString *phoneName = self.phoneDict[model.phone];
    [cell loadData:model.avatar nickname:model.nickname subname:phoneName];
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

#pragma mark - Action


#pragma mark - getter and setter

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = ({
            UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
            tableView.backgroundColor = [UIColor redColor];
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

- (QTErrorView *)errorView
{
    if (_errorView == nil) {
        _errorView = ({
            QTErrorView *view = [[QTErrorView alloc] initWithFrame:self.view.bounds];
//            __weak typeof(self) weakSelf = self;
//            [view setOnRefreshHandler:^{
//                [weakSelf.tableView beginHeaderRefreshing];
//            }];
            view;
        });
    }
    return _errorView;
}



@end
