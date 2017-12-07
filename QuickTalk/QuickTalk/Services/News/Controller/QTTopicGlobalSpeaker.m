//
//  QTTopicGlobalSpeaker.m
//  QuickTalk
//
//  Created by  Ruibin.Chow on 2017/12/7.
//  Copyright © 2017年 www.creactism.com. All rights reserved.
//

#import "QTTopicGlobalSpeaker.h"
#import "QTTopicSpeaker.h"
#import "QTTopicModel.h"


@interface QTTopicGlobalSpeaker ()

@property (nonatomic, assign, readwrite) QTGlobalSpeakerStatus status;
@property (nonatomic, assign, readwrite) BOOL speaking;
@property (nonatomic, strong) QTTopicSpeaker *topicSpeaker;
@property (nonatomic, assign) NSInteger page; /*数据请求索引*/
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) NSArray *dataList;
@property (nonatomic, strong) UIWindow *window;

- (void)requestTopicDataList;

@end


@implementation QTTopicGlobalSpeaker

- (void)dealloc
{
    _topicSpeaker = nil;
}

+ (instancetype)sharedInstance
{
    static QTTopicGlobalSpeaker *topicGlobalSpeaker = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (topicGlobalSpeaker == nil) {
            topicGlobalSpeaker = [[super allocWithZone:NULL] init];
        }
    });
    return topicGlobalSpeaker;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    return [QTTopicGlobalSpeaker sharedInstance];
}

- (instancetype)copyWithZone:(struct _NSZone *)zone
{
    return [QTTopicGlobalSpeaker sharedInstance];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _topicSpeaker = [[QTTopicSpeaker alloc] init];
        _page = 1;
        _window = [UIApplication sharedApplication].keyWindow;
    }
    return self;
}

#pragma mark - Public

- (void)startSpeaking
{
    [self requestTopicDataList];
    self.status = QTGlobalSpeakerStarting;
}

- (void)pauseSpeaking
{
    [self.topicSpeaker pauseSpeaking];
    self.speaking = NO;
    self.status = QTGlobalSpeakerPause;
}

- (void)resumeSpeaking
{
    [self.topicSpeaker resumeSpeaking];
    self.speaking = YES;
    self.status = QTGlobalSpeakerStarting;
}

- (void)clearSpeaking
{
    [self.topicSpeaker clearSpeaking];
    self.page = 1;
    self.index = 0;
    self.dataList = nil;
    self.speaking = NO;
    self.status = QTGlobalSpeakerNone;
}

#pragma mark - Private

- (void)requestTopicDataList
{
    [QTTopicModel requestTopicData:self.page completionHandler:^(NSArray<QTTopicModel *> *list, NSError *error) {
        if (error) {
            [QTProgressHUD showHUDText:@"播放失败，请稍后再试" view:self.window];
        } else {
            self.dataList = [list copy];
            self.index = 0;
            [self startPlayingInBatches];
            self.speaking = YES;
            self.status = QTGlobalSpeakerStarting;
        }
    }];
}

- (void)startPlayingInBatches
{
    __weak typeof(self) weakSelf = self;
    if (self.dataList && self.dataList.count > 0) {
        QTTopicModel *model = self.dataList[self.index];
        self.topicSpeaker.name = model.uuid;
        self.topicSpeaker.title = model.title;
        [self.topicSpeaker speakingForRequest:model.uuid completionHandler:^(BOOL action, NSError *error) {
            if (error) {
                [QTProgressHUD showHUDText:@"播放失败，请稍后再试" view:self.window];
                [self clearSpeaking];
            }
        }];
        [self.topicSpeaker setOnFinishBlock:^{
            ++weakSelf.index;
            if (weakSelf.index == weakSelf.dataList.count) {
                [weakSelf startSpeaking];
            } else {
                [weakSelf startPlayingInBatches];
            }
        }];
    }
}

@end





