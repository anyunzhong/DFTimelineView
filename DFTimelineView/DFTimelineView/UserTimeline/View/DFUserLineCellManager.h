//
//  DFLineCellAdapterManager.h
//  DFTimelineView
//
//  Created by Allen Zhong on 15/9/27.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//

#import "DFBaseLineItem.h"
#import "DFBaseUserLineCell.h"

#import "DFTextImageUserLineItem.h"
#import "DFTextImageUserLineCell.h"

@interface DFUserLineCellManager : NSObject


+(instancetype) sharedInstance;

-(void) registerCell:(Class) itemClass cellClass:(Class ) cellClass;

-(DFBaseUserLineCell *) getCell:(Class) itemClass;


@end
