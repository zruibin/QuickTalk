//
//  UIImageView+NetworkImage.m
//  QuickTalk
//
//  Created by  Ruibin.Chow on 2017/9/8.
//  Copyright © 2017年 www.creactism.com. All rights reserved.
//

#import "UIImageView+NetworkImage.h"

@implementation UIImageView (NetworkImage)

- (void)circularImage:(NSString *)url
{
    [self circularImage:url placeholderImage:[QuickTalk_DEFAULT_IMAGE circleCorner]];
}

- (void)circularImage:(NSString *)url placeholderImage:(UIImage *)placeholderImage
{
    self.image = placeholderImage;
    [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:url] options:0 progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // 耗时的操作
            UIImage *circleImage = [image circleCorner];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.image = circleImage;
            });
        });
    }];
}


- (void)cra_setImage:(NSString *)url
{
    [self cra_setImage:url placeholderImage:QuickTalk_DEFAULT_IMAGE];
}

- (void)cra_setImage:(NSString *)url placeholderImage:(UIImage *)placeholderImage
{
    [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:placeholderImage];
}

@end
