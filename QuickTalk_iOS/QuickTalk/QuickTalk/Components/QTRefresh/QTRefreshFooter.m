//
//  QTRefreshFooter.m
//  QuickTalk
//
//  Created by  Ruibin.Chow on 2017/9/11.
//  Copyright © 2017年 www.creactism.com. All rights reserved.
//

#import "QTRefreshFooter.h"

@implementation QTRefreshFooter

+ (MJRefreshAutoNormalFooter *)footerWithRefreshingBlock:(void (^)(void))refreshingBlock
{
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:refreshingBlock];
    
    // 隐藏时间
    footer.refreshingTitleHidden = YES;
    
    footer.stateLabel.textColor = [UIColor colorFromHexValue:0x999999];
    footer.stateLabel.font = [UIFont systemFontOfSize:12];
    
    [footer setTitle:@"----- End -----" forState:MJRefreshStateNoMoreData];
    
    return footer;
}

@end
