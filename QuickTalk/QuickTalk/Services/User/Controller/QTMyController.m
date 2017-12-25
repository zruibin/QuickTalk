//
//  QTMyController.m
//  QuickTalk
//
//  Created by  Ruibin.Chow on 2017/11/7.
//  Copyright © 2017年 www.creactism.com. All rights reserved.
//

#import "QTMyController.h"
#import "QTAccountInfoEditController.h"
#import "QTSettingController.h"
#import "QTUserController.h"
#import "QTUserCollectionController.h"
#import "QTUserStarAndFansController.h"
#import "RBImagebrowse.h"
#import "QTMyCell.h"

@interface QTMyController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray *dataList;
@property (nonatomic, copy) NSDictionary *dataDict;
@property (nonatomic, strong) FBKVOController *kvoController;

- (void)initViews;

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
        weakSelf.dataDict = nil;
        [weakSelf.tableView reloadData];
    }];
    
    self.kvoController = [FBKVOController controllerWithObserver:self];
    [self.kvoController observe:[QTUserInfo sharedInstance] keyPath:@"avatar" options:NSKeyValueObservingOptionNew block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
        weakSelf.dataDict = nil;
        [weakSelf.tableView reloadData];
    }];
    [self.kvoController observe:[QTUserInfo sharedInstance] keyPath:@"nickname" options:NSKeyValueObservingOptionNew block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
        weakSelf.dataDict = nil;
        [weakSelf.tableView reloadData];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initViews
{
    self.title = @"我";
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - TableView Delegate And DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *key = self.dataList[section];
    return [self.dataDict[key] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QTTableViewCellMake(QTMyCell, cell)
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    NSString *key = self.dataList[indexPath.section];
    NSArray *data = self.dataDict[key][indexPath.row];
    
    UIImage *image = [UIImage imageNamed:data[0]];
    cell.iconView.image = image;
    if (image == nil) {
        [cell.iconView cra_setImage:data[0]];
    }
    cell.titleLabel.text = data[1];
    
    if ([key isEqualToString:@"user"]) {
        cell.titleLabel.font = [UIFont systemFontOfSize:18];
        cell.multiplie = 0.8;
    } else {
        cell.titleLabel.font = [UIFont systemFontOfSize:16];
        cell.multiplie = 0.5;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *key = self.dataList[indexPath.section];
    return [self.dataDict[key][indexPath.row][2] floatValue];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    /*顶部和第一行数据之间的间隔要将0改为一个非0的数值即可实现*/
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *key = self.dataList[indexPath.section];
    NSArray *data = self.dataDict[key][indexPath.row];
    
    UIViewController *viewController = [[NSClassFromString(data[3]) alloc] init];
    
    unsigned int outCount = 0;
    objc_property_t * properties = class_copyPropertyList(NSClassFromString(data[3]), &outCount);
    for (unsigned int i = 0; i < outCount; i ++) {
        objc_property_t property = properties[i];
        const char *name = property_getName(property);
        if ([@"userUUID" isEqualToString:[NSString stringWithUTF8String:name]]) {
            [viewController setValue:[QTUserInfo sharedInstance].uuid forKey:@"userUUID"];
        }
    }
    free(properties);
    
    
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - Action



#pragma mark - setter and getter

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
            tableView.exclusiveTouch = YES;
            tableView.backgroundColor = [UIColor colorFromHexValue:0xEFEFEF];
            tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
            QTTableViewCellRegister(tableView, QTMyCell)
            tableView;
        });
    }
    return _tableView;
}


- (NSArray *)dataList
{
    NSArray *list = @[@"user", @"data", @"setting"];
    if ([QTUserInfo sharedInstance].isLogin == NO) {
        list = @[@"setting"];
    }
    return list;
}

- (NSDictionary *)dataDict
{
    if (_dataDict == nil) {
        NSString *height = @"44";
        NSString *avatar = [QTUserInfo sharedInstance].avatar.length == 0 ? @"" : [QTUserInfo sharedInstance].avatar;
        NSString *nickname = [QTUserInfo sharedInstance].nickname.length == 0 ? @"" : [QTUserInfo sharedInstance].nickname;
        _dataDict = @{
                       @"user": @[
                               @[avatar, nickname, @"88", NSStringFromClass([QTAccountInfoEditController class])]
                               ],
                       @"data": @[
                               @[@"users", @"关注与粉丝", height, NSStringFromClass([QTUserStarAndFansController class])],
                               @[@"userPost", @"我的快言", height, NSStringFromClass([QTUserController class])],
                               @[@"collection", @"收藏", height, NSStringFromClass([QTUserCollectionController class])],
                               ],
                       @"setting": @[
                               @[@"setting", @"设置", height, NSStringFromClass([QTSettingController class])]
                               ]
                       };
    }
    return _dataDict;
}



@end
