//
//  Tools.m
//  QuickTalk
//
//  Created by  Ruibin.Chow on 2017/9/8.
//  Copyright © 2017年 www.creactism.com. All rights reserved.
//

#import "Tools.h"
#import <SafariServices/SafariServices.h>
#import "NBLWebViewController.h"

@interface Tools ()

+ (NSDateFormatter *)getDateFormatter;
+ (NSString*)getMessageDateString:(NSDate*)messageDate andNeedTime:(BOOL)needTime;
+(NSString *)getWeekdayWithNumber:(NSInteger)number;

@end

@implementation Tools

+ (NSString*)dataTojsonString:(id)object
{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (!jsonData) {
        DLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

+ (NSDateFormatter *)getDateFormatter
{
    static NSDateFormatter *formatter;
    if (formatter == nil) {
        formatter = [[NSDateFormatter alloc] init];
    }
    return formatter;
}

+ (NSString *)getDateStringFromTimeString:(NSString *)timeString andNeedTime:(BOOL)needTime
{
    NSDateFormatter *dateFormatter = [self getDateFormatter];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:timeString];
    return [Tools getMessageDateString:date andNeedTime:needTime];
}

+ (NSString *)getDateStringFromTimeInterval:(NSTimeInterval)timeInterval andNeedTime:(BOOL)needTime
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    return [Tools getMessageDateString:date andNeedTime:needTime];
}

+ (NSString*)getMessageDateString:(NSDate*)messageDate andNeedTime:(BOOL)needTime
{
    NSDateFormatter *formatter = [self getDateFormatter];
    [formatter setLocale:[NSLocale systemLocale]];
    [formatter setTimeZone:[NSTimeZone systemTimeZone]];
    [formatter setDateFormat:@"MM月dd日"];
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday fromDate:messageDate];
    NSDate *msgDate = [cal dateFromComponents:components];
    
//    NSString *weekday = [Tools getWeekdayWithNumber:components.weekday];
    components = [cal components:NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday fromDate:[NSDate date]];
    NSDate *today = [cal dateFromComponents:components];
    
    if([today isEqualToDate:msgDate]){
        if (needTime) {
            [formatter setDateFormat:@"今天 HH:mm"];
        }
        else{
            [formatter setDateFormat:@"今天"];
        }
        return [formatter stringFromDate:messageDate];
    }
    
    components.day -= 1;
    NSDate *yestoday = [cal dateFromComponents:components];
    if([yestoday isEqualToDate:msgDate]){
        if (needTime) {
            [formatter setDateFormat:@"昨天 HH:mm"];
        }
        else{
            [formatter setDateFormat:@"昨天"];
        }
        return [formatter stringFromDate:messageDate];
    }
    
//    for (int i = 1; i <= 6; i++) {
//        components.day -= 1;
//        NSDate *nowdate = [cal dateFromComponents:components];
//        if([nowdate isEqualToDate:msgDate]){
//            if (needTime) {
//                [formatter setDateFormat:[NSString stringWithFormat:@"%@ HH:mm",weekday]];
//            }
//            else{
//                [formatter setDateFormat:[NSString stringWithFormat:@"%@",weekday]];
//            }
//            return [formatter stringFromDate:messageDate];
//        }
//    }
    
    while (1) {
        components.day -= 1;
        NSDate *nowdate = [cal dateFromComponents:components];
        if ([nowdate isEqualToDate:msgDate]) {
            if (!needTime) {
                [formatter setDateFormat:@"MM月dd日"];
            }
            return [formatter stringFromDate:messageDate];
            break;
        }
    }
}

//1代表星期日、如此类推
+(NSString *)getWeekdayWithNumber:(NSInteger)number
{
    switch (number) {
        case 1:
            return @"星期日";
            break;
        case 2:
            return @"星期一";
            break;
        case 3:
            return @"星期二";
            break;
        case 4:
            return @"星期三";
            break;
        case 5:
            return @"星期四";
            break;
        case 6:
            return @"星期五";
            break;
        case 7:
            return @"星期六";
            break;
        default:
            return @"";
            break;
    }
}


//苹果官方不推荐使用week
//NSLog(@"week(该年第几周):%i", dateComponents.week);
//NSLog(@"weekOfYear(该年第几周):%i", dateComponents.weekOfYear);
//NSLog(@"weekOfMonth(该月第几周):%i", dateComponents.weekOfMonth);
+ (NSString *)stringFrom1970TimeInterval:(NSString *)timeInterval
{
    long long time = [timeInterval longLongValue];
    NSDate *timeDate = [NSDate dateWithTimeIntervalSince1970:time];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay |
                                                         NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond |
                                                         NSCalendarUnitWeekday)
                                               fromDate:timeDate
                                                 toDate:[NSDate date]
                                                options:0];
    if ([components year] != 0) {
        return [NSString stringWithFormat:@"%ld年前", (long)[components year]];
    }
    else if ([components month] != 0) {
        return [NSString stringWithFormat:@"%ld个月前", (long)[components month]];
    }
    else if ([components weekOfMonth] != 0) {
        return [NSString stringWithFormat:@"%ld周前", (long)[components weekOfMonth]];
    }
    else if ([components day] != 0) {
        return [NSString stringWithFormat:@"%ld天前", (long)[components day]];
    }
    else if ([components hour] != 0) {
        return [NSString stringWithFormat:@"%ld小时前", (long)[components hour]];
    }
    else if ([components minute] != 0) {
        return [NSString stringWithFormat:@"%ld分钟前", (long)[components minute]];
    }
    else {
        return @"刚刚";
    }
    
    return nil;
}

+ (NSInteger)daysSinceReferenceDate:(NSDate *)date toDate:(NSDate *)toDate
{
    if (date == nil) {
        return NSNotFound;
    }
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setTimeZone:[NSTimeZone localTimeZone]];
    unsigned int unitFlag = NSCalendarUnitDay;
    
    NSDateComponents *components = [calendar components:unitFlag fromDate:[NSDate dateWithTimeIntervalSince1970:0] toDate:date options:0];
    NSInteger newDayCount = [components day];
    components = [calendar components:unitFlag fromDate:[NSDate dateWithTimeIntervalSince1970:0] toDate:toDate options:0];
    NSInteger oldDayCount = [components day];
    
    return oldDayCount - newDayCount;
}

+ (NSString *)timeForOnlyYearMonthDay:(NSString *)dataString
{
    NSDateFormatter *formatter = [self getDateFormatter];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [formatter dateFromString:dataString];
    [formatter setDateFormat:@"MM月dd日"];
    return [formatter stringFromDate:date];
}

+ (NSString *)countTransition:(NSInteger)count
{
    if (count < 0) {
        return @"0";
    }
    if (count < 10000) {
        return [NSString stringWithFormat:@"%ld", count];
    } else {
        return [NSString stringWithFormat:@"%ld.%ld万", (long) count / 10000, (long) count % 10000 / 1000];;
    }
}

+ (NSAttributedString *)titleForEmpty:(NSString *)title
{
    NSDictionary *attributes = @{
                                 NSFontAttributeName: [UIFont systemFontOfSize:14],
                                 NSForegroundColorAttributeName: [UIColor colorFromHexValue:0x585858]
                                 };
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:title attributes:attributes];
    return attributedString;
}

+ (UIImage *)imageForEmpty
{
    return [UIImage imageNamed:@"none"];
}

+ (void)drawBorder:(UIView *)view
                      top:(BOOL)top left:(BOOL)left bottom:(BOOL)bottom right:(BOOL)right
              borderColor:(UIColor *)color borderWidth:(CGFloat)width
{
    if (top) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, 0, view.frame.size.width, width);
        layer.backgroundColor = color.CGColor;
        [view.layer addSublayer:layer];
    }
    if (left) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, 0, width, view.frame.size.height);
        layer.backgroundColor = color.CGColor;
        [view.layer addSublayer:layer];
    }
    if (bottom) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, view.frame.size.height - width, view.frame.size.width, width);
        layer.backgroundColor = color.CGColor;
        [view.layer addSublayer:layer];
    }
    if (right) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(view.frame.size.width - width, 0, width, view.frame.size.height);
        layer.backgroundColor = color.CGColor;
        [view.layer addSublayer:layer];
    }
}

+ (void)openWeb:(NSString *)urlString viewController:(UIViewController *)viewController
{
    NBLWebViewController *webVC = [[NBLWebViewController alloc] initWithURLString:urlString];
    [viewController.navigationController pushViewController:webVC animated:YES];
    
//    SFSafariViewController *safariController = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:urlString]];
//    [viewController presentViewController:safariController animated:YES completion:nil];
}

@end



