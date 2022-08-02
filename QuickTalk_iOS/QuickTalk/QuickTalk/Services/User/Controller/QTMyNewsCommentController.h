//
//  QTMyNewsCommentController.h
//  QuickTalk
//
//  Created by  Ruibin.Chow on 2017/12/6.
//  Copyright © 2017年 www.creactism.com. All rights reserved.
//

#import "QTViewController.h"

@interface QTMyNewsCommentController : QTViewController

@property (nonatomic, copy) void (^onScrollingHandler)(CGFloat offsetY);

@end
