//
//  NSString+QuickTalk.h
//  QuickTalk
//
//  Created by  Ruibin.Chow on 2017/10/27.
//  Copyright © 2017年 www.creactism.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (QuickTalk)

- (NSString *)md5;

/*获得中英混合长度*/
- (NSInteger)getStringLenthOfBytes;

/*截取中英混合字符*/
- (NSString *)subBytesOfstringToIndex:(NSInteger)index;


@end
