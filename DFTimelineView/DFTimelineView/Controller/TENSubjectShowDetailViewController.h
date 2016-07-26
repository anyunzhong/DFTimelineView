//
//  TENSubjectShowDetailViewController.h
//  DFTimelineView
//
//  Created by 刘一智 on 16/7/20.
//  Copyright © 2016年 Datafans, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Masonry.h>
#import "DFTextImageLineCell.h"
#import "DFTextImageLineItem.h"
#import <MJRefresh.h>
#import "TENBaseTimelineTableViewController.h"
#import "DFLineCellManager.h"

#import "DFBaseTimeLineViewController.h"

@interface TENSubjectShowDetailViewController : DFBaseTimeLineViewController

@property (nonatomic, strong) NSNumber *itemID;

@end
