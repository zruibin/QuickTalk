//
//  QTAvatarEditController.h
//  QuickTalk
//
//  Created by  Ruibin.Chow on 2017/11/1.
//  Copyright © 2017年 www.creactism.com. All rights reserved.
//

#import "QTViewController.h"

@interface QTAvatarEditController : QTViewController

@property (nonatomic, copy) void (^onAvatarChangeHandler)(void);

@end
