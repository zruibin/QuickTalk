//
//  QTUserLikeListController.h
//  QuickTalk
//
//  Created by  Ruibin.Chow on 2017/12/22.
//  Copyright © 2017年 www.creactism.com. All rights reserved.
//

#import "QTViewController.h"

@interface QTUserLikeListController : QTViewController

@property (nonatomic, copy) NSString *userUUID;
@property (nonatomic, copy) void (^onScrollingHandler)(CGFloat offsetY);

@end
