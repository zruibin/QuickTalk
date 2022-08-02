//
//  QTMessageCell.h
//  QuickTalk
//
//  Created by  Ruibin.Chow on 2017/12/25.
//  Copyright © 2017年 www.creactism.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, QTMessageType) {
    QTMessageDefault = 0,
    QTMessageUserPostLike = 2,
    QTMessageUserPostComment = 4,
    QTMessageUserStar = 6,
};

@class QTMessageModel;

@interface QTMessageCell : UITableViewCell

@property (nonatomic, copy) void (^onHrefHandler)(NSInteger index);
@property (nonatomic, copy) void (^onInfoHandler)(NSInteger index);

- (void)loadData:(QTMessageModel *)model;
- (CGFloat)heightForCell:(QTMessageModel *)model;

@end
