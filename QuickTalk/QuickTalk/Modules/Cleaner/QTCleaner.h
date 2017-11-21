//
//  QTCleaner.h
//  QuickTalk
//
//  Created by  Ruibin.Chow on 2017/11/21.
//  Copyright © 2017年 www.creactism.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QTCleaner : NSObject

+ (instancetype)sharedInstance;

- (void)checkingCache;
- (void)asynchronousCleanUpCache:(NSString *)path;

@end
