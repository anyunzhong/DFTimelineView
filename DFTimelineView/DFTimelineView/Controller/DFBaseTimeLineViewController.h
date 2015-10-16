//
//  DFBaseTimeLineViewController.h
//  DFTimelineView
//
//  Created by Allen Zhong on 15/10/15.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//

#import "UIImageView+WebCache.h"
#import <MLLabel+Size.h>


@interface DFBaseTimeLineViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;


-(void) endLoadMore;

-(void) endRefresh;


-(void) onClickHeaderUserAvatar;


@end
