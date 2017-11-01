//
//  QTMainCell.h
//  QuickTalk
//
//  Created by  Ruibin.Chow on 2017/11/1.
//  Copyright © 2017年 www.creactism.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QTMainCell : UITableViewCell

- (void)loadData:(NSString *)text;
- (CGFloat)heightForCell:(NSString *)text;

@end
