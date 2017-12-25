//
//  QTMessageModel.h
//  QuickTalk
//
//  Created by  Ruibin.Chow on 2017/12/25.
//  Copyright © 2017年 www.creactism.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QTMessageCountModel : NSObject

@property (nonatomic, assign) NSInteger count;
@property (nonatomic, copy) NSString *type;

@end

@interface QTMessageModel : NSObject

+ (void)requestMessageCountData:(NSString *)userUUID
                           type:(NSString *)type
              completionHandler:(void (^)(QTMessageCountModel *model, NSError * error))completionHandler;

@end
