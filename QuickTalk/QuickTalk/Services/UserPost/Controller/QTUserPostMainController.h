//
//  QTUserPostMainController.h
//  QuickTalk
//
//  Created by  Ruibin.Chow on 2017/12/5.
//  Copyright © 2017年 www.creactism.com. All rights reserved.
//

#import "QTViewController.h"

@interface QTUserPostMainController : QTViewController

@property (nonatomic, copy) NSString *userUUID;
@property (nonatomic, copy) void (^onScrollingHandler)(CGFloat offsetY);
@property (nonatomic, assign) BOOL showHeader;

@end
