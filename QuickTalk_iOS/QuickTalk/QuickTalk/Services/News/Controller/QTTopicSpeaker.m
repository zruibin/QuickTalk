//
//  QTTopicSpeaker.m
//  QuickTalk
//
//  Created by  Ruibin.Chow on 2017/11/21.
//  Copyright © 2017年 www.creactism.com. All rights reserved.
//

#import "QTTopicSpeaker.h"
#import "QTTopicModel.h"
#import "QTTopicGlobalSpeaker.h"

NSString * const QTTopicSpeakerStatusNotification = @"kQTTopicSpeakerStatusNotification";
NSString * const QTTopicSpeakerStopNotification = @"kQTTopicSpeakerStopNotification";

static const NSInteger BUTTON_ACTION_FOR_ACTION_TAG = 101010;
static const NSInteger BUTTON_ACTION_FOR_DELETE_TAG = 101011;

@interface QTTopicSpeaker ()

@property (nonatomic, strong, readwrite) QTSpeaker *speaker;
@property (nonatomic, copy, readwrite) NSString *content;
@property (nonatomic, assign, readwrite) BOOL speaking;

@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) UIButton *actionButton;
@property (nonatomic, strong) UIButton *deleteButton;

- (void)startSpeaking:(NSString *)content;
- (void)stopSpeaking;
- (void)clearSpeaking;
- (void)initViews;
- (void)postStatusNotification;

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
        _speaker = [[QTSpeaker alloc] init];
        _window = [UIApplication sharedApplication].keyWindow;
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

- (void)speakingForRequest:(NSString *)uuid completionHandler:(void (^)(BOOL action, NSError * error))completionHandler
{
    [self speakingForRequest:uuid view:nil completionHandler:completionHandler];
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
    self.speaking = NO;
    [self postStatusNotification];
}

- (void)resumeSpeaking
{
    [self.speaker resumeSpeaking];
    self.speaking = YES;
    [self postStatusNotification];
}

#pragma mark - Private

- (void)startSpeaking:(NSString *)content
{
    [self initViews];
    self.speaking = YES;
    DLog(@"name: %@", self.name);
    self.speaker.name = self.name;
    self.speaker.content = [NSString flattenHTML:content trimWhiteSpace:NO];
    [self.speaker startSpeaking];
    __weak typeof(self) weakSelf = self;
    [self.speaker setOnFinishBlock:^{
        weakSelf.speaking = NO;
        weakSelf.name = nil;
        weakSelf.title = nil;
        weakSelf.content = nil;
        if (weakSelf.onFinishBlock) {
            weakSelf.onFinishBlock();
        }
    }];
}

- (void)stopSpeaking
{
    [self.speaker stopSpeaking];
    self.speaking = NO;
    [self postStatusNotification];
    
    if ( [QTTopicGlobalSpeaker sharedInstance].status != QTGlobalSpeakerNone) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:QTTopicSpeakerStopNotification object:nil];
        });
    }
}

- (void)clearSpeaking
{
    [self deleteButtonAction];
}

- (void)initViews
{
    UIButton *actionButton = (UIButton *)[self.window viewWithTag:BUTTON_ACTION_FOR_ACTION_TAG];
    UIButton *deleteButton = (UIButton *)[self.window viewWithTag:BUTTON_ACTION_FOR_DELETE_TAG];
    if (actionButton == nil && deleteButton == nil) {
        [self.window addSubview:self.deleteButton];
        [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.and.height.mas_equalTo(40);
            make.right.equalTo(self.window).offset(-10);
            make.bottom.equalTo(self.window).offset(-80);
        }];
        [self.window addSubview:self.actionButton];
        [self.actionButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.and.height.and.right.equalTo(self.deleteButton);
            make.bottom.equalTo(self.deleteButton.mas_top).offset(-12);
        }];
    }
}

- (void)postStatusNotification
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:QTTopicSpeakerStatusNotification object:nil];
    });
}

#pragma mark - Action

- (void)actionButtonAction
{
    if (self.speaking) {
        [self pauseSpeaking];
    } else {
        [self resumeSpeaking];
    }
}

- (void)deleteButtonAction
{
    [self.actionButton removeFromSuperview];
    [self.deleteButton removeFromSuperview];
    
    [self stopSpeaking];
}

#pragma mark - setter and getter

- (UIButton *)actionButton
{
    if (_actionButton == nil) {
        _actionButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button addTarget:self action:@selector(actionButtonAction) forControlEvents:UIControlEventTouchUpInside];
            button.tag = BUTTON_ACTION_FOR_ACTION_TAG;
            button.layer.masksToBounds = YES;
            button.layer.cornerRadius = 20;
            [button setBackgroundImage:[UIImage createImageWithColor:[UIColor colorFromHexValue:0x000 withAlpha:.6]]
                              forState:UIControlStateNormal];
            button.imageEdgeInsets = UIEdgeInsetsMake(12, 12, 12, 12);
            button;
        });
    }
    return _actionButton;
}

- (UIButton *)deleteButton
{
    if (_deleteButton == nil) {
        _deleteButton = ({
            UIImage *image = [UIImage imageNamed:@"cancel"];
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setImage:[image imageWithTintColor:[UIColor whiteColor]] forState:UIControlStateNormal];
            [button setImage:[image imageWithTintColor:QuickTalk_MAIN_COLOR] forState:UIControlStateHighlighted];
            [button addTarget:self action:@selector(deleteButtonAction) forControlEvents:UIControlEventTouchUpInside];
            button.tag = BUTTON_ACTION_FOR_DELETE_TAG;
            button.layer.masksToBounds = YES;
            button.layer.cornerRadius = 20;
            [button setBackgroundImage:[UIImage createImageWithColor:[UIColor colorFromHexValue:0xFF0000 withAlpha:.8]]
                              forState:UIControlStateNormal];
            button.imageEdgeInsets = UIEdgeInsetsMake(14, 14, 14, 14);
            button;
        });
    }
    return _deleteButton;
}

- (void)setSpeaking:(BOOL)speaking
{
    _speaking = speaking;
    if (_speaking) {
        [self.actionButton setImage:[[UIImage imageNamed:@"pause"] imageWithTintColor:[UIColor whiteColor]]
                           forState:UIControlStateNormal];
    } else {
        [self.actionButton setImage:[[UIImage imageNamed:@"play"] imageWithTintColor:[UIColor whiteColor]]
                           forState:UIControlStateNormal];
    }
}


@end
