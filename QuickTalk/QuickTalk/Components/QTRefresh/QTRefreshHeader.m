//
//  QTRefreshHeader.m
//  QuickTalk
//
//  Created by  Ruibin.Chow on 2017/9/8.
//  Copyright © 2017年 www.creactism.com. All rights reserved.
//

#import "QTRefreshHeader.h"

@implementation QTRefreshHeader

+ (MJRefreshHeader *)headerWithRefreshingBlock:(void (^)(void))refreshingBlock
{
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:refreshingBlock];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    header.automaticallyChangeAlpha = YES;
    
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    
    // 隐藏状态
    header.stateLabel.hidden = YES;
    
    return header;
}

@end
