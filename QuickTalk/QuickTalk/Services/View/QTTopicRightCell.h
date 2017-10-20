//
//  QTTopicRightCell.h
//  QuickTalk
//
//  Created by  Ruibin.Chow on 2017/10/19.
//  Copyright © 2017年 www.creactism.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QTTopicRightCell : UITableViewCell

- (void)loadData:(NSString *)detail avatar:(NSString *)avatar;
- (CGFloat)heightForCell:(NSString *)detail;

@end
