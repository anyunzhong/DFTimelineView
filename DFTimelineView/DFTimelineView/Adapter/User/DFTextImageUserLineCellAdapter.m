//
//  DFTextImageUserLineCellAdapter.m
//  DFTimelineView
//
//  Created by Allen Zhong on 15/10/15.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//

#import "DFTextImageUserLineCellAdapter.h"
#import "DFTextImageUserLineCell.h"

#define TextImageUserCell @"timeline_user_cell_text_image"

@implementation DFTextImageUserLineCellAdapter


-(CGFloat) getCellHeight:(DFBaseUserLineItem *)item
{
    return [DFTextImageUserLineCell getCellHeight:item];
}


-(UITableViewCell *)getCell:(UITableView *)tableView
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TextImageUserCell];
    if (cell == nil ) {
        cell = [[DFTextImageUserLineCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TextImageUserCell];
    }
    
    return cell;
}

-(void)updateCell:(DFBaseUserLineCell *)cell message:(DFTextImageUserLineItem *)item
{
    [cell updateWithItem:item];
}



@end
