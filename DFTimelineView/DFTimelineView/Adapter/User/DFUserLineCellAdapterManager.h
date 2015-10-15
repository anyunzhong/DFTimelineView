//
//  DFUserLineCellAdapterManager.h
//  DFTimelineView
//
//  Created by Allen Zhong on 15/10/15.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//

#import "DFBaseUserLineItem.h"
#import "DFBaseUserLineCellAdapter.h"

@interface DFUserLineCellAdapterManager : NSObject

+(instancetype) sharedInstance;

-(void) registerAdapter:(UserLineItemType) itemType adapter:(DFBaseUserLineCellAdapter *) adapter;

-(DFBaseUserLineCellAdapter *) getAdapter:(UserLineItemType) itemType;


@end
