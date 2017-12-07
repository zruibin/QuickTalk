//
//  QTTopicGlobalSpeaker.h
//  QuickTalk
//
//  Created by  Ruibin.Chow on 2017/12/7.
//  Copyright © 2017年 www.creactism.com. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, QTGlobalSpeakerStatus) {
    QTGlobalSpeakerNone,
    QTGlobalSpeakerStarting,
    QTGlobalSpeakerPause
};

@interface QTTopicGlobalSpeaker : NSObject

@property (nonatomic, assign, readonly) QTGlobalSpeakerStatus status;
@property (nonatomic, assign, readonly) BOOL speaking;

+ (instancetype)sharedInstance;

- (void)startSpeaking;
- (void)pauseSpeaking;
- (void)resumeSpeaking;
- (void)clearSpeaking;

@end
