//
//  DFLineCellAdapterManager.h
//  DFTimelineView
//
//  Created by Allen Zhong on 15/9/27.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//

#import "DFBaseLineItem.h"
#import "DFBaseLineCellAdapter.h"

@interface DFLineCellAdapterManager : NSObject


+(instancetype) sharedInstance;

-(void) registerAdapter:(LineItemType) itemType adapter:(DFBaseLineCellAdapter *) adapter;

-(DFBaseLineCellAdapter *) getAdapter:(LineItemType) itemType;


@end
