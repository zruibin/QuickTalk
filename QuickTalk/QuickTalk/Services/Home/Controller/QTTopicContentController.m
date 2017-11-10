//
//  QTTopicContentController.m
//  QuickTalk
//
//  Created by  Ruibin.Chow on 2017/11/9.
//  Copyright © 2017年 www.creactism.com. All rights reserved.
//

#import "QTTopicContentController.h"
#import "QTTopicModel.h"

@interface QTTopicContentController () <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) QTErrorView *errorView;

- (void)initViews;
- (void)loadData;

@end

@implementation QTTopicContentController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
                [self.webView loadHTMLString:[style stringByAppendingString:content] baseURL:nil];
            }
        }
    }];
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
    return YES;
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
