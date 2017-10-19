//
//  QTTopicController.m
//  QuickTalk
//
//  Created by  Ruibin.Chow on 2017/10/16.
//  Copyright © 2017年 www.creactism.com. All rights reserved.
//

#import "QTTopicController.h"
#import "QTTopicModel.h"
#import "QTTopicLeftCell.h"
#import "QTTopicRightCell.h"
#import "QBPopupMenu.h"

@interface QTTopicController ()
<
UITableViewDataSource, UITableViewDelegate,
UITextFieldDelegate, QBPopupMenuDelegate
>

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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;//self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([QTTopicLeftCell class])];
    if (indexPath.row % 2 == 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([QTTopicRightCell class])];
    }
    cell.backgroundColor = [UIColor clearColor];
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
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    CGRect frame = cell.frame;
    CGPoint point = [self.tableView contentOffset];//在内容视图的起源到滚动视图的原点偏移。
    frame.origin.y = cell.frame.origin.y - point.y;
    
    QBPopupMenuItem *item = [QBPopupMenuItem itemWithTitle:@"  赞同(100)" target:self
                                                    action:@selector(popupArgeeAction)];
    QBPopupMenuItem *item2 = [QBPopupMenuItem itemWithTitle:@"不赞同(20)" target:self
                                                     action:@selector(popupDisargeeAction)];
    QBPopupMenu *popupMenu = [[QBPopupMenu alloc] initWithItems:@[item, item2]];
    popupMenu.cornerRadius = 6;
    popupMenu.height = 36;
    popupMenu.highlightedColor = [[UIColor colorWithRed:0 green:0.478 blue:1.0 alpha:1.0] colorWithAlphaComponent:0.8];
    [popupMenu showInView:self.tableView targetRect:frame animated:YES];
}

- (void)popupArgeeAction
{
    
}

- (void)popupDisargeeAction
{
    
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
//            tableView.contentInset = UIEdgeInsetsMake(5, 0, 0, 0);
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            [tableView registerClass:[QTTopicLeftCell class] forCellReuseIdentifier:NSStringFromClass([QTTopicLeftCell class])];
            [tableView registerClass:[QTTopicRightCell class] forCellReuseIdentifier:NSStringFromClass([QTTopicRightCell class])];
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
            textField.returnKeyType = UIReturnKeySend;
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
