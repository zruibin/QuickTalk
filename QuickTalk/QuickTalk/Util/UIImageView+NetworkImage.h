//
//  UIImageView+NetworkImage.h
//  QuickTalk
//
//  Created by  Ruibin.Chow on 2017/9/8.
//  Copyright © 2017年 www.creactism.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (NetworkImage)

- (void)circularImage:(NSString *)url;
- (void)circularImage:(NSString *)url placeholderImage:(UIImage *)placeholderImage;

- (void)cra_setImage:(NSString *)url;
- (void)cra_setImage:(NSString *)url placeholderImage:(UIImage *)placeholderImage;

@end
