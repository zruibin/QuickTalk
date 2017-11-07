//
//  QTCircleCell.h
//  QuickTalk
//
//  Created by  Ruibin.Chow on 2017/11/7.
//  Copyright © 2017年 www.creactism.com. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface QTCircleCell : UITableViewCell

@property (nonatomic, copy) void (^onDidTouchActionHandler)(NSInteger index);

- (void)loadData:(NSString *)detail avatar:(NSString *)avatar time:(NSString *)time likeNum:(NSInteger)likeNum;

- (CGFloat)heightForCell:(NSString *)detail;

@end



