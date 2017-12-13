//
//  QTIntroController.m
//  QuickTalk
//
//  Created by  Ruibin.Chow on 2017/10/27.
//  Copyright © 2017年 www.creactism.com. All rights reserved.
//

#import "QTIntroController.h"
#import <AVFoundation/AVFoundation.h>

@interface QTIntroController ()

@property (nonatomic, strong) UIButton *button;
@property (nonatomic,strong) AVPlayer *player;//播放器对象
@property (nonatomic,strong) UIView *container; //播放器容器

- (void)initViews;

@end

@implementation QTIntroController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initViews];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"video.mp4" ofType:nil];
    NSURL *sourceMovieUrl = [NSURL fileURLWithPath:path];
    AVAsset *movieAsset = [AVURLAsset URLAssetWithURL:sourceMovieUrl options:nil];
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:movieAsset];
    
    self.player = [AVPlayer playerWithPlayerItem:playerItem];
    AVPlayerLayer *playerLayer=[AVPlayerLayer playerLayerWithPlayer:self.player];
    playerLayer.frame = self.container.bounds;
    //playerLayer.videoGravity=AVLayerVideoGravityResizeAspect;//视频填充模式
    [self.container.layer addSublayer:playerLayer];
    [self.player play];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationItem.leftBarButtonItem = nil;
    [UIApplication sharedApplication].statusBarHidden = YES;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [UIApplication sharedApplication].statusBarHidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initViews
{
    self.view.backgroundColor = [UIColor colorFromHexValue:0x000 withAlpha:0.7];
    self.container = [UIView new];
    self.container.frame = CGRectMake(20, 20, CGRectGetWidth(self.view.bounds)-40, CGRectGetHeight(self.view.bounds)-40);
    [self.view addSubview:self.container];
    
    [self.view addSubview:self.button];
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.and.height.mas_equalTo(40);
        make.bottom.equalTo(self.view).offset(-16);
        make.right.equalTo(self.view).offset(-2);
    }];
}

- (void)dismiss
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)playbackFinished:(NSNotification *)notification
{
    DLog(@"视频播放完成.");
    [self dismiss];
}

#pragma mark - setter and getter


- (UIButton *)button
{
    if (_button == nil) {
        _button = ({
            UIImage *image = [UIImage imageNamed:@"cancel"];
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setImage:[image imageWithTintColor:[UIColor whiteColor]] forState:UIControlStateNormal];
            [button setImage:[image imageWithTintColor:QuickTalk_MAIN_COLOR] forState:UIControlStateHighlighted];
            button.layer.masksToBounds = YES;
            button.layer.cornerRadius = 20;
            [button setBackgroundImage:[UIImage createImageWithColor:[UIColor colorFromHexValue:0x000 withAlpha:.9]]
                              forState:UIControlStateNormal];
            button.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
            [button addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
            button;
        });
    }
    return _button;
}


@end
