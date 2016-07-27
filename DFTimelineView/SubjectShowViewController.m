//
//  SubjectShowViewController.m
//  DFTimelineView
//
//  Created by 刘一智 on 16/7/27.
//  Copyright © 2016年 Datafans, Inc. All rights reserved.
//

#import "SubjectShowViewController.h"
#import "SubjectShowListViewController.h"

@interface SubjectShowViewController ()

@end

@implementation SubjectShowViewController

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SubjectShowListViewController *controller = [[SubjectShowListViewController alloc]init];
    [self.navigationController pushViewController:controller animated:YES];
}

@end
