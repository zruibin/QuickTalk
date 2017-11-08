//
//  QTTabBarController.m
//  QuickTalk
//
//  Created by  Ruibin.Chow on 2017/11/1.
//  Copyright © 2017年 www.creactism.com. All rights reserved.
//

#import "QTTabBarController.h"
#import "QTMainViewController.h"
#import "QTCircleController.h"
#import "QTMyController.h"

@interface QTTabBarController () <UITabBarControllerDelegate>

- (NSDictionary*)tabBarItemInfo;
- (void)setTabBarItemAppearance;

@end

@implementation QTTabBarController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.delegate = self;
    
    QTMainViewController *mainController = [[QTMainViewController alloc] init];
    QTNavigationController *mainNav = [[QTNavigationController alloc] initWithRootViewController:mainController];
    
    QTCircleController *circleController = [[QTCircleController alloc] init];
    QTNavigationController *circleNav = [[QTNavigationController alloc] initWithRootViewController:circleController];
    
    QTMyController *myController = [[QTMyController alloc] init];
    QTNavigationController *myNav = [[QTNavigationController alloc] initWithRootViewController:myController];
    
    self.viewControllers = @[mainNav, circleNav, myNav];
    [self setTabBarItemAppearance];
    
//    if ([[QTUserInfo sharedInstance] isLogin] == NO) {
//        self.selectedIndex = 1;
//    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITabBarController

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    NSUInteger index = [tabBarController.viewControllers indexOfObject:viewController];
    if (index == 2) {
        return [[QTUserInfo sharedInstance] checkLoginStatus:viewController];;
    } 
    return YES;
}

#pragma mark - Private

- (NSDictionary*)tabBarItemInfo
{
    NSMutableDictionary *info = [NSMutableDictionary dictionaryWithDictionary:
                                 @{
                                   @"tab0":@{
                                           @"title":@"快言",
                                           @"titleColor":@"#666666",
                                           @"titleSelectedColor":QuickTalk_MAIN_COLOR_HEX,
                                           @"imageName":@"news_unselect",
                                           @"selectedImageName":@"news_select"
                                           },
                                   @"tab1":@{
                                           @"title":@"圈子",
                                           @"titleColor":@"#666666",
                                           @"titleSelectedColor":QuickTalk_MAIN_COLOR_HEX,
                                           @"imageName":@"circle_unselect",
                                           @"selectedImageName":@"circle_select"
                                           },
                                   @"tab2":@{
                                           @"title":@"我",
                                           @"titleColor":@"#666666",
                                           @"titleSelectedColor":QuickTalk_MAIN_COLOR_HEX,
                                           @"imageName":@"my_unselect",
                                           @"selectedImageName":@"my_select"
                                           }
                                   }];
    return info;
}

- (void)setTabBarItemAppearance
{
    NSInteger idx = 0;
    for (UITabBarItem *item in self.tabBar.items) {
        NSDictionary *itemInfo = [self tabBarItemInfo][[NSString stringWithFormat:@"tab%ld", (long)idx]];
        item.title = itemInfo[@"title"];
        item.image = [[UIImage imageNamed:itemInfo[@"imageName"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        item.selectedImage = [[UIImage imageNamed:itemInfo[@"selectedImageName"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [item setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorFromHexString:itemInfo[@"titleColor"]]} forState:UIControlStateNormal];
        [item setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorFromHexString:itemInfo[@"titleSelectedColor"]]} forState:UIControlStateSelected];
        
        idx++;
    }
}


@end
