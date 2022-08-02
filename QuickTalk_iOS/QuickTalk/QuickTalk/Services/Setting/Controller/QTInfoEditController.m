//
//  QTInfoEditController.m
//  QuickTalk
//
//  Created by  Ruibin.Chow on 2017/11/1.
//  Copyright © 2017年 www.creactism.com. All rights reserved.
//

#import "QTInfoEditController.h"

@interface QTInfoEditController () <UITextFieldDelegate>
{
    NSUInteger kMaxNumber;
}

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UILabel *warningLabel;

- (void)initViews;
- (void)savaAction;

@end

@implementation QTInfoEditController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initViews];
    [self.textField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initViews
{
    self.title = @"编辑昵称";
    self.textField.text = [QTUserInfo sharedInstance].nickname;
    kMaxNumber = 24;
    [self.view addSubview:self.textField];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(20);
        make.height.mas_equalTo(44);
    }];
    [self.view addSubview:self.warningLabel];
    [self.warningLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(7);
        make.right.equalTo(self.view).offset(-7);
        make.top.equalTo(self.textField.mas_bottom).offset(2);
        make.height.mas_equalTo(20);
    }];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(savaAction)];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)savaAction
{
    [self.textField resignFirstResponder];
    if (self.textField.text.length == 0) {
        [QTMessage showWarningNotification:@"昵称不可为空"];
        return;
    }
    [QTProgressHUD showHUD:self.view];
    [QTUserInfo requestChangeNickName:[QTUserInfo sharedInstance].uuid nickname:self.textField.text completionHandler:^(BOOL action, NSError *error) {
        if (action) {
            [QTUserInfo sharedInstance].nickname = self.textField.text;
            [QTProgressHUD showHUDSuccess];
            if (self.onChangeBlock) {
                self.onChangeBlock(self.textField.text);
            }
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [QTProgressHUD showHUDWithText:error.userInfo[ERROR_MESSAGE]];
        }
    }];
}

#pragma mark - Event

- (void)onTextFieldChange:(UITextField *)textField
{
    self.warningLabel.text = @"";
    
    if (kMaxNumber == 0) {
        return; /*不限制长度*/
    }
    NSString *toBeString = textField.text;
    //    DLog(@" 打印信息toBeString:%@", toBeString);
    NSString *lang = [[textField textInputMode] primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { //
        /*
         简体中文输入，包括简体拼音，健体五笔，简体手写
         判断markedTextRange是不是为Nil，如果为Nil的话就说明你现在没有未选中的字符，
         可以计算文字长度。否则此时计算出来的字符长度可能不正确
         */
        UITextRange *selectedRange = [textField markedTextRange];
        /*获取高亮部分(感觉输入中文的时候才有)*/
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        /*没有高亮选择的字，则对已输入的文字进行字数统计和限制*/
        if (!position) {
            /*中文和字符一起检测  中文是两个字符*/
            if ([toBeString getStringLenthOfBytes] > kMaxNumber) {
                textField.text = [toBeString subBytesOfstringToIndex:kMaxNumber];
                self.warningLabel.text = @"不能超过12个文字(24个英文)";
            }
        }
    } else {
        if ([toBeString getStringLenthOfBytes] > kMaxNumber) { //超出截取
            textField.text = [toBeString subBytesOfstringToIndex:kMaxNumber];
            self.warningLabel.text = @"不能超过12个文字(24个英文)";
        }
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField.text stringContainsEmoji]) {
        [QTMessage showWarningNotification:@"暂不支持Emoji表情"];
        return YES;
    }
    
    [self savaAction];
    return YES;
}

#pragma mark - Touches Event

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (![self.textField isExclusiveTouch]) {
        [self.textField resignFirstResponder];
    }
}

#pragma mark - setter and getter

- (UITextField *)textField
{
    if (_textField == nil) {
        _textField = ({
            UITextField *textField = [[UITextField alloc] init];
            textField.clearButtonMode = UITextFieldViewModeAlways;
            textField.backgroundColor = [UIColor whiteColor];
            textField.textColor = [UIColor colorFromHexValue:0x999999];
            textField.font = [UIFont systemFontOfSize:14];
            textField.translatesAutoresizingMaskIntoConstraints = NO;
            textField.returnKeyType = UIReturnKeyDone;
            textField.delegate = self;
            [textField addTarget:self action:@selector(onTextFieldChange:) forControlEvents:UIControlEventEditingChanged];
            
            CGRect frame = [textField frame];
            frame.size.width = 7.0f;
            UIView *leftview = [[UIView alloc] initWithFrame:frame];
            textField.leftViewMode = UITextFieldViewModeAlways;
            textField.leftView = leftview;
            
            textField;
        });
    }
    return _textField;
}

- (UILabel *)warningLabel
{
    if (_warningLabel == nil) {
        _warningLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.font = [UIFont systemFontOfSize:12];
            label.textColor = [UIColor redColor];
            label.translatesAutoresizingMaskIntoConstraints = NO;
            label.textAlignment = NSTextAlignmentLeft;
            label;
        });
    }
    return _warningLabel;
}


@end
