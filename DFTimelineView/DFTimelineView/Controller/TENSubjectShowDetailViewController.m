//
//  TENSubjectShowDetailViewController.m
//  DFTimelineView
//
//  Created by 刘一智 on 16/7/20.
//  Copyright © 2016年 Datafans, Inc. All rights reserved.
//

#import "TENSubjectShowDetailViewController.h"

@interface TENSubjectShowDetailViewController ()

@end

@implementation TENSubjectShowDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}


#pragma mark - tableViewDelegate
//重载
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DFBaseLineItem *item = [self.datas objectAtIndex:indexPath.row];
    DFBaseLineCell *typeCell = [self getCell:[item class]];
    
    NSString *reuseIdentifier = NSStringFromClass([typeCell class]);
    DFBaseLineCell *cell = [tableView dequeueReusableCellWithIdentifier: reuseIdentifier];
    if (cell == nil ) {
        cell = [[[typeCell class] alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }else{
        NSLog(@"重用Cell: %@", reuseIdentifier);
    }
    
    cell.delegate = self;
    
    cell.separatorInset = UIEdgeInsetsZero;
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        cell.layoutMargins = UIEdgeInsetsZero;
    }
    [cell updateWithItem:item];
    
    return cell;
}

#pragma mark -
-(DFBaseLineCell *) getCell:(Class)itemClass
{
    DFLineCellManager *manager = [DFLineCellManager sharedInstance];
    return [manager getCell:itemClass];
}

#pragma mark -
- (void)refresh {
    
}

- (void)loadMore {
    
}

- (void)setCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath {
    DFTextImageLineCell *thisCell = (DFTextImageLineCell *)cell;
    [thisCell updateWithItem:self.datas[indexPath.row]];
    thisCell.delegate = self;
}

- (NSString *)cellClass {
    return @"DFTextImageLineCell";
}

@end
