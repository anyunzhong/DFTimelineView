//
//  TENBaseTimelineTableViewController.h
//  DFTimelineView
//
//  Created by 刘一智 on 16/7/20.
//  Copyright © 2016年 Datafans, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Masonry.h>
#import <MJRefresh.h>
#import "DFTextImageLineCell.h"

@interface TENBaseTimelineTableViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic) UITableView *tableView;
@property (nonatomic) NSArray *datas;

@property (nonatomic) NSString *cellClass;

- (void)refresh;
- (void)loadMore;
- (void)setCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath;

@end
