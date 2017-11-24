//
//  QTSpeaker.m
//  QuickTalk
//
//  Created by  Ruibin.Chow on 2017/11/20.
//  Copyright © 2017年 www.creactism.com. All rights reserved.
//

#import "QTSpeaker.h"

static const NSInteger numberOfWords = 4000;

@interface QTSpeaker () <IFlySpeechSynthesizerDelegate>

@property (nonatomic, strong) IFlySpeechSynthesizer *iFlySpeechSynthesizer;
@property (nonatomic, copy) NSArray *contentList;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign, readwrite) QTSpeakerStatus status;

@end

@implementation QTSpeaker

+ (instancetype)sharedInstance
{
    static QTSpeaker *speaker = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (speaker == nil) {
            speaker = [[super allocWithZone:NULL] init];
        }
    });
    return speaker;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    return [QTSpeaker sharedInstance];
}

- (instancetype)copyWithZone:(struct _NSZone *)zone
{
    return [QTSpeaker sharedInstance];
}

#pragma mark - Public

- (void)destory
{
    if (_iFlySpeechSynthesizer) {
        [_iFlySpeechSynthesizer stopSpeaking];
    }
    [IFlySpeechSynthesizer destroy];
    self.status = QTSpeakerDestory;
}

- (void)startSpeaking
{
    [self stopSpeaking];
//    DLog(@"content:%@", self.content);
    if (self.contentList.count == 0 || self.name.length == 0) {
        return ;
    }
    self.status = QTSpeakerStarting;
    NSString *text = [self.contentList objectAtIndex:self.index];
    //获取语音合成单例
    _iFlySpeechSynthesizer = [IFlySpeechSynthesizer sharedInstance];
    //设置协议委托对象
    _iFlySpeechSynthesizer.delegate = self;
    //设置合成参数
    //设置在线工作方式
    [_iFlySpeechSynthesizer setParameter:[IFlySpeechConstant TYPE_CLOUD]
                                  forKey:[IFlySpeechConstant ENGINE_TYPE]];
    //设置音量，取值范围 0~100
    [_iFlySpeechSynthesizer setParameter:@"50"
                                  forKey: [IFlySpeechConstant VOLUME]];
    [_iFlySpeechSynthesizer setParameter:@"60"
                                  forKey: [IFlySpeechConstant PITCH]];
    [_iFlySpeechSynthesizer setParameter:@"55"
                                  forKey: [IFlySpeechConstant SPEED]];
    //发音人，默认为”xiaoyan”，可以设置的参数列表可参考“合成发音人列表”
    [_iFlySpeechSynthesizer setParameter:@"vixf"
                                  forKey: [IFlySpeechConstant VOICE_NAME]];
    //保存合成文件名，如不再需要，设置为nil或者为空表示取消，默认目录位于library/cache下
    [_iFlySpeechSynthesizer setParameter:[NSString stringWithFormat:@"%@.pcm", self.name]
                                  forKey: [IFlySpeechConstant TTS_AUDIO_PATH]];
    //启动合成会话
    [_iFlySpeechSynthesizer startSpeaking:text];
}

- (void)pauseSpeaking
{
    [self.iFlySpeechSynthesizer pauseSpeaking];
    self.status = QTSpeakerPause;
}

- (void)resumeSpeaking
{
    [self.iFlySpeechSynthesizer resumeSpeaking];
    self.status = QTSpeakerStarting;
}

- (void)stopSpeaking
{
    [self.iFlySpeechSynthesizer stopSpeaking];
    self.status = QTSpeakerStop;
}

#pragma mark - IFlySpeechSynthesizerDelegate

//合成结束
- (void)onCompleted:(IFlySpeechError *)error
{
    DLog(@"errorDesc:%@", [error errorDesc]);
    DLog(@"errorCode:%d", [error errorCode]);
    if (self.onErrorHandler) {
        self.onErrorHandler(error.errorCode, error.errorDesc);
    }
}

//合成开始
- (void)onSpeakBegin {}

//合成缓冲进度
- (void)onBufferProgress:(int) progress message:(NSString *)msg {}

//合成播放进度
- (void)onSpeakProgress:(int) progress beginPos:(int)beginPos endPos:(int)endPos
{
//    DLog(@"progress:%d", progress);
    if (progress == 100 && self.contentList.count > 1) {
        ++self.index;
        [self startSpeaking];
    }
}

#pragma mark - setter and getter

- (void)setContent:(NSString *)content
{
    _content = [content stringByReplacingOccurrencesOfString:@" " withString:@""];
    _content = [_content stringByReplacingOccurrencesOfString:@"\n" withString:@""];;
    
    NSMutableArray *array = [NSMutableArray array];
    if (_content.length <= numberOfWords) {
        [array addObject:_content];
    } else {
        NSInteger length = _content.length;
        NSInteger count = length / numberOfWords + 1;
        for (NSInteger i=0; i<count; ++i) {
            NSRange range = NSMakeRange(i*numberOfWords, numberOfWords);
            if (i == count-1) {
                range = NSMakeRange(i*numberOfWords, length-i*numberOfWords);
            }
            NSString *str = [_content substringWithRange:range];
            [array addObject:str];
        }
    }
    self.contentList = [array copy];
}

@end
