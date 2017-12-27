//
//  CRABasePickerView.m
//  CreactionTest
//
//  Created by  Ruibin.Chow on 2017/9/7.
//  Copyright © 2017年  Ruibin.Chow. All rights reserved.
//

#import "CRABasePickerView.h"

const NSUInteger kDatePicHeight = 200;
const NSUInteger kTopViewHeight = 44;


@implementation CRABasePickerView

- (void)initUI
{
    self.frame = [UIScreen mainScreen].bounds;
    // 背景遮罩图层
    [self addSubview:self.backgroundView];
    // 弹出视图
    [self addSubview:self.alertView];
    // 设置弹出视图子视图
    // 添加顶部标题栏
    [self.alertView addSubview:self.topView];
    // 添加左边取消按钮
    [self.topView addSubview:self.leftBtn];
    // 添加右边确定按钮
    [self.topView addSubview:self.rightBtn];
    // 添加中间标题按钮
    [self.topView addSubview:self.titleLabel];
    // 添加分割线
    [self.topView addSubview:self.lineView];
}

#pragma mark - 背景遮罩图层
- (UIView *)backgroundView
{
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.20];
        _backgroundView.userInteractionEnabled = YES;
        UITapGestureRecognizer *myTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapBackgroundView:)];
        [_backgroundView addGestureRecognizer:myTap];
    }
    return _backgroundView;
}

#pragma mark - 弹出视图
- (UIView *)alertView
{
    if (!_alertView) {
        _alertView = [[UIView alloc]initWithFrame:CGRectMake(0,
                                    [UIScreen mainScreen].bounds.size.height - kTopViewHeight - kDatePicHeight,
                                    [UIScreen mainScreen].bounds.size.width,
                                    kTopViewHeight + kDatePicHeight)];
        _alertView.backgroundColor = [UIColor whiteColor];
    }
    return _alertView;
}

#pragma mark - 顶部标题栏视图
- (UIView *)topView
{
    if (!_topView) {
        _topView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, kTopViewHeight + 0.5)];
        _topView.backgroundColor = [UIColor colorWithRed:((CGFloat)((0xFDFDFD & 0xFF0000) >> 16)) / 255.0
                                                   green:((CGFloat)((0xFDFDFD & 0xFF00) >> 8)) / 255.0
                                                    blue:((CGFloat)(0xFDFDFD & 0xFF)) / 255.0 alpha:1.0];
    }
    return _topView;
}

#pragma mark - 左边取消按钮
- (UIButton *)leftBtn
{
    if (!_leftBtn) {
        _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftBtn.frame = CGRectMake(5, 8, 60, 28);
        _leftBtn.backgroundColor = [UIColor clearColor];
        _leftBtn.layer.cornerRadius = 4.0f;
        _leftBtn.layer.borderWidth = 1.0f;
        _leftBtn.layer.masksToBounds = YES;
        _leftBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        [_leftBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_leftBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [_leftBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_leftBtn addTarget:self action:@selector(clickLeftBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftBtn;
}

#pragma mark - 右边确定按钮
- (UIButton *)rightBtn
{
    if (!_rightBtn) {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightBtn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 65, 8, 60, 28);
        _rightBtn.backgroundColor = [UIColor blackColor];
        _rightBtn.layer.cornerRadius = 4.0f;
        _rightBtn.layer.masksToBounds = YES;
        _rightBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        [_rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_rightBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [_rightBtn setTitle:@"保存" forState:UIControlStateNormal];
        [_rightBtn addTarget:self action:@selector(clickRightBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
}

#pragma mark - 中间标题按钮
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(65, 0, [UIScreen mainScreen].bounds.size.width - 130, kTopViewHeight)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont systemFontOfSize:14.0f];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

#pragma mark - 分割线
- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc]initWithFrame:CGRectMake(0, kTopViewHeight, [UIScreen mainScreen].bounds.size.width, 0.5)];
        _lineView.backgroundColor  = [UIColor colorWithRed:225 / 255.0 green:225 / 255.0 blue:225 / 255.0 alpha:1.0];
        [self.alertView addSubview:_lineView];
    }
    return _lineView;
}

#pragma mark - 点击背景遮罩图层事件
- (void)didTapBackgroundView:(UITapGestureRecognizer *)sender
{
    
}

#pragma mark - 取消按钮的点击事件
- (void)clickLeftBtn
{
    
}

#pragma mark - 确定按钮的点击事件
- (void)clickRightBtn
{
    
}

@end
