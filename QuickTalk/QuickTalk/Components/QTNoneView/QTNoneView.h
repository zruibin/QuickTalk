//
//  QTNoneView.h
//  QuickTalk
//
//  Created by  Ruibin.Chow on 2017/11/10.
//  Copyright © 2017年 www.creactism.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QTNoneView : UIView

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) void (^onRefreshHandler)(void);

@end
