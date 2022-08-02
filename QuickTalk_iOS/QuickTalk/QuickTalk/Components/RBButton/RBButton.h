//
//  RBButton.h
//
//
//  Created by  Ruibin.Chow on 2017/8/29.
//  Copyright © 2017年 www.zruibin.cc All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  按钮中图片的位置
 */
typedef NS_ENUM(NSUInteger, RBImageAlignment) {
    /**
     *  图片在左，默认
     */
    RBImageAlignmentLeft = 0,
    /**
     *  图片在上
     */
    RBImageAlignmentTop,
    /**
     *  图片在下
     */
    RBImageAlignmentBottom,
    /**
     *  图片在右
     */
    RBImageAlignmentRight,
};


@interface RBButton : UIButton

/**
 *  按钮中图片的位置
 */
@property (nonatomic,assign) RBImageAlignment imageAlignment;
/**
 *  按钮中图片与文字的间距
 */
@property (nonatomic,assign) CGFloat spaceBetweenTitleAndImage;

@end
