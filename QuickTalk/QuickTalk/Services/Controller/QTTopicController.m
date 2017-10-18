//
//  QTTopicController.m
//  QuickTalk
//
//  Created by  Ruibin.Chow on 2017/10/16.
//  Copyright © 2017年 www.creactism.com. All rights reserved.
//

#import "QTTopicController.h"
#import "QTTopicModel.h"

@interface QTTopicController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *fieldView;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) NSMutableArray *dataList;
@property (nonatomic, assign) CGFloat viewWidth;
@property (nonatomic, assign) CGFloat viewHeight;

- (void)initViews;

@end

@implementation QTTopicController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initViews];
    DLog(@"QTTopicController viewDidLoad...");
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardAction:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardAction:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initViews
{
    self.viewWidth = CGRectGetWidth([[UIScreen mainScreen] bounds]);
    self.viewHeight = CGRectGetHeight([[UIScreen mainScreen] bounds]);
    [self.view addSubview:self.tableView];
    self.tableView.frame = CGRectMake(0, 0, self.viewWidth,
                                      self.viewHeight-64-50);
    
    [self.view addSubview:self.fieldView];
    self.fieldView.frame = CGRectMake(0, self.viewHeight-64-50, self.viewWidth, 50);
    
    [self.fieldView addSubview:self.textField];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.fieldView).with.insets(UIEdgeInsetsMake(8, 10, 8, 10));
    }];

    CGRect frame = [self.textField frame];
    frame.size.width = 7.0f;
    UIView *leftview = [[UIView alloc] initWithFrame:frame];
    self.textField.leftViewMode = UITextFieldViewModeAlways;
    self.textField.leftView = leftview;
}


- (void)keyboardAction:(NSNotification*)notification
{
    NSDictionary *info = [notification userInfo];
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    if ([notification.name isEqualToString:UIKeyboardWillShowNotification]) {
        self.fieldView.frame = CGRectMake(0, self.viewHeight-64-50-keyboardSize.height,
                                          self.viewWidth, 50);
    } else {
        self.fieldView.frame = CGRectMake(0, self.viewHeight-64-50, self.viewWidth, 50);
    }
}

#pragma mark - TableView Delegate And DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 100.0f;

    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Touches Event

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.textField resignFirstResponder];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.textField resignFirstResponder];
}


#pragma mark - setter and getter

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = ({
            UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
            tableView.estimatedRowHeight = 0;
            tableView.estimatedSectionHeaderHeight = 0;
            tableView.estimatedSectionFooterHeight = 0;
            tableView.delegate = self;
            tableView.dataSource = self;
            tableView.translatesAutoresizingMaskIntoConstraints = NO;
            tableView.showsVerticalScrollIndicator = NO;
            tableView.exclusiveTouch = YES;
            tableView.backgroundColor = [UIColor clearColor];
            tableView.contentInset = UIEdgeInsetsMake(5, 0, 0, 0);
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
            tableView;
        });
    }
    return _tableView;
}

- (UIView *)fieldView
{
    if (_fieldView == nil) {
        _fieldView = ({
            UIView *view = [UIView new];
            view.backgroundColor = [UIColor colorFromHexValue:0xF9F9F9];
            view;
        });
    }
    return _fieldView;
}

- (UITextField *)textField
{
    if (_textField == nil) {
        _textField = ({
            UITextField *textField = [[UITextField alloc] init];
            textField.clearButtonMode = UITextFieldViewModeAlways;
            textField.returnKeyType =UIReturnKeyDone;
            textField.delegate = self;
            textField.textColor = [UIColor blackColor];
            textField.font = [UIFont systemFontOfSize:14];
            textField.backgroundColor = [UIColor whiteColor];
            textField.layer.borderColor = [[UIColor colorFromHexValue:0xE4E4E4] CGColor];
            textField.layer.borderWidth = .5f;
            textField.layer.cornerRadius = 5;
            textField.translatesAutoresizingMaskIntoConstraints = NO;
            textField.placeholder = @"写评论";
            textField;
        });
    }
    return _textField;
}

@end
