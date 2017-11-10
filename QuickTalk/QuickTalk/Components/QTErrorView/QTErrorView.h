//
//  QTErrorView.h
//  QuickTalk
//
//  Created by  Ruibin.Chow on 2017/11/10.
//  Copyright © 2017年 www.creactism.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QTErrorView : UIView

@property (nonatomic, copy) void (^onRefreshHandler)(void);

@end
