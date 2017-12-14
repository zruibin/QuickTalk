//
//  QTUserPostMainCell.h
//  QuickTalk
//
//  Created by  Ruibin.Chow on 2017/12/5.
//  Copyright © 2017年 www.creactism.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QTUserPostModel;

@interface QTUserPostMainCell : UITableViewCell

@property (nonatomic, copy) void (^onHrefHandler)(NSInteger index);
@property (nonatomic, copy) void (^onArrowHandler)(NSInteger index);
@property (nonatomic, copy) void (^onInfoHandler)(NSInteger index);

- (void)loadData:(QTUserPostModel *)model;

- (CGFloat)heightForCell:(QTUserPostModel *)model;

@end
