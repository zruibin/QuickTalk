//
//  QTTopicContentController.m
//  QuickTalk
//
//  Created by  Ruibin.Chow on 2017/11/9.
//  Copyright © 2017年 www.creactism.com. All rights reserved.
//

#import "QTTopicContentController.h"
#import "QTTopicModel.h"

@interface QTTopicContentController ()

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIWebView *webView;

- (void)initViews;
- (void)setContent:(NSString *)text;

@end

@implementation QTTopicContentController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initViews];
    
    NSString *style = @"<style>*{font-size:50px; padding: 5px 10px; line-height:80px;} img{width:100%}</style>";
    
    [QTProgressHUD showHUD:self.view];
    [QTTopicModel requestTopicContent:self.model.uuid completionHandler:^(NSString *content, NSError *error) {
        if (error) {
            [QTProgressHUD showHUDWithText:error.userInfo[ERROR_MESSAGE]];
        } else {
            [QTProgressHUD hide];
            [self setContent:content];
            [self.webView loadHTMLString:[style stringByAppendingString:content] baseURL:nil];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initViews
{
    self.title = self.model.title;
    
//    [self.view addSubview:self.textView];
//    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view);
//    }];
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];

}

#pragma mark - Private

- (void)setContent:(NSString *)text
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 8;// 字体的行间距
    NSDictionary *attributes = @{
                                 NSFontAttributeName: [UIFont systemFontOfSize:16],
                                 NSForegroundColorAttributeName: [UIColor colorFromHexValue:0x585858],
                                 NSParagraphStyleAttributeName: paragraphStyle
                                 };
    self.textView.attributedText = [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

#pragma mark - setter and getter

- (UITextView *)textView
{
    if (_textView == nil) {
        _textView = ({
            UITextView *textView = [[UITextView alloc] init];
            textView.editable = NO;
            textView.backgroundColor = [UIColor whiteColor];
            textView.showsVerticalScrollIndicator = NO;
            textView.showsHorizontalScrollIndicator = NO;
            textView.textContainerInset = UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f);
            textView;
        });
    }
    return _textView;
}

- (UIWebView *)webView
{
    if (_webView == nil) {
        _webView = ({
            UIWebView *webView = [[UIWebView alloc] init];
            webView.scalesPageToFit = YES;//自动对页面进行缩放以适应屏幕
//            webView.detectsPhoneNumbers = YES;//自动检测网页上的电话号码，单击可以拨打
            
            webView;
        });
    }
    return _webView;
}

@end
