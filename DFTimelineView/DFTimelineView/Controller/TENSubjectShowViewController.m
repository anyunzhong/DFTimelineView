//
//  TENSubjectShowViewController.m
//  DFTimelineView
//
//  Created by 刘一智 on 16/7/20.
//  Copyright © 2016年 Datafans, Inc. All rights reserved.
//  这个可作为父类做主题秀列表

#import "TENSubjectShowViewController.h"

@interface TENSubjectShowViewController ()


@end

@implementation TENSubjectShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"话题秀";
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

#pragma mark -
- (void)refresh {
    
}

- (void)loadMore {
    
}

- (void)setCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath {
    if ([cell isKindOfClass:[SubjectShowTableViewCell class]]) {
        [(SubjectShowTableViewCell *)cell setData:self.datas[indexPath.row]];
    }
}

- (NSString *)cellClass {
    return @"SubjectShowTableViewCell";
}

@end
