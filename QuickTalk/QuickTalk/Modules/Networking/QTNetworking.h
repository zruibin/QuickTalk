//
//  QTNetworking.h
//  QickChat
//
//  Created by  Ruibin.Chow on 2017/8/30.
//  Copyright © 2017年 www.creactism.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@interface QTNetworking : NSObject

+ (BOOL)checkingNetworkStatus;

/**
 request 封装
 
 @param baseURL 基本URL字符串
 @param httpMethod 请求方式
 @param params 参数字典
 @return NSURLRequest对象
 */
+ (NSURLRequest*)requestURL:(NSString *)baseURL HTTPMethod:(NSString*)httpMethod params:(NSDictionary *)params;

/**
 *  HTTP request请求接口
 *
 *  @param request      URL请求
 *  @param success      成功回调
 *  @param failure      失败回调
 */
+ (void)handleRequest:(NSURLRequest *)request success:(void (^)(id responseObject))success
              failure:(void (^)(NSError *error))failure;

/**
 *  HTTP GET请求接口
 *
 *  @param requestURL      URL字符串
 *  @param params 参数字典
 *  @param success      成功回调
 *  @param failure      失败回调
 */
+ (void)handleGET:(NSString *)requestURL params:(NSDictionary *)params
          success:(void (^)(id responseObject))success
          failure:(void (^)(NSError *error))failure;

/**
 *  HTTP POST请求接口
 *
 *  @param requestURL      URL字符串
 *  @param params 参数字典
 *  @param success      成功回调
 *  @param failure      失败回调
 */
+ (void)handlePOST:(NSString *)requestURL params:(NSDictionary *)params
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure;


/**
 上传多媒体请求接口

 @param requestURL  URL字符串
 @param params 参数字典
 @param formDataMap 多媒体字典，内容为{key(1、2、3...) : data(多媒体二进制数据)}，后端排列根据key来排序，key默认为int
 @param progressBlock 进度回调
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)handlePOST:(NSString *)requestURL params:(NSDictionary *)params
            formDataMap:(NSDictionary *)formDataMap
            progress:(void (^)(CGFloat progress))progressBlock
            success:(void (^)(id responseObject))success
            failure:(void (^)(NSError *error))failure;

/**
 上传多媒体请求接口(自定义图片压缩倍率)
 
 @param requestURL  URL字符串
 @param params 参数字典
 @param formDataMap 多媒体字典，内容为{key(1、2、3...) : data(多媒体二进制数据)}，后端排列根据key来排序，key默认为int
 @param ration 压缩倍率
 @param progressBlock 进度回调
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)handlePOST:(NSString *)requestURL params:(NSDictionary *)params
            formDataMap:(NSDictionary *)formDataMap
            compressionRation:(CGFloat)ration
            progress:(void (^)(CGFloat progress))progressBlock
            success:(void (^)(id responseObject))success
            failure:(void (^)(NSError *error))failure;

/**
 通用请求接口

 @param requestURL  URL字符串
 @param method 请求方法
 @param params 参数字典
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)handleRequest:(NSString *)requestURL method:(NSString *)method params:(NSDictionary *)params
              success:(void (^)(id responseObject))success
              failure:(void (^)(NSError *error))failure;

@end






