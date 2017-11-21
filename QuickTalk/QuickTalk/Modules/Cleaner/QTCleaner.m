//
//  QTCleaner.m
//  QuickTalk
//
//  Created by  Ruibin.Chow on 2017/11/21.
//  Copyright © 2017年 www.creactism.com. All rights reserved.
//

#import "QTCleaner.h"

@interface QTCleaner ()

- (void)cleanUpPath:(NSString *)path;

@end

@implementation QTCleaner

+ (instancetype)sharedInstance
{
    static QTCleaner *cleaner = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (cleaner == nil) {
            cleaner = [[super allocWithZone:NULL] init];
        }
    });
    return cleaner;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    return [QTCleaner sharedInstance];
}

- (instancetype)copyWithZone:(struct _NSZone *)zone
{
    return [QTCleaner sharedInstance];
}

- (void)cleanUpPath:(NSString *)path
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:path error:NULL];
    NSEnumerator *e = [contents objectEnumerator];
    NSString *filename;
    while ((filename = [e nextObject])) {
        [fileManager removeItemAtPath:[path stringByAppendingPathComponent:filename] error:NULL];
    }
}

#pragma mark - Public

- (void)checkingCache
{
    unsigned long long size = [IFLY_PATH fileSize];
    if (size > 1000 * 1000 * 200) {
        [self asynchronousCleanUpCache:IFLY_PATH];
    }
}

- (void)asynchronousCleanUpCache:(NSString *)path
{
    [[RBScheduler sharedInstance] runTask:^{
        [self cleanUpPath:path];
    }];
}


@end
