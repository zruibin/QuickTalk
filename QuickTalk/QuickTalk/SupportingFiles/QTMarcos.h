//
//  QCMarcos.h
//  QuickTalk
//
//  Created by  Ruibin.Chow on 2017/8/29.
//  Copyright © 2017年 www.creactism.com. All rights reserved.
//

#ifndef QCMarcos_h
#define QCMarcos_h

#ifdef DEBUG
#define DLog(FORMAT, ...) NSLog(@"[%@:%d]%@",[[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:FORMAT, ##__VA_ARGS__])
#else
#define DLog(...)
#endif

#pragma mark --- 用宏在category里给对象添加属性

// eg: _PROPERTY_ASSOCIATEDOBJECT(UIButton *, downloadBtn, strong);
#define _PROPERTY_ASSOCIATEDOBJECT( __type, __name, __association_type)  \
        @property (nonatomic, __association_type, setter=set__##__name:, getter=__##__name) __type __name;

//在申明属性的时候用setter来修改属性的set方法,在前面加 __ 避开大小写.
// eg: _MAKE_ASSOCIATEDOBJECT(UIButton *, downloadBtn, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
#define _MAKE_ASSOCIATEDOBJECT( __type, __name, __association_type)  \
        @dynamic __name;  \
        \
        - (__type)__##__name   \
        {   \
            const char * propName = #__name; \
            __type name = objc_getAssociatedObject(self, propName);    \
            return name; \
        }   \
        \
        - (void)set__##__name:(__type)__name   \
        { \
            const char * propName = #__name;    \
            objc_setAssociatedObject(self, propName, __name, __association_type); \
        }





//waitForExpectationsWithTimeout是等待时间，超过了就不再等待往下执行。
#define WAIT do {\
[self expectationForNotification:@"QuickTalkTest" object:nil handler:nil];\
[self waitForExpectationsWithTimeout:30 handler:nil];\
} while (0);

#define NOTIFY \
[[NSNotificationCenter defaultCenter] postNotificationName:@"QuickTalkTest" object:nil];


#define QuickTalk_DEFAULT_IMAGE [UIImage imageNamed:@"avatar_default"]

#define QuickTalk_MAIN_COLOR_HEX @"#00a0e9"
#define QuickTalk_MAIN_COLOR [UIColor colorFromHexString:QuickTalk_MAIN_COLOR_HEX]


//判断设备型号
#define UI_IS_LANDSCAPE ([UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeLeft || [UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeRight)
#define UI_IS_IPAD ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
#define UI_IS_IPHONE ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
#define UI_IS_IPHONE4 (UI_IS_IPHONE && [[UIScreen mainScreen] bounds].size.height < 568.0)
#define UI_IS_IPHONE5 (UI_IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 568.0)
#define UI_IS_IPHONE6 (UI_IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 667.0)
#define UI_IS_IPHONE6PLUS (UI_IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 736.0 || [[UIScreen mainScreen] bounds].size.width == 736.0) // Both orientations
#define UI_IS_IOS8_AND_HIGHER ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0)

/*登录用类型*/
#define QuickTalk_ACCOUNT_EMAIL @"1"
#define QuickTalk_ACCOUNT_PHONE @"2"
#define QuickTalk_ACCOUNT_WECHAT @"8"
#define QuickTalk_ACCOUNT_QQ @"9"
#define QuickTalk_ACCOUNT_WEIBO @"10"

#define MAX_IMAGE_COUNT 9
#define IMAGE_COMPRESSION_RATION 0.5f

#define IFLY_PATH [NSString documentForPath:@"IFly"]
#define QTDataCache @"QTDataCache"
#define QTPasteboardURL @"QTPasteboardURL"

/*UITableView 系列使用*/
#define QTTableViewCellMake(kTableViewCell, kName) kTableViewCell *kName = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([kTableViewCell class])];
#define QTTableViewCellRegister(kTableView, kTableViewCell)  [kTableView registerClass:[kTableViewCell class] forCellReuseIdentifier:NSStringFromClass([kTableViewCell class])];


#endif /* QCMarcos_h */







