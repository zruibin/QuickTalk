//
//  QTUerPostAddController.m
//  QuickTalk
//
//  Created by  Ruibin.Chow on 2017/12/5.
//  Copyright © 2017年 www.creactism.com. All rights reserved.
//

#import "QTUserPostAddController.h"
#import "QTUserPostModel.h"

@interface QTUserPostAddController ()

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIView *panel;
@property (nonatomic, strong) RBLabel *hrefLabel;
@property (nonatomic, strong) UIButton *pasteButton;
@property (nonatomic, strong) UIButton *saveButton;

@property (nonatomic, copy) NSString *webHref;
@property (nonatomic, copy) NSString *webTitle;

- (void)initViews;
- (void)getPasteboardData;

@end

@implementation QTUserPostAddController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initViews];
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initViews
{
    self.title = @"发表";
    
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
    [self.view addSubview:self.pasteButton];
    [self.pasteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.top.equalTo(self.textView.mas_bottom).offset(20);
        make.height.mas_equalTo(60);
    }];
    [self.view addSubview:self.saveButton];
    [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.top.equalTo(self.panel.mas_bottom).offset(20);
        make.height.mas_equalTo(44);
    }];

    self.hrefLabel.hidden = YES;
    self.pasteButton.hidden = NO;
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
    __weak typeof(self) weakSelf = self;
    [QTProgressHUD showHUD:self.view];
    [[RBScheduler sharedInstance] runTask:^{
        UIPasteboard *board = [UIPasteboard generalPasteboard];
        NSURL *url =[NSURL URLWithString:board.string] ;
        NSError *err = nil;
        NSString *str =   [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&err];
        if (err == nil) {
            NSString *re = @"<title>(.*?)</title>";
            NSRange range = [str rangeOfString:re options:NSRegularExpressionSearch];
            if (range.location != NSNotFound) {
                NSString *title = [str substringWithRange:range];
                title = [title stringByReplacingOccurrencesOfString:@"<title>"withString:@""];
                title = [title stringByReplacingOccurrencesOfString:@"</title>"withString:@""];
                DLog(@"title: %@", title);
                dispatch_async(dispatch_get_main_queue(), ^{
                    //                   [QTProgressHUD showHUDWithText:title];
                    [QTProgressHUD hide];
                    weakSelf.webHref = board.string;
                    weakSelf.webTitle = title;
                    weakSelf.hrefLabel.hidden = NO;
                    weakSelf.pasteButton.hidden = YES;
                    weakSelf.hrefLabel.text = title;
                });
            }
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [QTProgressHUD showHUDWithText:@"获取失败，请复制正确网址"];
                weakSelf.hrefLabel.hidden = YES;
                weakSelf.pasteButton.hidden = NO;
            });
        }
    }];
}

#pragma mark - Action

- (void)changeButtonAction
{
    [self getPasteboardData];
}

- (void)saveButtonAction
{
    [self.textView resignFirstResponder];
    if ([[QTUserInfo sharedInstance] checkLoginStatus:self.navigationController] == NO) {
        return;
    }
    
    if (self.webHref.length == 0 || self.webTitle.length == 0) {
        return;
    }
    NSString *userUUID = [QTUserInfo sharedInstance].uuid;
    [QTProgressHUD showHUD:self.view];
    [QTUserPostModel requestAddUserPost:userUUID title:self.webTitle content:self.webHref txt:self.textView.text completionHandler:^(BOOL action, NSError *error) {
        if (action) {
            [QTProgressHUD showHUDSuccess];
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        } else {
            [QTProgressHUD showHUDWithText:error.userInfo[ERROR_MESSAGE]];
        }
    }];
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

- (UIButton *)pasteButton
{
    if (_pasteButton == nil) {
        _pasteButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.translatesAutoresizingMaskIntoConstraints = NO;
            [button setTitle:@"粘贴你的链接" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:16];
            button.layer.cornerRadius = 4;
            button.layer.borderWidth = 0.5f;
            button.layer.borderColor = [[UIColor colorFromHexValue:0x999999] CGColor];
            button.layer.masksToBounds = YES;
            [button setBackgroundImage:[UIImage createImageWithColor:[UIColor colorFromHexValue:0xF3F3F5]] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(changeButtonAction) forControlEvents:UIControlEventTouchUpInside];
            button;
        });
    }
    return _pasteButton;
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
            [button setTitle:@"发表" forState:UIControlStateNormal];
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




@end





