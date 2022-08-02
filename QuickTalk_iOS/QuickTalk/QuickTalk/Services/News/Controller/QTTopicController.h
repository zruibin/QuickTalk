//
//  QTTopicController.h
//  QuickTalk
//
//  Created by  Ruibin.Chow on 2017/10/16.
//  Copyright © 2017年 www.creactism.com. All rights reserved.
//

#import "QTViewController.h"

@class QTTopicModel;

@interface QTTopicController : QTViewController

@property (nonatomic, copy) NSString *topicUUID;
@property (nonatomic, strong) QTTopicModel *model;

@end
