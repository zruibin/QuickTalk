//
//  QTTopicSpeaker.h
//  QuickTalk
//
//  Created by  Ruibin.Chow on 2017/11/21.
//  Copyright © 2017年 www.creactism.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QTSpeaker.h"

@interface QTTopicSpeaker : NSObject

@property (nonatomic, strong, readonly) QTSpeaker *speaker;
@property (nonatomic, copy) NSString *name; //must
@property (nonatomic, copy) NSString *title; //must
@property (nonatomic, copy, readonly) NSString *content;
@property (nonatomic, assign, readonly) BOOL speaking;
@property (nonatomic, copy) void (^onFinishBlock)(void);

+ (instancetype)sharedInstance;

- (void)speakingForRequest:(NSString *)uuid view:(UIView *)view
       completionHandler:(void (^)(BOOL action, NSError * error))completionHandler;
- (void)speakingForRequest:(NSString *)uuid
         completionHandler:(void (^)(BOOL action, NSError * error))completionHandler;
- (void)speakingForContent:(NSString *)content;

- (void)pauseSpeaking;
- (void)resumeSpeaking;
- (void)stopSpeaking;
- (void)clearSpeaking;

@end
