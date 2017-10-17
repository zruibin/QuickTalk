//
//  QTNetworkAgent.h
//  QuickTalk
//
//  Created by  Ruibin.Chow on 2017/10/17.
//  Copyright © 2017年 www.creactism.com. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * _Nullable const QuickTalk_SERVICE_HOST;
extern NSString * _Nonnull const SERVICE_REQUEST_GET;
extern NSString * _Nonnull const SERVICE_REQUEST_POST;

@interface QTNetworkAgent : NSObject

+ (void)requestDataForQuickTalkService:(NSString *_Nonnull)serviceURL
                                method:(NSString *_Nullable)method
                                params:(NSDictionary *_Nullable)params
                     completionHandler:(void(^_Nullable)(id  _Nullable responseObject, NSError * _Nullable error))completionHandler;

@end
