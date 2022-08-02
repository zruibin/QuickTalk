//
//  CRALocationPickerView.h
//  CreactionTest
//
//  Created by  Ruibin.Chow on 2017/9/7.
//  Copyright © 2017年  Ruibin.Chow. All rights reserved.
//

#import "CRABasePickerView.h"

typedef void(^CRALocationResultBlock)(NSArray *selectAddressArr);

@interface CRALocationPickerView : CRABasePickerView

/**
 *  显示地址选择器
 *
 *  @param defaultSelectedArr       默认选中的值(传数组，元素为对应的索引值。如：@[@10, @1])
 *  @param isAutoSelect             是否自动选择，即选择完(滚动完)执行结果回调，传选择的结果值
 *  @param resultBlock              选择后的回调
 *
 */
+ (void)showAddressPickerWithDefaultSelected:(NSArray *)defaultSelectedArr isAutoSelect:(BOOL)isAutoSelect resultBlock:(CRALocationResultBlock)resultBlock;

@end
