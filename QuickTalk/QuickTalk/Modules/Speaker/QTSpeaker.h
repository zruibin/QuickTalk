//
//  QTSpeaker.h
//  QuickTalk
//
//  Created by  Ruibin.Chow on 2017/11/20.
//  Copyright © 2017年 www.creactism.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QTSpeaker : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *content;

+ (instancetype)sharedInstance;

- (void)startSpeaking;
- (void)pauseSpeaking;
- (void)resumeSpeaking;
- (void)stopSpeaking;
- (void)destory;

@end
