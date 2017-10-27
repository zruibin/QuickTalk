//
//  QTNetworking.m
//  QickChat
//
//  Created by  Ruibin.Chow on 2017/8/30.
//  Copyright © 2017年 www.creactism.com. All rights reserved.
//

#import "QTNetworking.h"
#import <AFNetworking.h>

@implementation QTNetworking

#pragma mark - Private

+ (NSString *)encodeParameter:(NSString *)originalPara
{
    CFStringRef encodeParaCf = CFURLCreateStringByAddingPercentEscapes(NULL, (__bridge CFStringRef)originalPara, NULL, CFSTR("!*'();:@&=+$,/?%#[]"), kCFStringEncodingUTF8);
    NSString *encodePara = (__bridge NSString *)(encodeParaCf);
    CFRelease(encodeParaCf);
    return encodePara;
}


#pragma mark - Public

+ (NSURLRequest*)requestURL:(NSString *)baseURL HTTPMethod:(NSString*)httpMethod params:(NSDictionary *)params
{
    NSMutableString *queryString = [NSMutableString string];
    
    [params enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        id value = obj;
        if ([obj isKindOfClass:[NSString class]] && [obj containsString:@"&"]) {
            value = [self encodeParameter:value];
        }
        [queryString appendFormat:@"%@=%@&", key, value];
    }];
    if (params.count > 0) {
        NSRange deleteRange = {[queryString length] - 1, 1};
        [queryString deleteCharactersInRange:deleteRange];
    }
    
    if (httpMethod.length == 0) {
        httpMethod = @"GET";
    }
    
    NSString *reqString = nil;
    if ([httpMethod isEqualToString:@"GET"]) {
        reqString = [NSString stringWithFormat:@"%@?%@", baseURL, queryString];
    } else {
        reqString = baseURL;
    }
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:reqString]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    
    if (![httpMethod isEqualToString:@"GET"]) {
        [request setHTTPMethod:httpMethod];
        [request setHTTPBody:[queryString dataUsingEncoding:NSUTF8StringEncoding]];
    }
    return request;
}

+ (void)handleRequest:(NSURLRequest *)request success:(void (^)(id responseObject))success
              failure:(void (^)(NSError *error))failure
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            if (failure) {
                failure(error);
            }
        } else {
            if (success) {
                success(responseObject);
            }
        }
    }];
    [dataTask resume];
}

+ (void)handleGET:(NSString *)requestURL params:(NSDictionary *)params
          success:(void (^)(id responseObject))success
          failure:(void (^)(NSError *error))failure
{
    NSURLRequest *request  = [self requestURL:requestURL HTTPMethod:@"GET" params:params];
    [self handleRequest:request success:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if (failure) {
            error = [NSError errorWithDomain:@"ERROR_MESSAGE" code:-1
                                    userInfo:@{@"ERROR_MESSAGE": @"网络开了点小差，请稍后再试!"}];
            failure(error);
        }
    }];
}

+ (void)handlePOST:(NSString *)requestURL params:(NSDictionary *)params
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure
{
    NSURLRequest *request  = [self requestURL:requestURL HTTPMethod:@"POST" params:params];
    [self handleRequest:request success:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if (failure) {
            error = [NSError errorWithDomain:@"ERROR_MESSAGE" code:-1
                                    userInfo:@{@"ERROR_MESSAGE": @"网络开了点小差，请稍后再试!"}];
            failure(error);
        }
    }];
}

+ (void)handlePOST:(NSString *)requestURL params:(NSDictionary *)params
            formDataMap:(NSDictionary *)formDataMap
            progress:(void (^)(CGFloat progress))progressBlock
            success:(void (^)(id responseObject))success
            failure:(void (^)(NSError *error))failure
{
    [self handlePOST:requestURL params:params formDataMap:formDataMap compressionRation:1.0f
            progress:progressBlock success:success failure:failure];
}

+ (void)handlePOST:(NSString *)requestURL params:(NSDictionary *)params
            formDataMap:(NSDictionary *)formDataMap
            compressionRation:(CGFloat)ration
            progress:(void (^)(CGFloat progress))progressBlock
            success:(void (^)(id responseObject))success
            failure:(void (^)(NSError *error))failure
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:requestURL parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formDataMap enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull mediaData, BOOL * _Nonnull stop) {
            /*保存为jpeg格式，png太大了，不节省带宽*/
            NSData *data = UIImageJPEGRepresentation(mediaData, ration);
            NSString *fileName = [NSString stringWithFormat:@"%@.jpeg", key];
            [formData appendPartWithFileData:data name:key fileName:fileName mimeType:@"image/jpeg"];
        }];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        //上传进度
        // @property int64_t totalUnitCount;     需要下载文件的总大小
        // @property int64_t completedUnitCount; 当前已经下载的大小
        if (progressBlock) {
            CGFloat progress = 1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount;
            progressBlock(progress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            error = [NSError errorWithDomain:@"ERROR_MESSAGE" code:-1
                                    userInfo:@{@"ERROR_MESSAGE": @"网络开了点小差，请稍后再试!"}];
            failure(error);
        }
    }];
}

+ (void)handleRequest:(NSString *)requestURL method:(NSString *)method params:(NSDictionary *)params
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure
{
    if ([method isEqualToString:@"GET"] || [method isEqualToString:@"get"] || method.length == 0) {
        [self handleGET:requestURL params:params success:^(id responseObject) {
            if (success) {
                success(responseObject);
            }
        } failure:^(NSError *error) {
            if (failure) {
                failure(error);
            }
        }];
    } else {
        [self handlePOST:requestURL params:params success:^(id responseObject) {
            if (success) {
                success(responseObject);
            }
        } failure:^(NSError *error) {
            if (failure) {
                failure(error);
            }
        }];
    }
}

@end
