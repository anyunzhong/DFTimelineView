//
//  DFVideoLineCellAdapter.m
//  DFTimelineView
//
//  Created by Allen Zhong on 16/2/15.
//  Copyright © 2016年 Datafans, Inc. All rights reserved.
//

#import "DFVideoLineCellAdapter.h"
#import "DFVideoLineCell.h"

#define VideoCell @"timeline_cell_video"

@implementation DFVideoLineCellAdapter

-(CGFloat) getCellHeightByCount:(DFBaseLineItem *)item
{
    return [DFVideoLineCell getCellHeight:item];
}


-(UITableViewCell *)getCell:(UITableView *)tableView
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:VideoCell];
    if (cell == nil ) {
        cell = [[DFVideoLineCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:VideoCell];
    }
    
    return cell;
}




@end
