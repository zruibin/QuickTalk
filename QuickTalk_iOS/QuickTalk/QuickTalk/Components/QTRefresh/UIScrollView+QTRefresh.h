//
//  UIScrollView+QTRefresh.h
//  QuickTalk
//
//  Created by  Ruibin.Chow on 2017/9/8.
//  Copyright © 2017年 www.creactism.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (QTRefresh)

- (void)headerWithRefreshingBlock:(void (^)(void))refreshingBlock;
- (void)beginHeaderRefreshing;
- (void)endHeaderRefreshing;

- (void)footerWithRefreshingBlock:(void (^)(void))refreshingBlock;
- (void)beginFooterRefreshing;
- (void)endFooterRefreshing;
- (void)endRefreshingWithNoMoreData;
- (void)hiddenFooter;
- (void)showFooter;

@end
