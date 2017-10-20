//
//  QTNavigationController.m
//  QuickTalk
//
//  Created by  Ruibin.Chow on 2017/9/4.
//  Copyright © 2017年 www.creactism.com. All rights reserved.
//

#import "QTNavigationController.h"

@interface QTNavigationController ()

@end

@implementation QTNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBar.tintColor = [UIColor blackColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.presentingViewController) {
        if (self.viewControllers.count > 0) {
            UIViewController *rootController = [self.viewControllers objectAtIndex:0];
            rootController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
                                                               initWithTitle:@"取消"
                                                               style:UIBarButtonItemStylePlain target:self action:@selector(actionForBackButton:)];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)actionForBackButton:(UIButton*)button
{
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.childViewControllers.count >= 1) {
        viewController.hidesBottomBarWhenPushed = YES; //viewController是将要被push的控制器
    }
    [super pushViewController:viewController animated:animated];
}


@end
