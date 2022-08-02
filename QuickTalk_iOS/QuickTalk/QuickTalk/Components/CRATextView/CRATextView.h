//
//  CRATextView.h
//  CreactionTest
//
//  Created by  Ruibin.Chow on 2017/9/14.
//  Copyright © 2017年  Ruibin.Chow. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CRATextView : UITextView

@property (nonatomic, copy)   NSString *placeholder;
//最大长度设置
@property (nonatomic, assign) NSInteger maxTextLength;
//更新高度的时候
@property (nonatomic, assign) CGFloat updateHeight;
//是否需要自动更新高度
@property (nonatomic, assign) BOOL shouldAutoUpdateHeight;

/**
 *  增加text 长度限制
 */
- (void)addMaxTextLengthWithMaxLength:(NSInteger)maxLength andEvent:(void(^)(CRATextView *textView))limit;

/**
 开始编辑的回调
 */
- (void)addTextViewBeginEvent:(void(^)(CRATextView *textView))begin;

/**
 *  结束编辑 的 回调
 */
- (void)addTextViewEndEvent:(void(^)(CRATextView *textView))End;

/**
 * 更新高度时候的回调，在此方法中可以更新其他控件高度
 */
- (void)textViewDidUpdateHeightEvent:(void(^)(CRATextView *textView))event;

/**
 *  设置Placeholder 颜色
 */
- (void)setPlaceholderColor:(UIColor*)color;

/**
 *  设置Placeholder 字体
 */
- (void)setPlaceholderFont:(UIFont*)font;

/**
 *  设置透明度
 */
- (void)setPlaceholderOpacity:(float)opacity;



@end
