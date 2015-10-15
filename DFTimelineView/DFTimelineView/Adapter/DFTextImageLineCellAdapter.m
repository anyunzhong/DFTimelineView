//
//  DFTextImageLineCellAdapter.m
//  DFTimelineView
//
//  Created by Allen Zhong on 15/9/27.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//

#import "DFTextImageLineCellAdapter.h"
#import "DFTextImageLineCell.h"

#define TextImageCell @"timeline_cell_text_image"

@implementation DFTextImageLineCellAdapter

-(CGFloat) getCellHeightByCount:(DFBaseLineItem *)item
{
    return [DFTextImageLineCell getCellHeight:item];
}


-(UITableViewCell *)getCell:(UITableView *)tableView
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TextImageCell];
    if (cell == nil ) {
        cell = [[DFTextImageLineCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TextImageCell];
    }
    
    return cell;
}

-(void)updateCell:(DFBaseLineCell *)cell message:(DFBaseLineItem *)item
{
    [cell updateWithItem:item];
}


@end
