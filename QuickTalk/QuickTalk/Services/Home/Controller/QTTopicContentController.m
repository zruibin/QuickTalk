//
//  QTTopicContentController.m
//  QuickTalk
//
//  Created by  Ruibin.Chow on 2017/11/9.
//  Copyright © 2017年 www.creactism.com. All rights reserved.
//

#import "QTTopicContentController.h"
#import "QTTopicModel.h"
#import "RBImagebrowse.h"
#import "QTTopicSpeaker.h"

@interface QTTopicContentController () <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) QTErrorView *errorView;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, strong) QTTopicSpeaker *topicSpeaker;
@property (nonatomic, strong) UIButton *playButton;

- (void)initViews;
- (void)loadData;

@end

@implementation QTTopicContentController

- (void)dealloc
{
//    [_topicSpeaker destory];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.topicSpeaker = [QTTopicSpeaker sharedInstance];
    [self initViews];
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initViews
{
    self.title = @"阅读新闻";
    
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.view addSubview:self.errorView];
    self.errorView.hidden = YES;
    
    self.playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.playButton.frame = CGRectMake(0, 0, 40, 40);
    [self.playButton setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    [self.playButton addTarget:self action:@selector(sayingAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:self.playButton];
    self.navigationItem.rightBarButtonItem = item;
    if ([self.topicSpeaker.name isEqualToString:self.model.uuid]) {
        if (self.topicSpeaker.speaker.status == QTSpeakerPause) {
            [self.playButton setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
        } else {
            [self.playButton setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
        }
    }
}

- (void)loadData
{
    NSString *style = @"<style>*{font-size:50px; padding: 5px 10px; line-height:80px; margin: 0px;} img{width:98%; padding: 5px 10px; margin: 0px;} hr {border: 0;border-top: 1px solid #eee;} a {color: #999999; font-size: 40px;} a:link, a:visited, a:active{text-decoration:none;} a:hover{text-decoration:underline;} h1{font-size:60px;}</style>";
    
    [QTProgressHUD showHUD:self.view];
    [QTTopicModel requestTopicContent:self.model.uuid completionHandler:^(NSString *content, NSError *error) {
        if (error) {
            [QTProgressHUD showHUDWithText:error.userInfo[ERROR_MESSAGE]];
            self.errorView.hidden = NO;
        } else {
            [QTProgressHUD hide];
            self.errorView.hidden = YES;
            if (content.length > 0) {
                
                if ([[QTUserInfo sharedInstance] hiddenOneClickLogin] == NO) {
                    NSRange range = [content rangeOfString:@"新闻来源：<strong>"];
                    if (range.location != NSNotFound) {
                        content = [content substringToIndex:range.location];
                    }
                }
                self.content = content;
                [self.webView loadHTMLString:[style stringByAppendingString:content] baseURL:nil];
                
                NSString *path = [[NSBundle mainBundle] pathForResource:@"image" ofType:@"js"];
                NSString *jsString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
                [self.webView stringByEvaluatingJavaScriptFromString:jsString];
            }
        }
    }];
}

- (void)sayingAction
{
    if ([self.topicSpeaker.name isEqualToString:self.model.uuid]) {
        if (self.topicSpeaker.speaker.status == QTSpeakerNone ||
            self.topicSpeaker.speaker.status == QTSpeakerDestory) {
            self.topicSpeaker.name = self.model.uuid;
            self.topicSpeaker.title = self.model.title;
            [self.topicSpeaker speakingForContent:self.content];
            [self.playButton setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
        } else {
            if (self.topicSpeaker.speaker.status == QTSpeakerPause) {
                [self.playButton setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
                [self.topicSpeaker resumeSpeaking];
            } else {
                [self.playButton setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
                [self.topicSpeaker pauseSpeaking];
            }
        }
    } else {
        self.topicSpeaker.name = self.model.uuid;
        self.topicSpeaker.title = self.model.title;
        [self.topicSpeaker speakingForContent:self.content];
        [self.playButton setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
    }
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request
    navigationType:(UIWebViewNavigationType)navigationType
{
    NSURL *requestURL = request.URL;
    if (([[requestURL scheme] isEqualToString: @"http"]
         || [[requestURL scheme] isEqualToString: @"https"])
        && (navigationType == UIWebViewNavigationTypeLinkClicked)) {
        SFSafariViewController *safariController = [[SFSafariViewController alloc] initWithURL:requestURL];
        [self presentViewController:safariController animated:YES completion:nil];
        return NO;
    }
    if ([[requestURL scheme] isEqualToString: @"image"]
        || [[requestURL scheme] isEqualToString: @"images"]) {
        NSString *path = requestURL.absoluteString;
//        DLog(@"path:%@", path);
        if ([path rangeOfString:@"image://"].location == NSNotFound) {
            path = [path stringByReplacingOccurrencesOfString:@"images://" withString:@"https://"];
        } else {
            path = [path stringByReplacingOccurrencesOfString:@"image://" withString:@"http://"];
        }
//        DLog(@"path:%@", path);
        RBImagebrowse *browse = [RBImagebrowse createBrowseWithImages:@[path]];
        browse.showIndex = NO;
        [browse show];
        return NO;
    }
    
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView*)webView
{
    [webView stringByEvaluatingJavaScriptFromString:@"setImageClickFunction()"];
}

#pragma mark - setter and getter

- (UIWebView *)webView
{
    if (_webView == nil) {
        _webView = ({
            UIWebView *webView = [[UIWebView alloc] init];
            webView.scalesPageToFit = YES;//自动对页面进行缩放以适应屏幕
//            webView.detectsPhoneNumbers = YES;//自动检测网页上的电话号码，单击可以拨打
            webView.delegate = self;
            webView;
        });
    }
    return _webView;
}

- (QTErrorView *)errorView
{
    if (_errorView == nil) {
        _errorView = ({
            QTErrorView *view = [[QTErrorView alloc] initWithFrame:self.view.bounds];
            __weak typeof(self) weakSelf = self;
            [view setOnRefreshHandler:^{
                [weakSelf loadData];
            }];
            view;
        });
    }
    return _errorView;
}

@end
