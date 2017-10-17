//
//  UIImage+RBImage.h
//  QuickTalk
//
//  Created by  Ruibin.Chow on 2017/9/1.
//  Copyright © 2017年  Ruibin.Chow. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, RBImageType) {
    RBImageTypeNone,
    RBImageTypePNG,
    RBImageTypeJPEG,
    RBImageTypeGIF,
    RBImageTypeTIFF,
    RBImageTypeWEBP
};

@interface UIImage (RBImage)

- (UIImage*)circleImage:(UIImage*)image withParam:(CGFloat) inset;

- (UIImage *)circleCorner;

- (UIImage *)imageAtRect:(CGRect)rect;
- (UIImage *)imageByScalingProportionallyToMinimumSize:(CGSize)targetSize;
- (UIImage *)imageByScalingProportionallyToSize:(CGSize)targetSize;
- (UIImage *)imageByScalingToSize:(CGSize)targetSize;
- (UIImage *)imageRotatedByRadians:(CGFloat)radians;
- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees;

- (UIImage *)imageWithTintColor:(UIColor *)tintColor;
- (UIImage *)imageWithGradientTintColor:(UIColor *)tintColor;

+ (UIImage*)createImageWithColor:(UIColor*)color;

- (UIImage *)blurFilterImage;
- (UIImage *)blurFilterImageWithInputRadius:(CGFloat)inputRadius;

+ (UIImage *)imageWithDottedLine:(CGSize)size;

@end
