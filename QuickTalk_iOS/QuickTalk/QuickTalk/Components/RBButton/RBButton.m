//
//  RBButton.m
//
//
//  Created by  Ruibin.Chow on 2017/8/29.
//  Copyright © 2017年 www.zruibin.cc All rights reserved.
//

#import "RBButton.h"

@interface RBButton ()

@end

@implementation RBButton

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat space = self.spaceBetweenTitleAndImage;
    
    
    CGFloat titleW = CGRectGetWidth(self.titleLabel.bounds);//titleLabel的宽度
    CGFloat titleH = CGRectGetHeight(self.titleLabel.bounds);//titleLabel的高度
    
    CGFloat imageW = CGRectGetWidth(self.imageView.bounds);//imageView的宽度
    CGFloat imageH = CGRectGetHeight(self.imageView.bounds);//imageView的高度
    
    CGFloat btnCenterX = CGRectGetWidth(self.bounds)/2;//按钮中心点X的坐标（以按钮左上角为原点的坐标系）
    CGFloat imageCenterX = btnCenterX - titleW/2;//imageView中心点X的坐标（以按钮左上角为原点的坐标系）
    CGFloat titleCenterX = btnCenterX + imageW/2;//titleLabel中心点X的坐标（以按钮左上角为原点的坐标系）
    
    
    switch (self.imageAlignment)
    {
        case RBImageAlignmentTop:
        {
            self.titleEdgeInsets = UIEdgeInsetsMake(imageH/2+ space/2, -(titleCenterX-btnCenterX), -(imageH/2 + space/2), titleCenterX-btnCenterX);
            self.imageEdgeInsets = UIEdgeInsetsMake(-(titleH/2 + space/2), btnCenterX-imageCenterX, titleH/2+ space/2, -(btnCenterX-imageCenterX));
        }
            break;
        case RBImageAlignmentLeft:
        {
            self.titleEdgeInsets = UIEdgeInsetsMake(0, space/2, 0,  -space/2);
            self.imageEdgeInsets = UIEdgeInsetsMake(0, -space/2, 0, space);
        }
            break;
        case RBImageAlignmentBottom:
        {
            self.titleEdgeInsets = UIEdgeInsetsMake(-(imageH/2+ space/2), -(titleCenterX-btnCenterX), imageH/2 + space/2, titleCenterX-btnCenterX);
            self.imageEdgeInsets = UIEdgeInsetsMake(titleH/2 + space/2, btnCenterX-imageCenterX,-(titleH/2+ space/2), -(btnCenterX-imageCenterX));
        }
            break;
        case RBImageAlignmentRight:
        {
            self.titleEdgeInsets = UIEdgeInsetsMake(0, -(imageW + space/2), 0, imageW + space/2);
            self.imageEdgeInsets = UIEdgeInsetsMake(0, titleW+space/2, 0, -(titleW+space/2));
        }
            break;
        default:
            break;
    }
}


@end
