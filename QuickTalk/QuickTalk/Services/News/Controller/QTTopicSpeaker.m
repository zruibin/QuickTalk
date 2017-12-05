//
//  QTTopicSpeaker.m
//  QuickTalk
//
//  Created by  Ruibin.Chow on 2017/11/21.
//  Copyright © 2017年 www.creactism.com. All rights reserved.
//

#import "QTTopicSpeaker.h"
#import "QTTopicModel.h"

@interface QTTopicSpeaker ()

@property (nonatomic, strong, readwrite) QTSpeaker *speaker;
@property (nonatomic, copy, readwrite) NSString *content;
@property (nonatomic, assign, readwrite) BOOL speaking;

- (void)startSpeaking:(NSString *)content;

@end

@implementation QTTopicSpeaker

+ (instancetype)sharedInstance
{
    static QTTopicSpeaker *topicSpeaker = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (topicSpeaker == nil) {
            topicSpeaker = [[super allocWithZone:NULL] init];
        }
    });
    return topicSpeaker;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    return [QTTopicSpeaker sharedInstance];
}

- (instancetype)copyWithZone:(struct _NSZone *)zone
{
    return [QTTopicSpeaker sharedInstance];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _speaker = [QTSpeaker sharedInstance];
    }
    return self;
}

- (void)speakingForRequest:(NSString *)uuid view:(UIView *)view completionHandler:(void (^)(BOOL action, NSError * error))completionHandler
{
    if (uuid.length == 0) {
        return ;
    }
    YYCache *cache = [YYCache cacheWithName:QTDataCache];
    NSString *key = [NSString stringWithFormat:@"content_%@", uuid];
    if ([cache containsObjectForKey:key] == NO) {
        [QTProgressHUD showHUD:view];
        [QTTopicModel requestTopicContent:uuid completionHandler:^(NSString *content, NSError *error) {
            if (error) {
                if (completionHandler) {
                    completionHandler(NO, error);
                }
                [QTProgressHUD showHUDWithText:error.userInfo[ERROR_MESSAGE]];
            } else {
                [QTProgressHUD hide];
                [cache setObject:content forKey:key];
                [self speakingForContent:content];
                if (completionHandler) {
                    completionHandler(YES, error);
                }
            }
        }];
    } else {
        NSString *content = (NSString *)[cache objectForKey:key];
        [self speakingForContent:content];
        if (completionHandler) {
            completionHandler(YES, nil);
        }
    }
}

- (void)speakingForContent:(NSString *)content
{
    if (content.length == 0) {
        return;
    }
    [self startSpeaking:content];
}

- (void)pauseSpeaking
{
    [self.speaker pauseSpeaking];
    self.speaking = YES;
}

- (void)resumeSpeaking
{
    [self.speaker resumeSpeaking];
}

#pragma mark - Private

- (void)startSpeaking:(NSString *)content
{
    self.speaker.name = self.name;
    self.speaker.content = [NSString flattenHTML:content trimWhiteSpace:NO];
    [self.speaker startSpeaking];
    __weak typeof(self) weakSelf = self;
    [self.speaker setOnFinishBlock:^{
        weakSelf.speaking = NO;
        weakSelf.name = nil;
        weakSelf.title = nil;
        weakSelf.content = nil;
    }];
}

- (void)stopSpeaking
{
    [self.speaker stopSpeaking];
    self.speaking = NO;
}

@end
