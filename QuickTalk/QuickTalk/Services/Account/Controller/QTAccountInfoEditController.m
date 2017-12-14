//
//  QTAccountInfoEditController.m
//  QuickTalk
//
//  Created by  Ruibin.Chow on 2017/12/13.
//  Copyright © 2017年 www.creactism.com. All rights reserved.
//

#import "QTAccountInfoEditController.h"
#import "QTInfoEditController.h"
#import "QTAvatarEditController.h"
#import "CRAPickerView.h"
#import "QTAccountInfo.h"

@interface QTAccountInfoEditController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) FBKVOController *kvoController;

@end

@implementation QTAccountInfoEditController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initViews];
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
    self.title = @"个人信息";
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    self.kvoController = [FBKVOController controllerWithObserver:self];
    __weak typeof(self) weakSelf = self;
    [self.kvoController observe:[QTUserInfo sharedInstance] keyPath:@"avatar" options:NSKeyValueObservingOptionNew block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
        UITableViewCell *cell = [weakSelf.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        UIImageView *avatar = (UIImageView *)[cell viewWithTag:1000];
        [avatar circularImage:[QTUserInfo sharedInstance].avatar];
    }];
}

#pragma mark - Action


#pragma mark - TableView Delegate And DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) {
        return 3;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QTTableViewCellMake(UITableViewCell, cell)
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textColor = [UIColor colorFromHexValue:0x999999];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.section == 0 && indexPath.row == 0) {
        UIImageView *avatarView =  [cell viewWithTag:1010110];
        if (avatarView == nil) {
            avatarView = [[UIImageView alloc] init];
            avatarView.frame = CGRectMake(CGRectGetWidth(tableView.bounds)-35-30, 7.5, 35, 35);
            avatarView.tag = 1010110;
            [cell addSubview:avatarView];
        }
        cell.textLabel.text = @"头像";
        [avatarView cra_setImage:[QTUserInfo sharedInstance].avatar];
    }
    if (indexPath.section == 1) {
        UILabel *label = [cell viewWithTag:1010111];
        if (label == nil) {
            label = [[UILabel alloc] init];
            label.font = [UIFont systemFontOfSize:14];
            label.textColor = [UIColor blackColor];
            label.tag = [[NSString stringWithFormat:@"1%ld", (long)indexPath.row] integerValue];
            label.translatesAutoresizingMaskIntoConstraints = NO;
            label.tag = 1010111;
            [cell.contentView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(cell.contentView).offset(60);
                make.right.equalTo(cell.contentView).offset(-60);
                make.top.equalTo(cell.contentView).offset(5);
                make.bottom.equalTo(cell.contentView).offset(-5);
            }];
        }
        
        if (indexPath.row == 0) {
            cell.textLabel.text = @"昵称";
            label.text = [QTUserInfo sharedInstance].nickname;
        }
        if (indexPath.row == 1) {
            cell.textLabel.text = @"性别";
            NSString *genderStr = @"";
            NSInteger gender = [QTUserInfo sharedInstance].gender;
            if (gender == QuickTalk_GENDER_MALE) {
                genderStr = @"男";
            }
            if (gender == QuickTalk_GENDER_FEMALE) {
                genderStr = @"女";
            }
            label.text = genderStr;
        }
        if (indexPath.row == 2) {
            cell.textLabel.text = @"地区";
            label.text = [QTUserInfo sharedInstance].area;
        }
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 50;
    }
    if (indexPath.section == 2 && indexPath.row == 0) {
        return 100;
    }
    return 44;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    /*顶部和第一行数据之间的间隔要将0改为一个非0的数值即可实现*/
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 15;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        QTAvatarEditController *controller = [QTAvatarEditController new];
        [self.navigationController pushViewController:controller animated:YES];
    }
    if (indexPath.section == 1) {
        __weak typeof(self) weakSelf = self;
        if (indexPath.row == 0) { //昵称
            QTInfoEditController *infoEditController = [QTInfoEditController new];
            [self.navigationController pushViewController:infoEditController animated:YES];
        }
        if (indexPath.row == 1) { //性别
            [CRAStringPickerView showStringPickerWithTitle:@"性别" dataSource:@[@"男", @"女"] defaultSelValue:@"男" isAutoSelect:NO resultBlock:^(id selectValue) {
                NSString *gender = @"0";
                if ([selectValue isEqualToString:@"女"]) {
                    gender = @"2";
                }
                if ([selectValue isEqualToString:@"男"]) {
                    gender = @"1";
                }
                [QTAccountInfo requestForChangeGender:[QTUserInfo sharedInstance].uuid gender:gender completionHandler:^(BOOL action, NSError *error) {
                    if (action) {
                        [QTUserInfo sharedInstance].gender = [gender integerValue];
                        [weakSelf.tableView reloadData];
                    } else {
                        [QTProgressHUD showHUDText:error.userInfo[ERROR_MESSAGE] view:weakSelf.view];
                    }
                }];
            }];
        }
        if (indexPath.row == 2) {
            [CRALocationPickerView showAddressPickerWithDefaultSelected:nil isAutoSelect:NO resultBlock:^(NSArray *selectAddressArr) {
                NSString *area = selectAddressArr[1];
                [QTAccountInfo requestForAccountInfo:[QTUserInfo sharedInstance].uuid type:@"area" data:area completionHandler:^(BOOL action, NSError *error) {
                    if (action) {
                        [QTUserInfo sharedInstance].area = area;
                        [weakSelf.tableView reloadData];
                    } else {
                        [QTProgressHUD showHUDText:error.userInfo[ERROR_MESSAGE] view:weakSelf.view];
                    }
                }];
            }];
        }
    }
}

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
            QTTableViewCellRegister(tableView, UITableViewCell)
            tableView;
        });
    }
    return _tableView;
}

@end
