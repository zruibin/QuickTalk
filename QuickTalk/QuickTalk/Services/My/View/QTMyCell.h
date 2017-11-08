//
//  QTMyCell.h
//  QuickTalk
//
//  Created by  Ruibin.Chow on 2017/11/8.
//  Copyright © 2017年 www.creactism.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QTMyCell : UITableViewCell

- (void)loadData:(NSString *)detail avatar:(NSString *)avatar time:(NSString *)time
         likeNum:(NSInteger)likeNum title:(NSString *)title;

- (CGFloat)heightForCell:(NSString *)detail;

@end
