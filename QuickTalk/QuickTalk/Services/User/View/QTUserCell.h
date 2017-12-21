//
//  QTUserCell.h
//  QuickTalk
//
//  Created by  Ruibin.Chow on 2017/12/21.
//  Copyright © 2017年 www.creactism.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, QTViewRelationStatus) {
    QTViewRelationDefault = 0, //未关注
    QTViewRelationStar = 1, //已关注
    QTViewRelationStarAndBeStar = 2, //相互关注
    QTViewRelationHidden
};

@interface QTUserCell : UITableViewCell

@property (nonatomic, assign) QTViewRelationStatus relationStatus;
@property (nonatomic, assign) CGFloat multiplie;
@property (nonatomic, copy) void (^onAvatarHandler)(NSInteger index);
@property (nonatomic, copy) void (^onActionHandler)(NSInteger index);

- (void)loadData:(NSString *)avatar nickname:(NSString *)nickname subname:(NSString *)subname;

@end
