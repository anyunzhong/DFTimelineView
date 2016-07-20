//
//  TENBaseTimelineTableViewController.m
//  DFTimelineView
//
//  Created by 刘一智 on 16/7/20.
//  Copyright © 2016年 Datafans, Inc. All rights reserved.
//

#import "TENBaseTimelineTableViewController.h"

@interface TENBaseTimelineTableViewController ()


@end

@implementation TENBaseTimelineTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    __weak typeof(self) _self = self;
    self.tableView = [[UITableView alloc]init];
    if (self.cellClass) {
        [self.tableView registerClass:NSClassFromString(self.cellClass) forCellReuseIdentifier:self.cellClass];
    } else {
        
    }
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [_self refresh];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [_self loadMore];
    }];
    [self.tableView addSubview:self.view];

    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id cell = [tableView dequeueReusableCellWithIdentifier:self.cellClass ? : @"cell"];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self respondsToSelector:@selector(setCell:indexPath:)]) {
        [self setCell:cell indexPath:indexPath];
    }
}

#pragma mark - 子类实现方法
- (NSString *)cellClass {
    return nil;
}

- (void)refresh {
    
}

- (void)loadMore {
    
}

- (void)setCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath {
    
}

@end
