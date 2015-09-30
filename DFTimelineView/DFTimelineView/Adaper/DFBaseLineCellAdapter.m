//
//  DFBaseLineCellAdapter.m
//  DFTimelineView
//
//  Created by Allen Zhong on 15/9/27.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//

#import "DFBaseLineCellAdapter.h"

@implementation DFBaseLineCellAdapter

-(CGFloat)getCellHeight:(DFBaseLineItem *)item
{
    if (item.cellHeight != 0) {
        NSLog(@"直接获取高度 %f", item.cellHeight);
        return item.cellHeight;
    }
    CGFloat height = [self getCellHeightByCount:item];
    item.cellHeight = height;
    NSLog(@"计算获取高度 %f", item.cellHeight);
    
    return height;
}

-(CGFloat) getCellHeightByCount:(DFBaseLineItem *)item
{
    return 0.0;
}


-(UITableViewCell *)getCell:(UITableView *)tableView
{
    return nil;
}

-(void)updateCell:(UITableViewCell *)cell message:(DFBaseLineItem *)item
{
    
}

@end
