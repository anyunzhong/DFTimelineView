//
//  DFUserLineCellAdapterManager.m
//  DFTimelineView
//
//  Created by Allen Zhong on 15/10/15.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//

#import "DFUserLineCellAdapterManager.h"

@interface DFUserLineCellAdapterManager()

@property (strong, nonatomic) NSMutableDictionary *dic;

@end


@implementation DFUserLineCellAdapterManager


static DFUserLineCellAdapterManager  *_manager=nil;


#pragma mark - Lifecycle

+(instancetype) sharedInstance
{
    @synchronized(self){
        if (_manager == nil) {
            _manager = [[DFUserLineCellAdapterManager alloc] init];
        }
    }
    return _manager;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        _dic = [NSMutableDictionary dictionary];
    }
    return self;
}



#pragma mark - Method


-(void) registerAdapter:(UserLineItemType) itemType adapter:(DFBaseUserLineCellAdapter *) adapter{
    [_dic setObject:adapter forKey:[NSNumber numberWithInteger:itemType]];
}


-(DFBaseUserLineCellAdapter *) getAdapter:(UserLineItemType) itemType
{
    return [_dic objectForKey:[NSNumber numberWithInteger:itemType]];
}



@end
