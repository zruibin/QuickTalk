//
//  QTServiceCode.m
//  QuickTalk
//
//  Created by  Ruibin.Chow on 2017/9/4.
//  Copyright © 2017年 www.creactism.com. All rights reserved.
//

#import "QTServiceCode.h"

const NSUInteger CODE_SUCCESS = 10000;
NSString * const ERROR_CODE = @"ERROR_CODE";
NSString * const ERROR_MESSAGE = @"ERROR_MESSAGE";

static NSDictionary *messageDict = nil;

@implementation QTServiceCode

//+ (NSString *)message:(NSUInteger)code
//{
//    if (messageDict == nil) {
//        NSString *path = [[NSBundle mainBundle] pathForResource:@"code" ofType:@"json"];
//        NSData *jsonData = [NSData dataWithContentsOfFile:path];
//
//        messageDict = [NSJSONSerialization JSONObjectWithData:jsonData
//                                                      options:NSJSONReadingMutableContainers
//                                                        error:nil];
//    }
//    return [messageDict objectForKey:[NSString stringWithFormat:@"%lu", (unsigned long)code]];
//}

//+ (NSError *)error:(NSUInteger)code
//{
//    return [NSError errorWithDomain:ERROR_MESSAGE code:code userInfo:@{ERROR_MESSAGE: [self message:code]}];
//}

+ (NSError *)error:(NSUInteger)code message:(NSString *)message
{
    return [NSError errorWithDomain:ERROR_MESSAGE code:code
                           userInfo:@{ERROR_MESSAGE: message, ERROR_CODE: [NSNumber numberWithInteger:code]}];
}

@end
