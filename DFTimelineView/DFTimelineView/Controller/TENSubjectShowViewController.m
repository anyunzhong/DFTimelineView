//
//  TENSubjectShowViewController.m
//  DFTimelineView
//
//  Created by 刘一智 on 16/7/20.
//  Copyright © 2016年 Datafans, Inc. All rights reserved.
//  这个可作为父类做主题秀列表

#import "TENSubjectShowViewController.h"
#import "TENSubjectShowDetailViewController.h"
#import "DFTimeLineViewController.h"

@interface TENSubjectShowViewController ()


@end

@implementation TENSubjectShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"话题秀";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

#pragma mark - tableDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationController pushViewController:[DFTimeLineViewController new] animated:YES];
}

#pragma mark -
//刷新
- (void)refresh {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView.mj_header endRefreshing];
    });
}

//加载更多
- (void)loadMore {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView.mj_footer endRefreshing];
    });
}

- (void)setCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath {
    if ([cell isKindOfClass:[SubjectShowTableViewCell class]]) {
        [(SubjectShowTableViewCell *)cell setData:self.datas[indexPath.row]];
    }
}

//设置cell类
- (NSString *)cellClass {
    return @"SubjectShowTableViewCell";
}

@end
