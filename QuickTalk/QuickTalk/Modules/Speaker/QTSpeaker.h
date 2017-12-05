//
//  QTSpeaker.h
//  QuickTalk
//
//  Created by  Ruibin.Chow on 2017/11/20.
//  Copyright © 2017年 www.creactism.com. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, QTSpeakerStatus) {
    QTSpeakerNone,
    QTSpeakerStarting,
    QTSpeakerPause,
    QTSpeakerStop,
    QTSpeakerDestory
};

@interface QTSpeaker : NSObject

@property (nonatomic, copy) NSString *name; //must
@property (nonatomic, copy) NSString *content; //must
@property (nonatomic, assign, readonly) QTSpeakerStatus status;
@property (nonatomic, copy) void (^onErrorHandler)(NSInteger code, NSString *msg);
@property (nonatomic, copy) void (^onFinishBlock)(void);

+ (instancetype)sharedInstance;

- (void)startSpeaking;
- (void)pauseSpeaking;
- (void)resumeSpeaking;
- (void)stopSpeaking;
- (void)destory;

@end
