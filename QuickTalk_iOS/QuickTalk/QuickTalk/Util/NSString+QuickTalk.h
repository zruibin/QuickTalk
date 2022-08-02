//
//  NSString+QuickTalk.h
//  QuickTalk
//
//  Created by  Ruibin.Chow on 2017/10/27.
//  Copyright © 2017年 www.creactism.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (QuickTalk)

- (NSString *)md5;

/*获得中英混合长度*/
- (NSInteger)getStringLenthOfBytes;

/*截取中英混合字符*/
- (NSString *)subBytesOfstringToIndex:(NSInteger)index;

/**
 * @brief  去掉字符串NSString中的html标签 “<>”
 *
 * @param html 要修改的nsstring
 * @param trim 是否要将nsstring 中开始的空白用@“”替换,yes会替换，no不会替换
 *
 * @return  nsstring 去掉html标签后的nsstring
 */
+ (NSString *)flattenHTML:(NSString *)html trimWhiteSpace:(BOOL)trim;

+ (NSString *)documentForPath:(NSString *)path;

/*文件或文件夹大小*/
- (NSString *)fileSizeString;
- (NSUInteger)fileSize;


/*手机号分服务商*/
- (BOOL)isMobileNumberClassification;

/*手机号有效性*/
- (BOOL)isMobileNumber;

/*将手机号中特定位置替换为*号*/
- (NSString *)replaceStringWithAsterisk:(NSInteger)startLocation length:(NSInteger)length;

/*邮箱*/
- (BOOL)isEmailAddress;

/*身份证号*/
- (BOOL) simpleVerifyIdentityCardNum;

/*车牌*/
- (BOOL)isCarNumber;

/*IP地址*/
- (BOOL)isIPAddress;

/*mac地址*/
- (BOOL)isMacAddress;

/*url*/
- (BOOL)isValidUrl;

/*判断是否是中文*/
- (BOOL)isValidChinese;

/*邮编号码*/
- (BOOL)isValidPostalcode;

- (BOOL)isValidTaxNo;

- (BOOL)isValidWithMinLenth:(NSInteger)minLenth
                   maxLenth:(NSInteger)maxLenth
             containChinese:(BOOL)containChinese
        firstCannotBeDigtal:(BOOL)firstCannotBeDigtal;

- (BOOL)isValidWithMinLenth:(NSInteger)minLenth
                   maxLenth:(NSInteger)maxLenth
             containChinese:(BOOL)containChinese
              containDigtal:(BOOL)containDigtal
              containLetter:(BOOL)containLetter
      containOtherCharacter:(NSString *)containOtherCharacter
        firstCannotBeDigtal:(BOOL)firstCannotBeDigtal;

/*精确的身份证号码有效性检测*/
+ (BOOL)accurateVerifyIDCardNumber:(NSString *)value;

/*银行卡号有效性问题Luhn算法*/
- (BOOL)bankCardluhmCheck;


/**
 分词

 @param ignoreSpace 是否忽略空格
 @return 分词数组
 */
- (NSArray *)separateWords:(BOOL)ignoreSpace;

@end






