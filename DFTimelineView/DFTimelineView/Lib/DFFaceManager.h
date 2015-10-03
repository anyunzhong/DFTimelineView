//
//  DFPluginsManager.h
//  DFWeChatView
//
//  Created by Allen Zhong on 15/4/19.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//

#import "MLExpressionManager.h"



@interface DFFaceManager : NSObject


+(instancetype) sharedInstance;

-(MLExpression *) sharedMLExpression;

@end
