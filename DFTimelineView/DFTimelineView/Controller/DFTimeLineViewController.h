//
//  DFTimeLineViewController.h
//  DFTimelineView
//
//  Created by Allen Zhong on 15/9/27.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//

#import "DFBaseLineItem.h"

@interface DFTimeLineViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

-(void) addItem:(DFBaseLineItem *) item;


-(void) endLoadMore;

-(void) endRefresh;


@end
