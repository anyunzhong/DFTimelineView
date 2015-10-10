//
//  DFBaseLineItem.m
//  DFTimelineView
//
//  Created by Allen Zhong on 15/9/27.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//

#import "DFBaseLineItem.h"

@implementation DFBaseLineItem

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _likes = [NSMutableArray array];
        _comments = [NSMutableArray array];
        
        _commentStrArray = [NSMutableArray array];
    }
    return self;
}
@end
