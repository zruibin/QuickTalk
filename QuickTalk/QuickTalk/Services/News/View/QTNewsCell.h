//
//  QTMainCell.h
//  QuickTalk
//
//  Created by  Ruibin.Chow on 2017/11/1.
//  Copyright © 2017年 www.creactism.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QTNewsCell : UITableViewCell

@property (nonatomic, assign) BOOL speaking;
@property (nonatomic, copy) void (^onPlayActionHandler)(NSString *uuid, NSInteger index);

- (void)loadData:(NSString *)text time:(NSString *)time uuid:(NSString *)uuid;
- (CGFloat)heightForCell:(NSString *)text;

@end
