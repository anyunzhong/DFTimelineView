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
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.tableView = [[UITableView alloc]init];
    if (!self.cellClass || self.cellClass.length <= 0) {
        self.cellClass = NSStringFromClass([UITableViewCell class]);
    }
    Class class111 = NSClassFromString(self.cellClass);
    Class class = NSClassFromString(self.cellClass);
    if ([NSClassFromString(self.cellClass) isSubclassOfClass:[UITableViewCell class]]) {
        [self.tableView registerClass:NSClassFromString(self.cellClass) forCellReuseIdentifier:self.cellClass];
    }
    
    self.tableView.estimatedRowHeight = 200.f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [_self refresh];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [_self loadMore];
    }];
    [self.view addSubview:self.tableView];

    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.tableView reloadData];
}

#pragma mark - tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return _datas.count;
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id cell = [tableView dequeueReusableCellWithIdentifier:self.cellClass];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self respondsToSelector:@selector(setCell:indexPath:)]) {
        [self setCell:cell indexPath:indexPath];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.f;
}

#pragma mark - 子类实现方法
- (NSString *)cellClass {
    return @"";
}

- (void)refresh {
    
}

- (void)loadMore {
    
}

- (void)setCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath {

}

@end
