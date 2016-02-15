//
//  DFTextImageLineItem.m
//  DFTimelineView
//
//  Created by Allen Zhong on 15/9/27.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//

#import "DFTextImageLineItem.h"

@implementation DFTextImageLineItem

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _text = @"";
        _thumbImages = [NSMutableArray array];
        _srcImages = [NSMutableArray array];
    }
    return self;
}
@end
