//
//  QTUserPostLikeView.h
//  QuickTalk
//
//  Created by  Ruibin.Chow on 2017/12/22.
//  Copyright © 2017年 www.creactism.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QTUserPostLikeModel;

@interface QTUserPostLikeView : UIView

@property (nonatomic, copy) NSArray<QTUserPostLikeModel *> *likeList; /*must*/
@property (nonatomic, copy) void (^onIconTouchHandler)(NSInteger index);

- (CGFloat)generateHeight:(NSArray<QTUserPostLikeModel *> *)likeList;

@end
