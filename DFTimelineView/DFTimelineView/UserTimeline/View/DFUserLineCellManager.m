//
//  DFLineCellAdapterManager.m
//  DFTimelineView
//
//  Created by Allen Zhong on 15/9/27.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//

#import "DFUserLineCellManager.h"

@interface DFUserLineCellManager()

@property (strong, nonatomic) NSMutableDictionary *dic;

@end



@implementation DFUserLineCellManager

static DFUserLineCellManager  *_manager=nil;


#pragma mark - Lifecycle

+(instancetype) sharedInstance
{
    @synchronized(self){
        if (_manager == nil) {
            _manager = [[DFUserLineCellManager alloc] init];
        }
    }
    return _manager;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        _dic = [NSMutableDictionary dictionary];
        
        [self registerCell:[DFTextImageUserLineItem class] cellClass:[DFTextImageUserLineCell class]];
    }
    return self;
}



#pragma mark - Method


-(void) registerCell:(Class) itemClass cellClass:(Class) cellClass
{
    [_dic setObject:[[cellClass alloc] init]  forKey:NSStringFromClass(itemClass)];
}


-(DFBaseUserLineCell *) getCell:(Class) itemClass
{
    return [_dic objectForKey:NSStringFromClass(itemClass)];
}


@end
