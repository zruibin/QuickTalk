//
//  QTNetworkAgent.m
//  QuickTalk
//
//  Created by  Ruibin.Chow on 2017/10/17.
//  Copyright © 2017年 www.creactism.com. All rights reserved.
//

#import "QTNetworkAgent.h"
#import "QTNetworking.h"

NSString * const QuickTalk_SERVICE_HOST = @"http://192.168.0.103/service";
//NSString * const QuickTalk_SERVICE_HOST = @"http://127.0.0.1:5000/service";
//NSString * const QuickTalk_SERVICE_HOST = @"http://creactism.com/service";
NSString * const SERVICE_REQUEST_GET = @"GET";
NSString * const SERVICE_REQUEST_POST = @"POST";


@implementation QTNetworkAgent

#pragma mark - Private

+ (NSString *_Nonnull)appendHostURL:(NSString * _Nonnull)subURL
{
    NSString *fullURL = [NSString stringWithFormat:@"%@/quickTalk%@", QuickTalk_SERVICE_HOST, subURL];
    return fullURL;
}

#pragma mark - Public

+ (void)requestDataForQuickTalkService:(NSString *_Nonnull)serviceURL
                              method:(NSString *_Nullable)method
                              params:(NSDictionary *_Nullable)params
                   completionHandler:(void(^_Nullable)(id  _Nullable responseObject, NSError * _Nullable error))completionHandler
{
//    NSString *subURL = [NSString stringWithFormat:@"/quickTalk%@", serviceURL];
    NSString *fullURL = [self appendHostURL:serviceURL];
    [QTNetworking handleRequest:fullURL method:method params:params success:^(id responseObject) {
        if (completionHandler) {
            completionHandler(responseObject, nil);
        }
    } failure:^(NSError *error) {
        if (completionHandler) {
            completionHandler(nil, error);
        }
    }];
}

+ (void)requestDataForUserPostService:(NSString *_Nonnull)serviceURL
                               method:(NSString *_Nullable)method
                               params:(NSDictionary *_Nullable)params
                    completionHandler:(void(^_Nullable)(id  _Nullable responseObject, NSError * _Nullable error))completionHandler
{
    NSString *subURL = [NSString stringWithFormat:@"/userPost%@", serviceURL];
    [self requestDataForQuickTalkService:subURL method:method params:params completionHandler:completionHandler];
}

+ (void)requestDataForAccountService:(NSString *_Nonnull)serviceURL
                              method:(NSString *_Nullable)method
                              params:(NSDictionary *_Nullable)params
                   completionHandler:(void(^_Nullable)(id  _Nullable responseObject, NSError * _Nullable error))completionHandler
{
    NSString *subURL = [NSString stringWithFormat:@"/account%@", serviceURL];
    [self requestDataForQuickTalkService:subURL method:method params:params completionHandler:completionHandler];
}

@end
