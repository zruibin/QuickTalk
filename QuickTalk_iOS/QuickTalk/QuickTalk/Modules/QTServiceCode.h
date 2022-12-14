//
//  QTServiceCode.h
//  QuickTalk
//
//  Created by  Ruibin.Chow on 2017/9/4.
//  Copyright © 2017年 www.creactism.com. All rights reserved.
//

#import <Foundation/Foundation.h>

extern const NSUInteger CODE_SUCCESS;
extern NSString * const ERROR_CODE;
extern NSString * const ERROR_MESSAGE;

@interface QTServiceCode : NSObject

+ (NSError *)error:(NSUInteger)code message:(NSString *)message;

@end
