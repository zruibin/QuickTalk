//
//  CRATextView.m
//  CreactionTest
//
//  Created by  Ruibin.Chow on 2017/9/14.
//  Copyright © 2017年  Ruibin.Chow. All rights reserved.
//

#import "CRATextView.h"

static const CGFloat kTopY = 10.0;
static const CGFloat kLeftX = 5.0;

@interface CRATextView () <UITextViewDelegate>

@property (nonatomic, strong) UIColor *placeholder_color;
@property (nonatomic, strong) UIFont * placeholder_font;
/**
 *   显示 Placeholder
 */
@property (nonatomic, strong, readonly)  UILabel *PlaceholderLabel;

@property (nonatomic, assign) CGFloat placeholdeWidth;

@property (nonatomic, copy) id eventBlock;
@property (nonatomic, copy) id BeginBlock;
@property (nonatomic, copy) id EndBlock;
@property (nonatomic, copy) id updateBlock;

@end

@implementation CRATextView


#pragma mark - life cycle

- (id) initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        [self awakeFromNib];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(DidChange:) name:UITextViewTextDidChangeNotification object:self];
    
    //UITextViewTextDidBeginEditingNotification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewBeginNoti:) name:UITextViewTextDidBeginEditingNotification object:self];
    
    //UITextViewTextDidEndEditingNotification
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewEndNoti:) name:UITextViewTextDidEndEditingNotification object:self];
    
    CGFloat left = kLeftX, top = kTopY, hegiht = 30;
    
    self.placeholdeWidth = CGRectGetWidth(self.frame)-2*left;
    
    _PlaceholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(left, top
                                                                , _placeholdeWidth, hegiht)];
    
    _PlaceholderLabel.numberOfLines = 0;
    _PlaceholderLabel.lineBreakMode = NSLineBreakByCharWrapping|NSLineBreakByWordWrapping;
    [self addSubview:_PlaceholderLabel];
    
    
    [self defaultConfig];
    
}

- (void)layoutSubviews
{
    CGFloat left = kLeftX, top = kTopY, hegiht = self.bounds.size.height;
    self.placeholdeWidth=CGRectGetWidth(self.frame)-2*left;
    CGRect frame=_PlaceholderLabel.frame;
    frame.origin.x=left;
    frame.origin.y=top;
    frame.size.height=hegiht;
    frame.size.width=self.placeholdeWidth;
    _PlaceholderLabel.frame=frame;
    
    [_PlaceholderLabel sizeToFit];
}

- (void)dealloc
{
    [_PlaceholderLabel removeFromSuperview];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Event response

- (void)defaultConfig
{
    self.placeholder_color = [UIColor lightGrayColor];
    self.placeholder_font  = [UIFont systemFontOfSize:14];
    self.maxTextLength = 1000;
    //    self.layoutManager.allowsNonContiguousLayout=NO;
}

- (void)addMaxTextLengthWithMaxLength:(NSInteger)maxLength andEvent:(void (^)(CRATextView *textView))limit
{
    if (maxLength > 0) {
        _maxTextLength = maxLength;
    }
    if (limit) {
        _eventBlock = limit;
    }
}

- (void)addTextViewBeginEvent:(void (^)(CRATextView *))begin
{
    _BeginBlock = begin;
}

- (void)addTextViewEndEvent:(void (^)(CRATextView *))End
{
    _EndBlock = End;
}

- (void)textViewDidUpdateHeightEvent:(void (^)(CRATextView *))event
{
    _updateBlock = event;
}

- (void)setUpdateHeight:(CGFloat)updateHeight
{
    CGRect frame=self.frame;
    frame.size.height=updateHeight;
    self.frame=frame;
    _updateHeight=updateHeight;
}

#pragma mark - Public

- (void)setPlaceholderFont:(UIFont *)font
{
    self.placeholder_font = font;
}

- (void)setPlaceholderColor:(UIColor *)color
{
    self.placeholder_color = color;
}

- (void)setPlaceholderOpacity:(float)opacity
{
    if (opacity < 0) {
        opacity = 1;
    }
    self.PlaceholderLabel.layer.opacity = opacity;
}

#pragma mark - Noti Event

- (void)textViewBeginNoti:(NSNotification*)noti
{
    if (_BeginBlock) {
        void(^begin)(CRATextView *textView) = _BeginBlock;
        begin(self);
    }
}

- (void)textViewEndNoti:(NSNotification*)noti
{
    if (_EndBlock) {
        void(^end)(CRATextView *textView) = _EndBlock;
        end(self);
    }
}

- (void)DidChange:(NSNotification*)noti
{
    if (self.placeholder.length == 0 || [self.placeholder isEqualToString:@""]) {
        _PlaceholderLabel.hidden = YES;
    }
    
    if (self.text.length > 0) {
        _PlaceholderLabel.hidden = YES;
    }
    else{
        _PlaceholderLabel.hidden = NO;
    }
    
    NSString *lang = [[self.nextResponder textInputMode] primaryLanguage]; // 键盘输入模式
    
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [self markedTextRange];
        //获取高亮部分
        UITextPosition *position = [self positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (self.text.length > self.maxTextLength) {
                self.text = [self.text substringToIndex:self.maxTextLength];
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else {
            
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else {
        if (self.text.length > self.maxTextLength) {
            self.text = [ self.text substringToIndex:self.maxTextLength];
        }
    }
    
    if (_eventBlock && self.text.length > self.maxTextLength) {
        void (^limint)(CRATextView *textView) =_eventBlock;
        limint(self);
    }
    
    if (self.shouldAutoUpdateHeight) {
        self.scrollEnabled = NO;
        float textViewHeight =  [self sizeThatFits:CGSizeMake(self.frame.size.width, CGFLOAT_MAX)].height;
        CGRect frame = self.frame;
        frame.size.height = textViewHeight;
        self.frame = frame;
        if (_updateBlock) {
            void (^updateHeight)(CRATextView *textView) = _updateBlock;
            updateHeight(self);
        }
    }
}

#pragma mark - private method

+ (float)boundingRectWithSize:(CGSize)size withLabel:(NSString *)label withFont:(UIFont *)font
{
    NSDictionary *attribute = @{NSFontAttributeName:font};
    
    // CGSize retSize;
    CGSize retSize = [label boundingRectWithSize:size
                                         options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                      attributes:attribute
                                         context:nil].size;
    
    return retSize.height;
}

#pragma mark - getters and Setters

- (void)setText:(NSString *)tex
{
    if (tex.length>0) {
        _PlaceholderLabel.hidden = YES;
    }
    [super setText:tex];
}

- (void)setPlaceholder:(NSString *)placeholder
{
    if (placeholder.length == 0 || [placeholder isEqualToString:@""]) {
        _PlaceholderLabel.hidden = YES;
    }
    else
    {
        _PlaceholderLabel.text = placeholder;
        _placeholder = placeholder;
    }
}

- (void)setPlaceholder_font:(UIFont *)placeholder_font
{
    _placeholder_font = placeholder_font;
    _PlaceholderLabel.font = placeholder_font;
}

- (void)setPlaceholder_color:(UIColor *)placeholder_color
{
    _placeholder_color = placeholder_color;
    _PlaceholderLabel.textColor = placeholder_color;
}



@end





