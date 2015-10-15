//
//  DFBaseUserLineCellAdapter.m
//  DFTimelineView
//
//  Created by Allen Zhong on 15/10/15.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//

#import "DFBaseUserLineCellAdapter.h"

@implementation DFBaseUserLineCellAdapter

-(CGFloat)getCellHeight:(DFBaseUserLineItem *)item
{
    return 0.0;
}

-(UITableViewCell *)getCell:(UITableView *)tableView
{
    return nil;
}

-(void)updateCell:(UITableViewCell *)cell message:(DFBaseUserLineItem *)item
{
    
}

@end
