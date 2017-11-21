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

/**
 * @brief  去掉字符串NSString中的html标签 “<>”
 *
 * @param html 要修改的nsstring
 * @param trim 是否要将nsstring 中开始的空白用@“”替换,yes会替换，no不会替换
 *
 * @return  nsstring 去掉html标签后的nsstring
 */
+ (NSString *)flattenHTML:(NSString *)html trimWhiteSpace:(BOOL)trim;

+ (NSString *)documentForPath:(NSString *)path;

/*文件或文件夹大小*/
- (NSString *)fileSizeString;
- (unsigned long long)fileSize;

@end
