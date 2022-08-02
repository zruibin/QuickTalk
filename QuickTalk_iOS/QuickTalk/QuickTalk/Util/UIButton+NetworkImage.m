//
//  UIButton+NetworkImage.m
//  QuickTalk
//
//  Created by  Ruibin.Chow on 2017/9/8.
//  Copyright © 2017年 www.creactism.com. All rights reserved.
//

#import "UIButton+NetworkImage.h"

@implementation UIButton (NetworkImage)

- (void)circularBackgroundImage:(NSString *)url
{
    [self circularBackgroundImage:url placeholderImage:[QuickTalk_DEFAULT_IMAGE circleCorner]];
}

- (void)circularBackgroundImage:(NSString *)url placeholderImage:(UIImage *)placeholderImage
{
    [self setBackgroundImage:placeholderImage forState:UIControlStateNormal];
    [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:url] options:0 progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // 耗时的操作
            UIImage *circleImage = [image circleCorner];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setBackgroundImage:circleImage forState:UIControlStateNormal];
            });
        });
    }];
}

- (void)circularImage:(NSString *)url
{
    [self circularImage:url placeholderImage:[QuickTalk_DEFAULT_IMAGE circleCorner]];
}

- (void)circularImage:(NSString *)url placeholderImage:(UIImage *)placeholderImage
{
    [self setImage:placeholderImage forState:UIControlStateNormal];
//    [self sd_setImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal];
    [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:url] options:0 progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // 耗时的操作
            UIImage *circleImage = [image circleCorner];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setImage:circleImage forState:UIControlStateNormal];
            });
        });
    }];
}

- (void)circularImage:(NSString *)url scalingToSize:(CGSize)size
{
    [self circularImage:url placeholderImage:[QuickTalk_DEFAULT_IMAGE circleCorner]];
}

- (void)circularImage:(NSString *)url placeholderImage:(UIImage *)placeholderImage scalingToSize:(CGSize)size
{
    [self setImage:[placeholderImage imageByScalingToSize:size] forState:UIControlStateNormal];
    [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:url] options:0 progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // 耗时的操作
            UIImage *circleImage = [[image circleCorner] imageByScalingToSize:size];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setImage:circleImage forState:UIControlStateNormal];
            });
        });
    }];
}

- (void)cra_setBackgroundImage:(NSString *)url
{
    [self cra_setBackgroundImage:url placeholderImage:QuickTalk_DEFAULT_IMAGE];
}

- (void)cra_setBackgroundImage:(NSString *)url placeholderImage:(UIImage *)placeholderImage
{
    [self sd_setBackgroundImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal placeholderImage:placeholderImage];
}

- (void)cra_setImage:(NSString *)url
{
    [self cra_setImage:url placeholderImage:QuickTalk_DEFAULT_IMAGE];
}

- (void)cra_setImage:(NSString *)url placeholderImage:(UIImage *)placeholderImage
{
    [self sd_setImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal placeholderImage:placeholderImage];
}

@end
