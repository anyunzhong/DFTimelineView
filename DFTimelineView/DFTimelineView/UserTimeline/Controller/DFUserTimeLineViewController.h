//
//  DFUserTimeLineViewController.h
//  DFTimelineView
//
//  Created by Allen Zhong on 15/10/15.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//
#import "DFBaseTimeLineViewController.h"

#import "DFBaseUserLineItem.h"

@interface DFUserTimeLineViewController: DFBaseTimeLineViewController


-(void)addItem:(DFBaseUserLineItem *)item;

@end
