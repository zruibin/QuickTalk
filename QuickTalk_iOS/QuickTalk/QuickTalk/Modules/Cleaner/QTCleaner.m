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

- (NSUInteger)cacheSize
{
    NSUInteger iFlySize = [IFLY_PATH fileSize];
    NSUInteger imageCacheSize = [[SDImageCache sharedImageCache] getSize];
    NSUInteger size = iFlySize + imageCacheSize;
    return size;
}

- (NSString *)cacheSizeString
{
    return [Tools fileSizeToString:[self cacheSize]];
}

- (void)checkingCache
{
    NSUInteger size = [self cacheSize];
    if (size > 1000 * 1000 * 200) {
        [self asynchronousCleanUpCache];
    }
}

- (void)asynchronousCleanUpCache
{
    [[RBScheduler sharedInstance] dispatchTask:^{
        YYCache *cache = [YYCache cacheWithName:QTDataCache];
        [cache removeAllObjects];
        [self cleanUpPath:IFLY_PATH];
        [[SDImageCache sharedImageCache] clearDiskOnCompletion:nil];
    }];
}


@end
