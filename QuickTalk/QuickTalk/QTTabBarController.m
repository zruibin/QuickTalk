//
//  QTTabBarController.m
//  QuickTalk
//
//  Created by  Ruibin.Chow on 2017/11/1.
//  Copyright © 2017年 www.creactism.com. All rights reserved.
//

#import "QTTabBarController.h"
#import "QTNewsController.h"
#import "QTUserPostMainController.h"
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
    
    QTNewsController *newsController = [[QTNewsController alloc] init];
    QTNavigationController *newsNav = [[QTNavigationController alloc] initWithRootViewController:newsController];
    
    QTUserPostMainController *userPostController = [[QTUserPostMainController alloc] init];
    userPostController.showHeader = YES;
    QTNavigationController *userPostNav = [[QTNavigationController alloc] initWithRootViewController:userPostController];
    
    QTMyController *myController = [[QTMyController alloc] init];
    QTNavigationController *myNav = [[QTNavigationController alloc] initWithRootViewController:myController];
    
    self.viewControllers = @[userPostNav, newsNav, myNav];
    [self setTabBarItemAppearance];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITabBarController

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
//    NSUInteger index = [tabBarController.viewControllers indexOfObject:viewController];
//    if (index == 2) {
//        return [[QTUserInfo sharedInstance] checkLoginStatus:viewController];;
//    }
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
                                           @"selectedImageName":@"news_unselect"
                                           },
                                   @"tab1":@{
                                           @"title":@"新闻",
                                           @"titleColor":@"#666666",
                                           @"titleSelectedColor":QuickTalk_MAIN_COLOR_HEX,
                                           @"imageName":@"circle_unselect",
                                           @"selectedImageName":@"circle_unselect"
                                           },
                                   @"tab2":@{
                                           @"title":@"我",
                                           @"titleColor":@"#666666",
                                           @"titleSelectedColor":QuickTalk_MAIN_COLOR_HEX,
                                           @"imageName":@"my_unselect",
                                           @"selectedImageName":@"my_unselect"
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
        item.selectedImage = [[[UIImage imageNamed:itemInfo[@"selectedImageName"]] imageWithTintColor:QuickTalk_MAIN_COLOR] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [item setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorFromHexString:itemInfo[@"titleColor"]]} forState:UIControlStateNormal];
        [item setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorFromHexString:itemInfo[@"titleSelectedColor"]]} forState:UIControlStateSelected];
        
        idx++;
    }
}


@end
