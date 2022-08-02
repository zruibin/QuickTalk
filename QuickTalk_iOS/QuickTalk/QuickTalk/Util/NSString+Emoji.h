//
//  NSString+Emoji.h
//  Creaction
//
//  Created by  Ruibin.Chow on 2017/9/15.
//  Copyright © 2017年 www.creactism.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Emoji)

/*是否含有表情*/
- (BOOL)stringContainsEmoji;

- (NSString *)encodeEmoji;
- (NSString *)decodeEmoji;

@end
