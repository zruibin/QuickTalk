//
//  QTUserContactBookController.m
//  QuickTalk
//
//  Created by  Ruibin.Chow on 2017/12/20.
//  Copyright © 2017年 www.creactism.com. All rights reserved.
//

#import "QTUserContactBookController.h"
#import <Contacts/Contacts.h>

@interface QTUserContactBookController ()

@property (nonatomic, copy) NSDictionary *phoneDict;

- (void)initViews;
- (void)getContactData;

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
}

//获取联系人信息，并赋值给listData数组中
- (void)getContactData
{
    if ([CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts] == CNAuthorizationStatusAuthorized) {
        CNContactStore *stroe = [[CNContactStore alloc] init];
        [stroe requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError* _Nullable error) {
            if (granted) {
                NSMutableDictionary *tempDict = [NSMutableDictionary dictionary];
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
                        }
                    }
                }];
                self.phoneDict = [tempDict copy];
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


@end
