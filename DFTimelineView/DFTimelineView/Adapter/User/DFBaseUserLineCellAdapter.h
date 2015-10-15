//
//  DFBaseUserLineCellAdapter.h
//  DFTimelineView
//
//  Created by Allen Zhong on 15/10/15.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//

#import "DFBaseUserLineItem.h"

@interface DFBaseUserLineCellAdapter : NSObject


-(CGFloat) getCellHeight:(DFBaseUserLineItem *) item;

-(UITableViewCell *) getCell:(UITableView *) tableView;

-(void) updateCell:(UITableViewCell *) cell message:(DFBaseUserLineItem *)item;


@end
