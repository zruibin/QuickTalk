//
//  NSString+QuickTalk.m
//  QuickTalk
//
//  Created by  Ruibin.Chow on 2017/10/27.
//  Copyright © 2017年 www.creactism.com. All rights reserved.
//

#import "NSString+QuickTalk.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (QuickTalk)

- (NSString *)md5
{
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, strlen(cStr), result );
    return [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ]; /*32位小写*/
}

#pragma mark - 中英混合长度检测

- (NSInteger)getStringLenthOfBytes
{
    NSInteger length = 0;
    for (int i = 0; i<[self length]; i++) {
        //截取字符串中的每一个字符
        NSString *s = [self substringWithRange:NSMakeRange(i, 1)];
        if ([self validateChineseChar:s]) {
            //            DLog(@" s 打印信息:%@",s);
            length +=2;
        }else{
            length +=1;
        }
        //        DLog(@" 打印信息:%@  %ld",s,(long)length);
    }
    return length;
}

- (NSString *)subBytesOfstringToIndex:(NSInteger)index
{
    NSInteger length = 0;
    NSInteger chineseNum = 0;
    NSInteger zifuNum = 0;
    
    for (int i = 0; i<[self length]; i++) {
        //截取字符串中的每一个字符
        NSString *s = [self substringWithRange:NSMakeRange(i, 1)];
        if ([self validateChineseChar:s]) {
            if (length + 2 > index) {
                return [self substringToIndex:chineseNum + zifuNum];
            }
            
            length +=2;
            chineseNum +=1;
        }
        else {
            if (length +1 >index) {
                return [self substringToIndex:chineseNum + zifuNum];
            }
            length+=1;
            zifuNum +=1;
        }
    }
    return [self substringToIndex:index];
}

//检测中文或者中文符号
- (BOOL)validateChineseChar:(NSString *)string
{
    NSString *nameRegEx = @"[\\u0391-\\uFFE5]";
    if (![string isMatchesRegularExp:nameRegEx]) {
        return NO;
    }
    return YES;
}

//检测中文
- (BOOL)validateChinese:(NSString*)string
{
    NSString *nameRegEx = @"[\u4e00-\u9fa5]";
    if (![string isMatchesRegularExp:nameRegEx]) {
        return NO;
    }
    return YES;
}

- (BOOL)isMatchesRegularExp:(NSString *)regex
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:self];
}

@end
