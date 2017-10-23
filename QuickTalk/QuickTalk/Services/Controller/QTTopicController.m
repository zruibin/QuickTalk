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
#import "QTCommentModel.h"

NSString * const kTopicHiddenPopupMenuNotification = @"kTopicHiddenPopupMenuNotification";

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
@property (nonatomic, assign) NSUInteger page;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, strong) QBPopupMenu *popupMenu;

- (void)initViews;
- (void)loadData;
- (void)loadMoreData;
- (void)sendComment;
- (void)sendAgreeOrDisAgree:(QTCommentModel *)model action:(NSString *)actionStr;

@end

@implementation QTTopicController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kTopicHiddenPopupMenuNotification object:nil];
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
    
    __weak typeof(self) weakSelf = self;
    [self.tableView footerWithRefreshingBlock:^{
        weakSelf.page = 1;
        [weakSelf loadData];
    }];
    [self.tableView beginFooterRefreshing];
    self.page = 1;
    [self.tableView headerWithRefreshingBlock:^{
        weakSelf.page +=1;
        [weakSelf loadMoreData];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:kTopicHiddenPopupMenuNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        [weakSelf.popupMenu dismissAnimated:YES];
    }];
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
                                      self.viewHeight-64-50-6);
    
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

- (void)loadData
{
    [QTCommentModel requestTopicCommentData:self.model.uuid page:1 completionHandler:^(NSArray<QTCommentModel *> *list, NSError *error) {
        if (error) {
            [QTProgressHUD showHUDText:error.userInfo[ERROR_MESSAGE]  view:self.view];
        } else {
            [self.tableView endFooterRefreshing];
            if (list.count > 0) {
                self.dataList = [[[list reverseObjectEnumerator] allObjects] mutableCopy];
                [self.tableView reloadData];
                if (self.tableView.contentSize.height > self.tableView.frame.size.height) {
                    CGPoint offset = CGPointMake(0, self.tableView.contentSize.height - self.tableView.frame.size.height);
                    [self.tableView setContentOffset:offset animated:YES];
                }
            }
        }
    }];
}

- (void)loadMoreData
{
    [QTCommentModel requestTopicCommentData:self.model.uuid page:self.page completionHandler:^(NSArray<QTCommentModel *> *list, NSError *error) {
        if (error) {
            [QTProgressHUD showHUDText:error.userInfo[ERROR_MESSAGE]  view:self.view];
        } else {
            [self.tableView endHeaderRefreshing];
            if (list.count > 0) {
                NSArray *array = [[list reverseObjectEnumerator] allObjects];
                [self.dataList insertObjects:array atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, array.count)]];
                [self.tableView reloadData];
            } else {
                self.page -= 1;
            }
        }
    }];
}

- (void)sendComment
{
    if (self.textField.text.length <= 0) {
        return;
    }
    NSString *topicUUID = self.model.uuid;
    NSString *userUUID = [QTUserInfo sharedInstance].uuid;
    [QTProgressHUD showHUD:self.view];
    [QTCommentModel requestForSendComment:topicUUID content:self.textField.text userUUID:userUUID completionHandler:^(BOOL action, NSError *error) {
        if (action) {
            [QTProgressHUD showHUDSuccess];
            self.textField.text = @"";
            [self loadData];
        } else {
            [QTProgressHUD showHUDWithText:error.userInfo[ERROR_MESSAGE]];
        }
    }];
}

- (void)sendAgreeOrDisAgree:(QTCommentModel *)model action:(NSString *)actionStr
{
    [QTCommentModel requestForAgreeOrDisAgreeComment:model.uuid action:actionStr completionHandler:^(BOOL action, NSError *error) {
        if (action) {
            if ([actionStr isEqualToString:@"1"]) {
                model.like += 1;
            } else {
                model.dislike += 1;
            }
        } else {
            [QTProgressHUD showHUDText:error.userInfo[ERROR_MESSAGE] view:self.view];
        }
    }];
}

#pragma mark -

- (void)keyboardAction:(NSNotification*)notification
{
    [self.popupMenu dismissAnimated:YES];
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
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    QTCommentModel *model = [self.dataList objectAtIndex:indexPath.row];
    if ([model.userUUID isEqualToString:[QTUserInfo sharedInstance].uuid]) {
        QTTopicRightCell *rightCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([QTTopicRightCell class])];
        [rightCell loadData:model.content avatar:model.avatar];
        cell = rightCell;
    } else {
        QTTopicLeftCell *leftCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([QTTopicLeftCell class])];
        
        [leftCell loadData:model.content avatar:model.avatar];
        cell = leftCell;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 100.0f;
    
    QTCommentModel *model = [self.dataList objectAtIndex:indexPath.row];
    if ([model.userUUID isEqualToString:[QTUserInfo sharedInstance].uuid]) {
        QTTopicRightCell *rightCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([QTTopicRightCell class])];
        height = [rightCell heightForCell:model.content];
    } else {
        QTTopicLeftCell *leftCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([QTTopicLeftCell class])];
        height = [leftCell heightForCell:model.content];
    }

    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.selectedIndex = indexPath.row;
    QTCommentModel *model = [self.dataList objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    CGRect frame = cell.frame;
    CGPoint point = [self.tableView contentOffset];//在内容视图的起源到滚动视图的原点偏移。
    frame.origin.y = cell.frame.origin.y - point.y;
    
    NSString *likeStr = [NSString stringWithFormat:@"  赞同(%@)", [Tools countTransition:model.like]];
    QBPopupMenuItem *item = [QBPopupMenuItem itemWithTitle:likeStr target:self
                                                    action:@selector(popupAgreeAction)];
    NSString *dislikeStr = [NSString stringWithFormat:@"不赞同(%@)", [Tools countTransition:model.dislike]];
    QBPopupMenuItem *item2 = [QBPopupMenuItem itemWithTitle:dislikeStr target:self
                                                     action:@selector(popupDisagreeAction)];
    self.popupMenu = [[QBPopupMenu alloc] initWithItems:@[item, item2]];
    self.popupMenu.cornerRadius = 6;
    self.popupMenu.height = 36;
    self.popupMenu.highlightedColor = [[UIColor colorWithRed:0 green:0.478 blue:1.0 alpha:1.0] colorWithAlphaComponent:0.8];
    [self.popupMenu showInView:self.tableView targetRect:frame animated:YES];
}

- (void)popupAgreeAction
{
    QTCommentModel *model = [self.dataList objectAtIndex:self.selectedIndex];
    [self sendAgreeOrDisAgree:model action:@"1"];
}

- (void)popupDisagreeAction
{
    QTCommentModel *model = [self.dataList objectAtIndex:self.selectedIndex];
    [self sendAgreeOrDisAgree:model action:@"2"];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if ([[QTUserInfo sharedInstance] checkLoginStatus:self]) {
        [self sendComment];
    }
    return YES;
}

#pragma mark - Touches Event

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.textField resignFirstResponder];
    [self.popupMenu dismissAnimated:YES];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.textField resignFirstResponder];
    [self.popupMenu dismissAnimated:YES];
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
