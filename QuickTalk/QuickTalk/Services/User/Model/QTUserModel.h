//
//  QTUserModel.h
//  QuickTalk
//
//  Created by  Ruibin.Chow on 2017/12/14.
//  Copyright © 2017年 www.creactism.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QTUserModel : NSObject

@property (nonatomic, copy) NSString *_id;
@property (nonatomic, copy) NSString *uuid;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *detail;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *qq;
@property (nonatomic, copy) NSString *wechat;
@property (nonatomic, copy) NSString *weibo;
@property (nonatomic, copy) NSString *area;
@property (nonatomic, assign) NSInteger gender;

+ (void)requestUserInfo:(NSString *)userUUID
      completionHandler:(void (^)(QTUserModel *userModel, NSError * error))completionHandler;

@end
