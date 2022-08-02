//
//  QTRefreshFooter.h
//  QuickTalk
//
//  Created by  Ruibin.Chow on 2017/9/11.
//  Copyright © 2017年 www.creactism.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QTRefreshFooter : NSObject

+ (MJRefreshAutoNormalFooter *)footerWithRefreshingBlock:(void (^)(void))refreshingBlock;

@end
