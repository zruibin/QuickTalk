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
                                                               initWithImage:[UIImage imageNamed:@"cancel"] style:UIBarButtonItemStylePlain
                                                               target:self action:@selector(actionForBackButton:)];
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
    
    //替换掉leftBarButtonItem
//    if (viewController.navigationItem.leftBarButtonItem== nil && [self.viewControllers count] > 1) {
//        viewController.navigationItem.leftBarButtonItem = [self customLeftBackButton];
//    }
}

#pragma mark - 自定义返回按钮图片
-(UIBarButtonItem*)customLeftBackButton
{
    UIImage *image = [UIImage imageNamed:@"left"];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 80, 44);
    [backButton setImage:image forState:UIControlStateNormal];
    [backButton setImage:[image imageWithTintColor:QuickTalk_MAIN_COLOR] forState:UIControlStateHighlighted];
    backButton.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;
    [backButton addTarget:self action:@selector(popself) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    return backItem;
}

#pragma mark - 返回按钮事件(pop)
-(void)popself
{
    [self popViewControllerAnimated:YES];
}


@end
