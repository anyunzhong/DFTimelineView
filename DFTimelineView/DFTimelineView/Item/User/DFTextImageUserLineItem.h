//
//  DFTextImageUserLineItem.h
//  DFTimelineView
//
//  Created by Allen Zhong on 15/10/15.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//

#import "DFBaseUserLineItem.h"

@interface DFTextImageUserLineItem : DFBaseUserLineItem

@property (nonatomic, strong) NSString *cover;

@property (nonatomic, strong) NSString *text;

@property (nonatomic, assign) NSUInteger photoCount;

@end
