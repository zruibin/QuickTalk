//
//  NSString+QuickTalk.m
//  QuickTalk
//
//  Created by  Ruibin.Chow on 2017/10/27.
//  Copyright © 2017年 www.creactism.com. All rights reserved.
//

#import "NSString+QuickTalk.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (QuickTalk)

- (NSString *)md5
{
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, strlen(cStr), result );
    return [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ]; /*32位小写*/
}

#pragma mark - 中英混合长度检测

- (NSInteger)getStringLenthOfBytes
{
    NSInteger length = 0;
    for (int i = 0; i<[self length]; i++) {
        //截取字符串中的每一个字符
        NSString *s = [self substringWithRange:NSMakeRange(i, 1)];
        if ([self validateChineseChar:s]) {
            //            DLog(@" s 打印信息:%@",s);
            length +=2;
        }else{
            length +=1;
        }
        //        DLog(@" 打印信息:%@  %ld",s,(long)length);
    }
    return length;
}

- (NSString *)subBytesOfstringToIndex:(NSInteger)index
{
    NSInteger length = 0;
    NSInteger chineseNum = 0;
    NSInteger zifuNum = 0;
    
    for (int i = 0; i<[self length]; i++) {
        //截取字符串中的每一个字符
        NSString *s = [self substringWithRange:NSMakeRange(i, 1)];
        if ([self validateChineseChar:s]) {
            if (length + 2 > index) {
                return [self substringToIndex:chineseNum + zifuNum];
            }
            
            length +=2;
            chineseNum +=1;
        }
        else {
            if (length +1 >index) {
                return [self substringToIndex:chineseNum + zifuNum];
            }
            length+=1;
            zifuNum +=1;
        }
    }
    return [self substringToIndex:index];
}

//检测中文或者中文符号
- (BOOL)validateChineseChar:(NSString *)string
{
    NSString *nameRegEx = @"[\\u0391-\\uFFE5]";
    if (![string isMatchesRegularExp:nameRegEx]) {
        return NO;
    }
    return YES;
}

//检测中文
- (BOOL)validateChinese:(NSString*)string
{
    NSString *nameRegEx = @"[\u4e00-\u9fa5]";
    if (![string isMatchesRegularExp:nameRegEx]) {
        return NO;
    }
    return YES;
}

- (BOOL)isMatchesRegularExp:(NSString *)regex
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:self];
}

#pragma mark -

+ (NSString *)flattenHTML:(NSString *)html trimWhiteSpace:(BOOL)trim
{
    NSScanner *theScanner = [NSScanner scannerWithString:html];
    NSString *text = nil;
    
    while ([theScanner isAtEnd] == NO) {
        // find start of tag
        [theScanner scanUpToString:@"<" intoString:NULL] ;
        // find end of tag
        [theScanner scanUpToString:@">" intoString:&text] ;
        // replace the found tag with a space
        //(you can filter multi-spaces out later if you wish)
        html = [html stringByReplacingOccurrencesOfString:
                [ NSString stringWithFormat:@"%@>", text]
                                               withString:@""];
    }
    
    return trim ? [html stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] : html;
}

+ (NSString *)documentForPath:(NSString *)path
{
    NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *dirPath = [NSString stringWithFormat:@"%@/%@", document, path];
    BOOL isDir;
    if ([[NSFileManager defaultManager] fileExistsAtPath:dirPath isDirectory:&isDir] && isDir) {
        return dirPath;
    }
    [[NSFileManager defaultManager] createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:nil];
    return dirPath;
}

- (NSString *)fileSizeString
{
    // 总大小
    unsigned long long size = 0;
    NSString *sizeText = nil;
    // 文件管理者
    NSFileManager *mgr = [NSFileManager defaultManager];
    
    // 文件属性
    NSDictionary *attrs = [mgr attributesOfItemAtPath:self error:nil];
    // 如果这个文件或者文件夹不存在,或者路径不正确直接返回nil;
    if (attrs == nil) return nil;
    if ([attrs.fileType isEqualToString:NSFileTypeDirectory]) { // 如果是文件夹
        // 获得文件夹的大小  == 获得文件夹中所有文件的总大小
        NSDirectoryEnumerator *enumerator = [mgr enumeratorAtPath:self];
        for (NSString *subpath in enumerator) {
            // 全路径
            NSString *fullSubpath = [self stringByAppendingPathComponent:subpath];
            // 累加文件大小
            size += [mgr attributesOfItemAtPath:fullSubpath error:nil].fileSize;
            
            if (size >= pow(10, 9)) { // size >= 1GB
                sizeText = [NSString stringWithFormat:@"%.2fGB", size / pow(10, 9)];
            } else if (size >= pow(10, 6)) { // 1GB > size >= 1MB
                sizeText = [NSString stringWithFormat:@"%.2fMB", size / pow(10, 6)];
            } else if (size >= pow(10, 3)) { // 1MB > size >= 1KB
                sizeText = [NSString stringWithFormat:@"%.2fKB", size / pow(10, 3)];
            } else { // 1KB > size
                sizeText = [NSString stringWithFormat:@"%zdB", size];
            }
        }
        
    } else { // 如果是文件
        size = attrs.fileSize;
        if (size >= pow(10, 9)) { // size >= 1GB
            sizeText = [NSString stringWithFormat:@"%.2fGB", size / pow(10, 9)];
        } else if (size >= pow(10, 6)) { // 1GB > size >= 1MB
            sizeText = [NSString stringWithFormat:@"%.2fMB", size / pow(10, 6)];
        } else if (size >= pow(10, 3)) { // 1MB > size >= 1KB
            sizeText = [NSString stringWithFormat:@"%.2fKB", size / pow(10, 3)];
        } else { // 1KB > size
            sizeText = [NSString stringWithFormat:@"%zdB", size];
        }
    }
    return sizeText;
}

- (unsigned long long)fileSize
{
    unsigned long long size = 0;
    // 文件管理者
    NSFileManager *mgr = [NSFileManager defaultManager];
    
    // 文件属性
    NSDictionary *attrs = [mgr attributesOfItemAtPath:self error:nil];
    // 如果这个文件或者文件夹不存在,或者路径不正确直接返回nil;
    if (attrs == nil) return 0;
    if ([attrs.fileType isEqualToString:NSFileTypeDirectory]) { // 如果是文件夹
        // 获得文件夹的大小  == 获得文件夹中所有文件的总大小
        NSDirectoryEnumerator *enumerator = [mgr enumeratorAtPath:self];
        for (NSString *subpath in enumerator) {
            // 全路径
            NSString *fullSubpath = [self stringByAppendingPathComponent:subpath];
            // 累加文件大小
            size += [mgr attributesOfItemAtPath:fullSubpath error:nil].fileSize;
        }
    } else { // 如果是文件
        size = attrs.fileSize;
    }
    return size;
}

#pragma mark - 正则相关

- (BOOL)isValidateByRegex:(NSString *)regex
{
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [pre evaluateWithObject:self];
}

#pragma mark -

- (BOOL)isMobileNumberClassification
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188,1705
     * 联通：130,131,132,152,155,156,185,186,1709
     * 电信：133,1349,153,180,189,1700
     */
    //    NSString * MOBILE = @"^1((3//d|5[0-35-9]|8[025-9])//d|70[059])\\d{7}$";//总况
    
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188，1705
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d|705)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186,1709
     17         */
    NSString * CU = @"^1((3[0-2]|5[256]|8[56])\\d|709)\\d{7}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189,1700
     22         */
    NSString * CT = @"^1((33|53|8[09])\\d|349|700)\\d{7}$";
    
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    //    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    
    if (([self isValidateByRegex:CM])
        || ([self isValidateByRegex:CU])
        || ([self isValidateByRegex:CT])
        || ([self isValidateByRegex:PHS]))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (BOOL)isMobileNumber
{
    /**
     *  手机号以13、15、18、170开头，8个 \d 数字字符
     *  小灵通 区号：010,020,021,022,023,024,025,027,028,029 还有未设置的新区号xxx
     */
    NSString *mobileNoRegex = @"^1((3\\d|5[0-35-9]|8[025-9])\\d|70[059])\\d{7}$";//除4以外的所有个位整数，不能使用[^4,\\d]匹配，这里是否iOS Bug?
    NSString *phsRegex =@"^0(10|2[0-57-9]|\\d{3})\\d{7,8}$";
    
    BOOL ret = [self isValidateByRegex:mobileNoRegex];
    BOOL ret1 = [self isValidateByRegex:phsRegex];
    
    return (ret || ret1);
}

- (NSString *)replaceStringWithAsterisk:(NSInteger)startLocation length:(NSInteger)length
{
    NSString *replaceStr = self;
    for (NSInteger i = 0; i < length; i++) {
        NSRange range = NSMakeRange(startLocation, 1);
        replaceStr = [replaceStr stringByReplacingCharactersInRange:range withString:@"*"];
        startLocation ++;
    }
    return replaceStr;
}

- (BOOL)isEmailAddress
{
    NSString *emailRegex = @"[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    return [self isValidateByRegex:emailRegex];
}

- (BOOL) simpleVerifyIdentityCardNum
{
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    return [self isValidateByRegex:regex2];
}

- (BOOL)isCarNumber
{
    //车牌号:湘K-DE829 香港车牌号码:粤Z-J499港
    NSString *carRegex = @"^[\u4e00-\u9fff]{1}[a-zA-Z]{1}[-][a-zA-Z_0-9]{4}[a-zA-Z_0-9_\u4e00-\u9fff]$";//其中\u4e00-\u9fa5表示unicode编码中汉字已编码部分，\u9fa5-\u9fff是保留部分，将来可能会添加
    return [self isValidateByRegex:carRegex];
}

- (BOOL)isIPAddress
{
    NSString *regex = [NSString stringWithFormat:@"^(\\d{1,3})\\.(\\d{1,3})\\.(\\d{1,3})\\.(\\d{1,3})$"];
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    BOOL rc = [pre evaluateWithObject:self];
    
    if (rc) {
        NSArray *componds = [self componentsSeparatedByString:@","];
        
        BOOL v = YES;
        for (NSString *s in componds) {
            if (s.integerValue > 255) {
                v = NO;
                break;
            }
        }
        return v;
    }
    return NO;
}

- (BOOL)isMacAddress
{
    NSString * macAddRegex = @"([A-Fa-f\\d]{2}:){5}[A-Fa-f\\d]{2}";
    return  [self isValidateByRegex:macAddRegex];
}

- (BOOL)isValidUrl
{
    NSString *regex = @"^((http)|(https))+:[^\\s]+\\.[^\\s]*$";
    return [self isValidateByRegex:regex];
}

- (BOOL)isValidChinese
{
    NSString *chineseRegex = @"^[\u4e00-\u9fa5]+$";
    return [self isValidateByRegex:chineseRegex];
}

- (BOOL)isValidPostalcode
{
    NSString *postalRegex = @"^[0-8]\\d{5}(?!\\d)$";
    return [self isValidateByRegex:postalRegex];
}

- (BOOL)isValidTaxNo
{
    NSString *taxNoRegex = @"[0-9]\\d{13}([0-9]|X)$";
    return [self isValidateByRegex:taxNoRegex];
}

- (BOOL)isValidWithMinLenth:(NSInteger)minLenth
                   maxLenth:(NSInteger)maxLenth
             containChinese:(BOOL)containChinese
        firstCannotBeDigtal:(BOOL)firstCannotBeDigtal
{
    //  [\u4e00-\u9fa5A-Za-z0-9_]{4,20}
    NSString *hanzi = containChinese ? @"\u4e00-\u9fa5" : @"";
    NSString *first = firstCannotBeDigtal ? @"^[a-zA-Z_]" : @"";
    
    NSString *regex = [NSString stringWithFormat:@"%@[%@A-Za-z0-9_]{%d,%d}", first, hanzi, (int)(minLenth-1), (int)(maxLenth-1)];
    return [self isValidateByRegex:regex];
}

- (BOOL)isValidWithMinLenth:(NSInteger)minLenth
                   maxLenth:(NSInteger)maxLenth
             containChinese:(BOOL)containChinese
              containDigtal:(BOOL)containDigtal
              containLetter:(BOOL)containLetter
      containOtherCharacter:(NSString *)containOtherCharacter
        firstCannotBeDigtal:(BOOL)firstCannotBeDigtal
{
    NSString *hanzi = containChinese ? @"\u4e00-\u9fa5" : @"";
    NSString *first = firstCannotBeDigtal ? @"^[a-zA-Z_]" : @"";
    NSString *lengthRegex = [NSString stringWithFormat:@"(?=^.{%@,%@}$)", @(minLenth), @(maxLenth)];
    NSString *digtalRegex = containDigtal ? @"(?=(.*\\d.*){1})" : @"";
    NSString *letterRegex = containLetter ? @"(?=(.*[a-zA-Z].*){1})" : @"";
    NSString *characterRegex = [NSString stringWithFormat:@"(?:%@[%@A-Za-z0-9%@]+)", first, hanzi, containOtherCharacter ? containOtherCharacter : @""];
    NSString *regex = [NSString stringWithFormat:@"%@%@%@%@", lengthRegex, digtalRegex, letterRegex, characterRegex];
    return [self isValidateByRegex:regex];
}

#pragma mark - 算法相关

+ (BOOL)accurateVerifyIDCardNumber:(NSString *)value
{
    value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    int length =0;
    if (!value) {
        return NO;
    }else {
        length = (int)value.length;
        
        if (length !=15 && length !=18) {
            return NO;
        }
    }
    // 省份代码
    NSArray *areasArray =@[@"11",@"12", @"13",@"14", @"15",@"21", @"22",@"23", @"31",@"32", @"33",@"34", @"35",@"36", @"37",@"41", @"42",@"43", @"44",@"45", @"46",@"50", @"51",@"52", @"53",@"54", @"61",@"62", @"63",@"64", @"65",@"71", @"81",@"82", @"91"];
    
    NSString *valueStart2 = [value substringToIndex:2];
    BOOL areaFlag =NO;
    for (NSString *areaCode in areasArray) {
        if ([areaCode isEqualToString:valueStart2]) {
            areaFlag =YES;
            break;
        }
    }
    
    if (!areaFlag) {
        return false;
    }
    
    NSRegularExpression *regularExpression;
    NSUInteger numberofMatch;
    
    int year =0;
    switch (length) {
        case 15:
            year = [value substringWithRange:NSMakeRange(6,2)].intValue +1900;
            
            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
                regularExpression = [[NSRegularExpression alloc] initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$"
                                                                         options:NSRegularExpressionCaseInsensitive
                                                                           error:nil];//测试出生日期的合法性
            }else {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$"
                                                                        options:NSRegularExpressionCaseInsensitive
                                                                          error:nil];//测试出生日期的合法性
            }
            numberofMatch = [regularExpression numberOfMatchesInString:value
                                                               options:NSMatchingReportProgress
                                                                 range:NSMakeRange(0, value.length)];
            
            if(numberofMatch >0) {
                return YES;
            } else {
                return NO;
            }
        case 18:
            year = [value substringWithRange:NSMakeRange(6,4)].intValue;
            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
                regularExpression = [[NSRegularExpression alloc] initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$"
                                                                         options:NSRegularExpressionCaseInsensitive
                                                                           error:nil];//测试出生日期的合法性
            } else {
                regularExpression = [[NSRegularExpression alloc] initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}[0-9Xx]$"
                                                                         options:NSRegularExpressionCaseInsensitive
                                                                           error:nil];//测试出生日期的合法性
            }
            numberofMatch = [regularExpression numberOfMatchesInString:value
                                                               options:NSMatchingReportProgress
                                                                 range:NSMakeRange(0, value.length)];
            
            if(numberofMatch >0) {
                int S = ([value substringWithRange:NSMakeRange(0,1)].intValue + [value substringWithRange:NSMakeRange(10,1)].intValue) *7 + ([value substringWithRange:NSMakeRange(1,1)].intValue + [value substringWithRange:NSMakeRange(11,1)].intValue) *9 + ([value substringWithRange:NSMakeRange(2,1)].intValue + [value substringWithRange:NSMakeRange(12,1)].intValue) *10 + ([value substringWithRange:NSMakeRange(3,1)].intValue + [value substringWithRange:NSMakeRange(13,1)].intValue) *5 + ([value substringWithRange:NSMakeRange(4,1)].intValue + [value substringWithRange:NSMakeRange(14,1)].intValue) *8 + ([value substringWithRange:NSMakeRange(5,1)].intValue + [value substringWithRange:NSMakeRange(15,1)].intValue) *4 + ([value substringWithRange:NSMakeRange(6,1)].intValue + [value substringWithRange:NSMakeRange(16,1)].intValue) *2 + [value substringWithRange:NSMakeRange(7,1)].intValue *1 + [value substringWithRange:NSMakeRange(8,1)].intValue *6 + [value substringWithRange:NSMakeRange(9,1)].intValue *3;
                int Y = S %11;
                NSString *M =@"F";
                NSString *JYM =@"10X98765432";
                M = [JYM substringWithRange:NSMakeRange(Y,1)];// 判断校验位
                if ([M isEqualToString:[value substringWithRange:NSMakeRange(17,1)]]) {
                    return YES;// 检测ID的校验位
                } else {
                    return NO;
                }
                
            } else {
                return NO;
            }
        default:
            return NO;
    }
}


/** 银行卡号有效性问题Luhn算法
 *  现行 16 位银联卡现行卡号开头 6 位是 622126～622925 之间的，7 到 15 位是银行自定义的，
 *  可能是发卡分行，发卡网点，发卡序号，第 16 位是校验码。
 *  16 位卡号校验位采用 Luhm 校验方法计算：
 *  1，将未带校验位的 15 位卡号从右依次编号 1 到 15，位于奇数位号上的数字乘以 2
 *  2，将奇位乘积的个十位全部相加，再加上所有偶数位上的数字
 *  3，将加法和加上校验位能被 10 整除。
 */
- (BOOL)bankCardluhmCheck
{
    NSString * lastNum = [[self substringFromIndex:(self.length-1)] copy];//取出最后一位
    NSString * forwardNum = [[self substringToIndex:(self.length -1)] copy];//前15或18位
    
    NSMutableArray * forwardArr = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i=0; i<forwardNum.length; i++) {
        NSString * subStr = [forwardNum substringWithRange:NSMakeRange(i, 1)];
        [forwardArr addObject:subStr];
    }
    
    NSMutableArray * forwardDescArr = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i = (int)(forwardArr.count-1); i> -1; i--) {//前15位或者前18位倒序存进数组
        [forwardDescArr addObject:forwardArr[i]];
    }
    
    NSMutableArray * arrOddNum = [[NSMutableArray alloc] initWithCapacity:0];//奇数位*2的积 < 9
    NSMutableArray * arrOddNum2 = [[NSMutableArray alloc] initWithCapacity:0];//奇数位*2的积 > 9
    NSMutableArray * arrEvenNum = [[NSMutableArray alloc] initWithCapacity:0];//偶数位数组
    
    for (int i=0; i< forwardDescArr.count; i++) {
        NSInteger num = [forwardDescArr[i] intValue];
        if (i%2) {//偶数位
            [arrEvenNum addObject:[NSNumber numberWithInteger:num]];
        } else {//奇数位
            if (num * 2 < 9) {
                [arrOddNum addObject:[NSNumber numberWithInteger:num * 2]];
            } else {
                NSInteger decadeNum = (num * 2) / 10;
                NSInteger unitNum = (num * 2) % 10;
                [arrOddNum2 addObject:[NSNumber numberWithInteger:unitNum]];
                [arrOddNum2 addObject:[NSNumber numberWithInteger:decadeNum]];
            }
        }
    }
    
    __block  NSInteger sumOddNumTotal = 0;
    [arrOddNum enumerateObjectsUsingBlock:^(NSNumber * obj, NSUInteger idx, BOOL *stop) {
        sumOddNumTotal += [obj integerValue];
    }];
    
    __block NSInteger sumOddNum2Total = 0;
    [arrOddNum2 enumerateObjectsUsingBlock:^(NSNumber * obj, NSUInteger idx, BOOL *stop) {
        sumOddNum2Total += [obj integerValue];
    }];
    
    __block NSInteger sumEvenNumTotal =0 ;
    [arrEvenNum enumerateObjectsUsingBlock:^(NSNumber * obj, NSUInteger idx, BOOL *stop) {
        sumEvenNumTotal += [obj integerValue];
    }];
    
    NSInteger lastNumber = [lastNum integerValue];
    
    NSInteger luhmTotal = lastNumber + sumEvenNumTotal + sumOddNum2Total + sumOddNumTotal;
    
    return (luhmTotal%10 ==0)?YES:NO;
}

@end
