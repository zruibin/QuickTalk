//
//  QTRefreshHeader.h
//  QuickTalk
//
//  Created by  Ruibin.Chow on 2017/9/8.
//  Copyright © 2017年 www.creactism.com. All rights reserved.
//

#import <MJRefresh/MJRefresh.h>

@interface QTRefreshHeader : NSObject

+ (MJRefreshHeader *)headerWithRefreshingBlock:(void (^)(void))refreshingBlock;

@end
