//
//  RBImagebrowse.h
//
//
//  Created by  Ruibin.Chow on 2017/8/29.
//  Copyright © 2017年 www.zruibin.cc All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RBImagebrowse : UIView

@property (nonatomic, assign) NSInteger currentImageIndex;
@property (nonatomic, assign) BOOL showIndex;

/**
 初始化

 @param images 要展示的图片数组(数组内容为UIImage)
 @return 该对象
 */
+ (RBImagebrowse *)createBrowseWithImages:(NSArray *)images;

- (void)show;

@end
