//
//  UIColor+Additions.h
//  QuickTalk
//
//  Created by  Ruibin.Chow on 2017/9/1.
//  Copyright © 2017年  Ruibin.Chow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIColor(Additions)

+ (UIColor*)colorFromHexString:(NSString *)hexString;

+ (UIColor*)colorFromHexValue:(NSUInteger)hexValue;

+ (UIColor*)colorFromHexValue:(NSUInteger)hexValue withAlpha:(CGFloat)alpha;

@end
