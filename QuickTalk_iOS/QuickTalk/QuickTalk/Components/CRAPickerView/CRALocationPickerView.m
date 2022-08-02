//
//  CRALocationPickerView.m
//  CreactionTest
//
//  Created by  Ruibin.Chow on 2017/9/7.
//  Copyright © 2017年  Ruibin.Chow. All rights reserved.
//

#import "CRALocationPickerView.h"

@interface CRALocationPickerView () <UIPickerViewDelegate,UIPickerViewDataSource>
{
    NSInteger rowOfProvince; // 保存省份对应的下标
    NSInteger rowOfCity;     // 保存市对应的下标
}

// 时间选择器（默认大小: 320px × 216px）
@property(nonatomic, strong) UIPickerView *pickerView;

@property(nonatomic, copy) NSDictionary *provinceDict;
@property(nonatomic, copy) NSArray *provinceList;
@property(nonatomic, copy) NSArray *cityList;

// 默认选中的值（@[省索引, 市索引, 区索引]）
@property(nonatomic, strong) NSArray *defaultSelectedArr;
// 是否开启自动选择
@property(nonatomic, assign) BOOL isAutoSelect;
// 选中后的回调
@property(nonatomic, copy) CRALocationResultBlock resultBlock;

@end


@implementation CRALocationPickerView

#pragma mark - 显示地址选择器
+ (void)showAddressPickerWithDefaultSelected:(NSArray *)defaultSelectedArr isAutoSelect:(BOOL)isAutoSelect resultBlock:(CRALocationResultBlock)resultBlock
{
    CRALocationPickerView *addressPickerView = [[CRALocationPickerView alloc] initWithDefaultSelected:defaultSelectedArr isAutoSelect:isAutoSelect resultBlock:resultBlock];
    [addressPickerView showWithAnimation:YES];
}

#pragma mark - 初始化地址选择器
- (instancetype)initWithDefaultSelected:(NSArray *)defaultSelectedArr isAutoSelect:(BOOL)isAutoSelect resultBlock:(CRALocationResultBlock)resultBlock
{
    if (self = [super init]) {
        // 默认选中
        if (defaultSelectedArr.count == 2) {
            self.defaultSelectedArr = defaultSelectedArr;
        } else {
            self.defaultSelectedArr = @[@0, @0];
        }
        self.isAutoSelect = isAutoSelect;
        self.resultBlock = resultBlock;
        [self loadData];
        [self initUI];
    }
    return self;
}

#pragma mark - 获取地址数据
- (void)loadData
{    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"CRALocation" ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:filePath];
    
    NSArray *dataList = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                 options:NSJSONReadingMutableContainers
                                                                   error:nil];
    NSMutableArray *provinceList = [NSMutableArray arrayWithCapacity:[dataList count]];
    NSMutableDictionary *provinceDict = [NSMutableDictionary dictionaryWithCapacity:[dataList count]];
    [dataList enumerateObjectsUsingBlock:^(NSDictionary *provinceData, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *province = [[provinceData allKeys] objectAtIndex:0];
        NSArray *cityList = [provinceData objectForKey:province];
        
        [provinceList addObject:province];
        [provinceDict setValue:cityList forKey:province];
    }];
    
    self.provinceList = [provinceList copy];
    self.provinceDict = [provinceDict copy];
    
    NSString *province = self.provinceList[0];
    self.cityList = [self.provinceDict objectForKey:province];
}

#pragma mark - 初始化子视图
- (void)initUI
{
    [super initUI];
    self.titleLabel.text = @"请选择城市";
    // 添加时间选择器
    [self.alertView addSubview:self.pickerView];
}

#pragma mark - 背景视图的点击事件
- (void)didTapBackgroundView:(UITapGestureRecognizer *)sender
{
    [self dismissWithAnimation:NO];
}

#pragma mark - 弹出视图方法
- (void)showWithAnimation:(BOOL)animation
{
    // 1.获取当前应用的主窗口
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    [keyWindow addSubview:self];
    if (animation) {
        // 动画前初始位置
        CGRect rect = self.alertView.frame;
        rect.origin.y = [UIScreen mainScreen].bounds.size.height;
        self.alertView.frame = rect;
        
        // 浮现动画
        [UIView animateWithDuration:0.3 animations:^{
            CGRect rect = self.alertView.frame;
            rect.origin.y -= kDatePicHeight + kTopViewHeight;
            self.alertView.frame = rect;
        }];
    }
    
    NSInteger recordRowOfProvince = [self.defaultSelectedArr[0] integerValue];
    NSInteger recordRowOfCity = [self.defaultSelectedArr[1] integerValue];
    
    // 2.滚动到默认行
    [self scrollToRow:recordRowOfProvince secondRow:recordRowOfCity];
}

#pragma mark - 关闭视图方法
- (void)dismissWithAnimation:(BOOL)animation
{
    // 关闭动画
    [UIView animateWithDuration:0.2 animations:^{
        CGRect rect = self.alertView.frame;
        rect.origin.y += kDatePicHeight + kTopViewHeight;
        self.alertView.frame = rect;
        self.backgroundView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.leftBtn removeFromSuperview];
        [self.rightBtn removeFromSuperview];
        [self.titleLabel removeFromSuperview];
        [self.lineView removeFromSuperview];
        [self.topView removeFromSuperview];
        [self.pickerView removeFromSuperview];
        [self.alertView removeFromSuperview];
        [self.backgroundView removeFromSuperview];
        [self removeFromSuperview];
        
        self.leftBtn = nil;
        self.rightBtn = nil;
        self.titleLabel = nil;
        self.lineView = nil;
        self.topView = nil;
        self.pickerView = nil;
        self.alertView = nil;
        self.backgroundView = nil;
    }];
}

#pragma mark - 取消按钮的点击事件
- (void)clickLeftBtn
{
    [self dismissWithAnimation:YES];
}

#pragma mark - 确定按钮的点击事件
- (void)clickRightBtn
{
//    NSLog(@"点击确定按钮后，执行block回调");
    [self dismissWithAnimation:YES];
    if(self.resultBlock) {
        NSArray *arr = [self getChooseCityArr];
        self.resultBlock(arr);
    }
}

#pragma mark - 地址选择器
- (UIPickerView *)pickerView
{
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, kTopViewHeight + 0.5, [UIScreen mainScreen].bounds.size.width, kDatePicHeight)];
        _pickerView.backgroundColor = [UIColor whiteColor];
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
    }
    return _pickerView;
}


#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        //返回省个数
        return self.provinceList.count;
    }
    if (component == 1) {
        //返回市个数
        return [self.cityList count];
    }
    return 0;
    
}

#pragma mark - PickerView的代理方法
- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *showTitleValue = @"";
    if (component == 0) {//省
        showTitleValue = [self.provinceList objectAtIndex:row];
    }
    if (component == 1) {//市

        showTitleValue = [self.cityList objectAtIndex:row];
    }

    return showTitleValue;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view
{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ([UIScreen mainScreen].bounds.size.width - 30) / 3, 40)];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:16.0f];
    label.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        rowOfProvince = row;
        rowOfCity = 0;
        NSString *province = self.provinceList[rowOfProvince];
        self.cityList = [self.provinceDict objectForKey:province];
        [pickerView reloadComponent:1];
    }
    if (component == 1) {
        rowOfCity = row;
    }

    // 滚动到指定行
    [self scrollToRow:rowOfProvince secondRow:rowOfCity];

    // 自动获取数据，滚动完就回调
    if (self.isAutoSelect) {
        NSArray *arr = [self getChooseCityArr];
        if (self.resultBlock) {
            self.resultBlock(arr);
        }
    }
}

#pragma mark - Tool
- (NSArray *)getChooseCityArr
{
    NSString *province = self.provinceList[rowOfProvince];
    NSArray *cityList = [self.provinceDict objectForKey:province];
    NSString *city = [cityList objectAtIndex:rowOfCity];
    return @[province, city];
}

#pragma mark - 滚动到指定行
- (void)scrollToRow:(NSInteger)firstRow secondRow:(NSInteger)secondRow
{
    if (firstRow < self.provinceList.count) {
        rowOfProvince = firstRow;
        if (secondRow < self.cityList.count) {
            rowOfCity = secondRow;
            NSString *province = self.provinceList[rowOfProvince];
            self.cityList = [self.provinceDict objectForKey:province];
            [self.pickerView reloadComponent:1];
            [self.pickerView selectRow:firstRow inComponent:0 animated:YES];
            [self.pickerView selectRow:secondRow inComponent:1 animated:YES];
        }
    }
}



@end
