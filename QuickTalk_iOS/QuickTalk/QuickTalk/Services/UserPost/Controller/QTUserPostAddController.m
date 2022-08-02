//
//  QTUerPostAddController.m
//  QuickTalk
//
//  Created by  Ruibin.Chow on 2017/12/5.
//  Copyright © 2017年 www.creactism.com. All rights reserved.
//

#import "QTUserPostAddController.h"
#import "QTUserPostModel.h"

NSString * const QTUserPostAddNotification = @"QTUserPostAddNotification";

@interface QTUserPostAddController () <UIWebViewDelegate>

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIView *panel;
@property (nonatomic, strong) RBLabel *hrefLabel;
@property (nonatomic, strong) UIButton *actionButton;
@property (nonatomic, strong) UIButton *saveButton;
@property (nonatomic, strong) UIButton *deleteButton;
@property (nonatomic, copy) NSString *webHref;
@property (nonatomic, copy) NSString *webTitle;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, assign) BOOL action;

- (void)initViews;
- (void)getPasteboardData;

@end

@implementation QTUserPostAddController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initViews];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    UIPasteboard *board = [UIPasteboard generalPasteboard];
    YYCache *cache = [YYCache cacheWithName:QTDataCache];
    if ([cache containsObjectForKey:QTPasteboardURL] == YES) {
        NSString *urlString = (NSString *)[cache objectForKey:QTPasteboardURL];
        if (![urlString isEqualToString:board.string]) {
            [self getPasteboardData];
        }
    } else {
        [self getPasteboardData];
    }
    [cache setObject:board.string forKey:QTPasteboardURL];
    [self.textView becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.textView resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initViews
{
    self.title = @"分享";
    
    [self.view addSubview:self.panel];
    [self.panel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.and.right.equalTo(self.view);
        make.height.mas_equalTo(210);
    }];
    
    [self.view addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.and.right.equalTo(self.view);
        make.height.mas_equalTo(120);
    }];
    
    [self.view addSubview:self.hrefLabel];
    [self.hrefLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.top.equalTo(self.textView.mas_bottom).offset(20);
        make.height.mas_equalTo(60);
    }];
    [self.view addSubview:self.actionButton];
    [self.actionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.and.right.and.bottom.equalTo(self.hrefLabel);
    }];
    [self.view addSubview:self.saveButton];
    [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(16);
        make.right.equalTo(self.view).offset(-16);
        make.top.equalTo(self.panel.mas_bottom).offset(20);
        make.height.mas_equalTo(44);
    }];
    [self.view addSubview:self.deleteButton];
    [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.hrefLabel).offset(-18);
        make.right.equalTo(self.hrefLabel.mas_right).offset(6);
        make.height.and.with.mas_equalTo(40);
    }];

    self.deleteButton.hidden = YES;
    
    self.webView = [[UIWebView alloc] init];
    self.webView.delegate = self;
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

- (void)getPasteboardData
{
    [QTProgressHUD showHUD:self.view];
    UIPasteboard *board = [UIPasteboard generalPasteboard];
    NSURL *url =[NSURL URLWithString:board.string] ;
    [self.webView loadRequest:[[NSURLRequest alloc] initWithURL:url]];
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *jsToGetHTMLSource = @"document.documentElement.innerHTML";
    NSString *str = [webView stringByEvaluatingJavaScriptFromString:jsToGetHTMLSource];
    NSError *err = nil;
    NSString *re = @"<title>[^<]*</title>";
    NSRange range = [str rangeOfString:re options:NSRegularExpressionSearch];
    if (range.location == NSNotFound) {
        re = @"<title[^<]*</title>";
        range = [str rangeOfString:re options:NSRegularExpressionSearch];
    }
    if (err == nil && range.location != NSNotFound) {
        NSString *title = [str substringWithRange:range];
        title = [title stringByReplacingOccurrencesOfString:@"<title>" withString:@""];
        title = [title stringByReplacingOccurrencesOfString:@"<title data-vue-meta=\"true\">" withString:@""];
        title = [title stringByReplacingOccurrencesOfString:@"</title>" withString:@""];
        title = [title stringByReplacingOccurrencesOfString:@" " withString:@""];
        title = [title stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        [QTProgressHUD showHUDSuccess];
        self.webHref = webView.request.URL.absoluteString;
        if (title.length == 0) {
            self.webTitle = self.webHref;
        } else {
            self.webTitle = title;
        }
        self.action = YES;
        self.hrefLabel.text = self.webTitle;
        self.deleteButton.hidden = NO;
    } else {
        [QTProgressHUD showHUDWithText:@"获取失败，请复制正确链接"];
        self.hrefLabel.text = nil;
        self.action = NO;
        self.deleteButton.hidden = YES;
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [QTProgressHUD showHUDWithText:@"获取失败，请复制正确链接"];
    self.hrefLabel.text = nil;
    self.action = NO;
    self.deleteButton.hidden = YES;
}

#pragma mark - Action

- (void)changeButtonAction
{
    if (self.action) {
        NSString *url = self.webHref;
        [Tools openWeb:url viewController:self];
    } else {
        [self.textView resignFirstResponder];
        [self getPasteboardData];
    }
}

- (void)saveButtonAction
{
    [self.textView resignFirstResponder];
    if ([[QTUserInfo sharedInstance] checkLoginStatus:self.navigationController] == NO) {
        return;
    }
    
    if (self.webHref.length == 0 || self.webTitle.length == 0) {
        [QTProgressHUD showHUDText:@"请复制链接" view:self.view];
        return;
    }
    NSString *userUUID = [QTUserInfo sharedInstance].uuid;
    [QTProgressHUD showHUD:self.view];
    [QTUserPostModel requestAddUserPost:userUUID title:self.webTitle content:self.webHref txt:self.textView.text completionHandler:^(BOOL action, NSError *error) {
        if (action) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:QTUserPostAddNotification object:nil];
                [QTProgressHUD showHUDSuccess];
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            });
        } else {
            [QTProgressHUD showHUDWithText:error.userInfo[ERROR_MESSAGE]];
        }
    }];
}

- (void)deleteButtonAction
{
    self.webHref = nil;
    self.webTitle = nil;
    self.hrefLabel.text = nil;
    self.action = NO;
    self.deleteButton.hidden = YES;
}

#pragma mark - getter and setter

- (UITextView *)textView
{
    if (_textView == nil) {
        _textView = ({
            UITextView *textView = [[UITextView alloc] init];
            textView.backgroundColor = [UIColor whiteColor];
            textView.showsVerticalScrollIndicator = NO;
            textView.showsHorizontalScrollIndicator = NO;
            textView.font = [UIFont systemFontOfSize:16];
            textView.textContainerInset = UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f);
            textView;
        });
    }
    return _textView;
}

- (UIButton *)actionButton
{
    if (_actionButton == nil) {
        _actionButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.translatesAutoresizingMaskIntoConstraints = NO;
            [button setTitle:@"点击粘贴链接" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:16];
            button.layer.cornerRadius = 4;
//            button.layer.borderWidth = 0.5f;
//            button.layer.borderColor = [[UIColor colorFromHexValue:0x999999] CGColor];
            button.layer.masksToBounds = YES;
            [button setBackgroundImage:[UIImage createImageWithColor:[UIColor colorWithWhite:0 alpha:0.2f]] forState:UIControlStateHighlighted];
            [button addTarget:self action:@selector(changeButtonAction) forControlEvents:UIControlEventTouchUpInside];
            button;
        });
    }
    return _actionButton;
}

- (UIView *)panel
{
    if (_panel == nil) {
        _panel = ({
            UIView *view = [UIView new];
            view.backgroundColor = [UIColor whiteColor];
            view;
        });
    }
    return _panel;
}

- (RBLabel *)hrefLabel
{
    if (_hrefLabel == nil) {
        _hrefLabel = ({
            RBLabel *label = [[RBLabel alloc] init];
            label.numberOfLines = 2;
            label.backgroundColor = [UIColor colorFromHexValue:0xF3F3F5];
            label.edgeInsets = UIEdgeInsetsMake(0, 10, 0, 5);
            label.font = [UIFont systemFontOfSize:16];
            label.layer.cornerRadius = 4;
//            label.layer.borderWidth = 0.5f;
//            label.layer.borderColor = [[UIColor colorFromHexValue:0x999999] CGColor];
            label.layer.masksToBounds = YES;
            label;
        });
    }
    return _hrefLabel;
}

- (UIButton *)saveButton
{
    if (_saveButton == nil) {
        _saveButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.translatesAutoresizingMaskIntoConstraints = NO;
            [button setTitle:@"发送" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            button.layer.cornerRadius = 4;
//            button.layer.borderWidth = 0.5f;
//            button.layer.borderColor = [QuickTalk_MAIN_COLOR CGColor];
            button.layer.masksToBounds = YES;
            [button setBackgroundImage:[UIImage createImageWithColor:QuickTalk_MAIN_COLOR] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(saveButtonAction) forControlEvents:UIControlEventTouchUpInside];
            button;
        });
    }
    return _saveButton;
}

- (UIButton *)deleteButton
{
    if (_deleteButton == nil) {
        _deleteButton = ({
            UIImage *image = [UIImage imageNamed:@"delete"];
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.translatesAutoresizingMaskIntoConstraints = NO;
            [button setImage:[image imageWithTintColor:[UIColor redColor]] forState:UIControlStateNormal];
            [button setImage:[image imageWithTintColor:QuickTalk_MAIN_COLOR] forState:UIControlStateHighlighted];
            [button addTarget:self action:@selector(deleteButtonAction) forControlEvents:UIControlEventTouchUpInside];
            button;
        });
    }
    return _deleteButton;
}

- (void)setAction:(BOOL)action
{
    _action = action;
    if (_action) {
        [self.actionButton setTitle:@"" forState:UIControlStateNormal];
    } else {
        [self.actionButton setTitle:@"点击粘贴链接" forState:UIControlStateNormal];
    }
}


@end





