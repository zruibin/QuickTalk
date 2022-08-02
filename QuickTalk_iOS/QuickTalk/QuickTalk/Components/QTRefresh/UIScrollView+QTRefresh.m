//
//  UIScrollView+QTRefresh.m
//  QuickTalk
//
//  Created by  Ruibin.Chow on 2017/9/8.
//  Copyright © 2017年 www.creactism.com. All rights reserved.
//

#import "UIScrollView+QTRefresh.h"
#import "QTRefreshHeader.h"
#import "QTRefreshFooter.h"

@implementation UIScrollView (QTRefresh)

- (void)headerWithRefreshingBlock:(void (^)(void))refreshingBlock
{
    self.mj_header = [QTRefreshHeader headerWithRefreshingBlock:refreshingBlock];
}

- (void)beginHeaderRefreshing
{
    if (self.mj_header) {
        [self.mj_header beginRefreshing];
    }
}

- (void)endHeaderRefreshing
{
    if (self.mj_header) {
        [self.mj_header endRefreshing];
    }
}

- (void)footerWithRefreshingBlock:(void (^)(void))refreshingBlock
{
    self.mj_footer = [QTRefreshFooter footerWithRefreshingBlock:refreshingBlock];
}

- (void)beginFooterRefreshing
{
    if (self.mj_footer) {
        [self.mj_footer beginRefreshing];
    }
}

- (void)endFooterRefreshing
{
    if (self.mj_footer) {
        self.mj_footer.hidden = NO;
        [self.mj_footer endRefreshing];
    }
}

- (void)endRefreshingWithNoMoreData
{
    if (self.mj_footer) {
        self.mj_footer.hidden = NO;
        [self.mj_footer endRefreshingWithNoMoreData];
    }
}

- (void)hiddenFooter
{
    if (self.mj_footer) {
        self.mj_footer.hidden = YES;
    }
}

- (void)showFooter
{
    if (self.mj_footer) {
        self.mj_footer.hidden = NO;
    }
}

@end
