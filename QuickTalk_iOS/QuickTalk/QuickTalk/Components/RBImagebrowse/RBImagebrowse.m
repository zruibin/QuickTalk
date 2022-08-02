//
//  RBImagebrowse.m
//
//
//  Created by  Ruibin.Chow on 2017/8/29.
//  Copyright © 2017年 www.zruibin.cc All rights reserved.
//

#import "RBImagebrowse.h"
#import "UIImage+RBImage.h"

@interface RBImagebrowse () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *indexLabel;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger imagesCount;
@property (nonatomic, assign) BOOL doubleClick;

- (void)configScrollViewWithImages:(NSArray *)imags;

@end

@implementation RBImagebrowse

+ (RBImagebrowse *)createBrowseWithImages:(NSArray *)images
{
    RBImagebrowse *browse = [[RBImagebrowse alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [browse prepareData:images];
    return browse;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)prepareData:(NSArray *)images
{
    self.backgroundColor = [UIColor blackColor];
    self.alpha  = 0.0f;
    self.page = 0;
    self.doubleClick = YES;
    
    UITapGestureRecognizer *tapGser = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disappear)];
    tapGser.numberOfTouchesRequired = 1;
    tapGser.numberOfTapsRequired = 1;
    [self addGestureRecognizer:tapGser];
    
    UITapGestureRecognizer *doubleTapGser = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeBig:)];
    doubleTapGser.numberOfTapsRequired = 2;
    [self addGestureRecognizer:doubleTapGser];
    
    [self configScrollViewWithImages:images];
    
    [self addSubview:self.indexLabel];
    if (images.count > 1) self.indexLabel.text = [NSString stringWithFormat:@"1/%ld", (long)images.count];
    _imagesCount = images.count;
}

- (void)configScrollViewWithImages:(NSArray *)imags
{
    _scrollView = [[UIScrollView alloc] initWithFrame:self.frame];
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.pagingEnabled = true;
    _scrollView.delegate = self;
    _scrollView.contentSize = CGSizeMake(self.frame.size.width * imags.count, 0);
    [self addSubview:_scrollView];
    
    for (int i = 0; i < imags.count; i ++) {
        
        UIScrollView *imageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(self.frame.size.width * i, 0, self.frame.size.width, self.frame.size.height)];
        imageScrollView.backgroundColor = [UIColor blackColor];
        imageScrollView.contentSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
        imageScrollView.delegate = self;
        imageScrollView.maximumZoomScale = 4;
        imageScrollView.minimumZoomScale = 1;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        
        id obj = [imags objectAtIndex:i];
        if ([obj isKindOfClass:[NSString class]]) {
            NSString *url = (NSString *)obj;
            [imageView sd_setImageWithURL:[NSURL URLWithString:url]];
        } else {
            UIImage *img = (UIImage *)obj;
            imageView.image = img;
        }
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [imageScrollView addSubview:imageView];
        [_scrollView addSubview:imageScrollView];
        
        imageScrollView.tag = 100 + i ;
        imageView.tag = 1000 + i;
    }
    self.page = 0;
}

- (void)disappear
{
    [UIApplication sharedApplication].statusBarHidden = NO;
    [UIView animateWithDuration:.4f animations:^(){
        self.alpha = .0f;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


- (void)changeBig:(UITapGestureRecognizer *)tapGes
{
    CGFloat newscale = 1.9;
    UIScrollView *currentScrollView = (UIScrollView *)[self viewWithTag:self.page + 100];
    CGRect zoomRect = [self zoomRectForScale:newscale withCenter:[tapGes locationInView:tapGes.view] andScrollView:currentScrollView];
    
    if (self.doubleClick == YES)  {
        [currentScrollView zoomToRect:zoomRect animated:YES];
    } else {
        [currentScrollView zoomToRect:currentScrollView.frame animated:YES];
    }
    
    self.doubleClick = !self.doubleClick;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    UIImageView *imageView = (UIImageView *)[self viewWithTag:scrollView.tag + 900];
    return imageView;
}

- (CGRect)zoomRectForScale:(CGFloat)newscale withCenter:(CGPoint)center andScrollView:(UIScrollView *)scrollV
{
    CGRect zoomRect = CGRectZero;
    
    zoomRect.size.height = scrollV.frame.size.height / newscale;
    zoomRect.size.width = scrollV.frame.size.width  / newscale;
    zoomRect.origin.x = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0);

    return zoomRect;
}

- (void)show
{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIApplication sharedApplication].statusBarHidden = YES;
    self.indexLabel.text = [NSString stringWithFormat:@"%ld/%ld", (long)(_currentImageIndex + 1), (long) self.imagesCount];
    [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width * _currentImageIndex, 0)];
    
    [UIView animateWithDuration:.4f animations:^(){
        self.alpha = 1.0f;
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - ScorllViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int index = (scrollView.contentOffset.x + _scrollView.bounds.size.width * 0.5) / _scrollView.bounds.size.width;
    if (scrollView == _scrollView) {
        self.indexLabel.text = [NSString stringWithFormat:@"%d/%ld", index + 1, (long) self.imagesCount];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGPoint offset = _scrollView.contentOffset;
    self.page = offset.x / self.frame.size.width ;
    
    UIScrollView *scrollV_next = (UIScrollView *)[self viewWithTag:self.page+100+1]; //前一页
    
    if (scrollV_next.zoomScale != 1.0) {
        scrollV_next.zoomScale = 1.0;
    }
    
    UIScrollView *scollV_pre = (UIScrollView *)[self viewWithTag:self.page+100-1]; //后一页
    if (scollV_pre.zoomScale != 1.0) {
        scollV_pre.zoomScale = 1.0;
    }
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    
}

#pragma mark - setter and getter

- (UILabel *)indexLabel
{
    if (_indexLabel == nil) {
        _indexLabel = [[UILabel alloc] init];
        _indexLabel.frame = CGRectMake(0, 20, CGRectGetWidth(self.bounds), 30);
        _indexLabel.textAlignment = NSTextAlignmentCenter;
        _indexLabel.textColor = [UIColor whiteColor];
        _indexLabel.font = [UIFont systemFontOfSize:18];
        _indexLabel.backgroundColor = [UIColor clearColor];
        _indexLabel.hidden = YES;
    }
    return _indexLabel;
}

- (void)setShowIndex:(BOOL)showIndex
{
    _showIndex = showIndex;
    self.indexLabel.hidden = !_showIndex;
}

@end
