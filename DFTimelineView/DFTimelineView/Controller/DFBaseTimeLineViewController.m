//
//  DFBaseTimeLineViewController.m
//  DFTimelineView
//
//  Created by Allen Zhong on 15/10/15.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//

#import "DFBaseTimeLineViewController.h"
#import <MJRefresh.h>
#import <SDCycleScrollView.h>
#import <SKTagView.h>
#import "TENSubjectShowViewController.h"

#define TableHeaderHeight 180*([UIScreen mainScreen].bounds.size.width / 375.0)
#define CoverHeight 240*([UIScreen mainScreen].bounds.size.width / 375.0)


#define AvatarSize 70*([UIScreen mainScreen].bounds.size.width / 375.0)
#define AvatarRightMargin 15
#define AvatarPadding 2


#define NickFont [UIFont systemFontOfSize:20]

#define SignFont [UIFont systemFontOfSize:11]




@interface DFBaseTimeLineViewController() <SDCycleScrollViewDelegate>

@property (nonatomic, strong) UIImageView *coverView;

@property (nonatomic, strong) UIImageView *userAvatarView;

@property (nonatomic, strong) MLLabel *userNickView;

@property (nonatomic, strong) MLLabel *userSignView;

@property (strong, nonatomic) UIRefreshControl *refreshControl;

@property (nonatomic, strong) UIView *footer;

@property (nonatomic, assign) BOOL isLoadingMore;

@property (nonatomic, strong) SDCycleScrollView *topScrollView;



@end


@implementation DFBaseTimeLineViewController



- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _isLoadingMore = NO;
        
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self initTableView];
    
    [self initMyHeader];
//    [self initHeader];
    
//    [self initFooter];
    
}



-(void) initTableView
{
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    //_tableView.backgroundColor = [UIColor darkGrayColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorInset = UIEdgeInsetsZero;
//    _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        _tableView.layoutMargins = UIEdgeInsetsZero;
    }
    [self.view addSubview:_tableView];
}

- (void) initMyHeader {
    CGFloat x,y,width, height;
    x=0;
    y=0;
    CGFloat moreShowCellHeight = 44;
    CGFloat tagViewHeight = 33;
    width = self.view.frame.size.width;
    height = TableHeaderHeight + moreShowCellHeight + 8 + tagViewHeight + 1;
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    header.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _tableView.tableHeaderView = header;
    
    _topScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(x, y, width, TableHeaderHeight) imageNamesGroup:@[@"u2_state0",@"u2_state0"]];

    _topScrollView.bannerImageViewContentMode = UIViewContentModeScaleToFill;

    [header addSubview:_topScrollView];
    
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    [cell setBackgroundColor:[UIColor whiteColor]];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    [cell setFrame:CGRectMake(x, TableHeaderHeight, width, moreShowCellHeight)];
    cell.textLabel.text = @"更多主题秀";
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickMoreSubjectShowList)];
    [cell addGestureRecognizer:tap];
    [header addSubview:cell];
    
    SKTagView *tagView = [[SKTagView alloc]initWithFrame:CGRectMake(x, TableHeaderHeight + moreShowCellHeight + 8, width, tagViewHeight)];
    [tagView setBackgroundColor:[UIColor whiteColor]];
    tagView.interitemSpacing = 8;
    tagView.preferredMaxLayoutWidth = width;
    tagView.padding = UIEdgeInsetsMake(4, 8, 4, 8);
    tagView.selectedType = SKTagViewSelectedSingle;
    [@[@"AAAA",@"BBBB",@"CCCC",@"DDDD"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        SKTag *tag = [[SKTag alloc]initWithText:obj];
        tag.textColor = [UIColor lightGrayColor];
//        tag.bgColor = [UIColor groupTableViewBackgroundColor];
        tag.cornerRadius = 3;
        tag.fontSize = 15;
        tag.borderColor = [UIColor lightGrayColor];
        tag.borderWidth = 1.f;
        tag.padding = UIEdgeInsetsMake(3.5, 10.5, 3.5, 10.5);
        tag.selectedBgColor = [UIColor redColor];
        tag.selectedTextColor = [UIColor whiteColor];

        [tagView addTag:tag];
    }];
    [header addSubview:tagView];
    
    //下拉刷新
    __weak typeof(self) _self = self;
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [_self refresh];
    }];
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [_self loadMore];
    }];

}

-(void) initHeader
{
    CGFloat x,y,width, height;
    x=0;
    y=0;
    width = self.view.frame.size.width;
    height = TableHeaderHeight;
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    header.backgroundColor = [UIColor whiteColor];
    _tableView.tableHeaderView = header;
    
    
    //封面
    height = CoverHeight;
    _coverView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    _coverView.backgroundColor = [UIColor darkGrayColor];
    
    self.coverWidth  = width*2;
    self.coverHeight = height*2;
    [header addSubview:_coverView];
    
    //用户头像
    x = self.view.frame.size.width - AvatarRightMargin - AvatarSize;
    y = header.frame.size.height - AvatarSize - 20;
    width = AvatarSize;
    height = width;
    
    UIButton *avatarBg = [[UIButton alloc] initWithFrame:CGRectMake(x, y, width, height)];
    avatarBg.backgroundColor = [UIColor whiteColor];
    avatarBg.layer.borderWidth=0.5;
    avatarBg.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [avatarBg addTarget:self action:@selector(onClickUserAvatar:) forControlEvents:UIControlEventTouchUpInside];
    [header addSubview:avatarBg];
    
    x = AvatarPadding;
    y = x;
    width = CGRectGetWidth(avatarBg.frame) - 2*AvatarPadding;
    height = width;
    _userAvatarView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    [avatarBg addSubview:_userAvatarView];
    self.userAvatarSize = width*2;
    
    
    //用户昵称
    if (_userNickView == nil) {
        _userNickView = [[MLLabel alloc] initWithFrame:CGRectZero];
        _userNickView.textColor = [UIColor whiteColor];
        _userNickView.font = NickFont;
        _userNickView.numberOfLines = 1;
        _userNickView.adjustsFontSizeToFitWidth = NO;
        [header addSubview:_userNickView];
    }
    
    
    //用户签名
    if (_userSignView== nil) {
        _userSignView = [[MLLabel alloc] initWithFrame:CGRectZero];
        _userSignView.textColor = [UIColor lightGrayColor];
        _userSignView.font = SignFont;
        _userSignView.numberOfLines = 1;
        _userSignView.adjustsFontSizeToFitWidth = NO;
        [header addSubview:_userSignView];
    }
    
    //下拉刷新
    __weak typeof(self) _self = self;
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [_self refresh];
    }];
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [_self loadMore];
    }];
    
    /**
    if (_refreshControl == nil) {
        _refreshControl = [[UIRefreshControl alloc] init];
        [_refreshControl addTarget:self action:@selector(onPullDown:) forControlEvents:UIControlEventValueChanged];
        [_tableView addSubview:self.refreshControl];
    }
     **/
}


-(void) initFooter
{
    CGFloat x,y,width, height;
    x=0;
    y=0;
    width = self.view.frame.size.width;
    height = 0.1;
    
    _footer = [[UIView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    _footer.backgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = _footer;
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    indicator.center = CGPointMake(_footer.frame.size.width/2, 30);
    indicator.hidden = YES;
    [indicator startAnimating];
    
    [_footer addSubview:indicator];
    
    
}


#pragma mark - controlAction
- (void)segmentAction:(UISegmentedControl *)segment {
    
}

#pragma mark - TableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}


#pragma mark - TabelViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}





#pragma mark - PullMoreFooterDelegate

/**
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //NSLog(@"size: %f  offset:  %f", scrollView.contentSize.height, scrollView.contentOffset.y+self.tableView.frame.size.height);
    
    if (_isLoadingMore) {
        return;
    }
    
    if (scrollView.contentOffset.y+self.tableView.frame.size.height - 30 > scrollView.contentSize.height) {
        
        [self showFooter];
    }
}
 **/


-(void) showFooter
{
    NSLog(@"show footer");
    
    CGRect frame = _tableView.tableFooterView.frame;
    CGFloat x,y,width,height;
    width = frame.size.width;
    height = 50;
    x = frame.origin.x;
    y = frame.origin.y;
    _footer.frame = CGRectMake(x, y, width, height);
    _tableView.tableFooterView = _footer;
    
    _isLoadingMore = YES;
    [self loadMore];
}


-(void) hideFooter
{
    NSLog(@"hide footer");
    
    [UIView animateWithDuration:0.5 animations:^{
        
        CGRect frame = _tableView.tableFooterView.frame;
        CGFloat x,y,width,height;
        width = frame.size.width;
        height = 0.1;
        x = frame.origin.x;
        y = frame.origin.y;
        _footer.frame = CGRectMake(x, y, width, height);
        _tableView.tableFooterView = _footer;
        
        _isLoadingMore = NO;
        
    }];
    
}


-(void) onPullDown:(id) sender
{
    [self refresh];
}


-(void) refresh
{
}

-(void) loadMore
{
}


-(void)endLoadMore
{
    [self.tableView.mj_footer endRefreshing];
//    [self hideFooter];
}

- (void)endLoadMoreWithNoMoreData
{
    [self.tableView.mj_footer endRefreshingWithNoMoreData];
}

-(void)endRefresh
{
    [self.tableView.mj_header endRefreshing];
//    [_refreshControl endRefreshing];
}

- (void)clickMoreSubjectShowList {
    [self.navigationController pushViewController:[TENSubjectShowViewController new] animated:YES];
}


#pragma mark - Method


-(void)setCover:(NSString *)url
{
    [_coverView sd_setImageWithURL:[NSURL URLWithString:url]];
}

-(void)setUserAvatar:(NSString *)url
{
    [_userAvatarView sd_setImageWithURL:[NSURL URLWithString:url]];
}

-(void)setUserNick:(NSString *)nick
{
    CGFloat x, y, width, height;
    
    CGSize size = [MLLabel getViewSizeByString:nick font:NickFont];
    width = size.width;
    height = size.height;
    x = CGRectGetMinX(_userAvatarView.superview.frame) - width - 5;
    y = CGRectGetMidY(_userAvatarView.superview.frame) - height - 2;
    _userNickView.frame = CGRectMake(x, y, width, height);
    _userNickView.text = nick;
}


-(void)setUserSign:(NSString *)sign
{
    CGFloat x, y, width, height;
    
    CGSize size = [MLLabel getViewSizeByString:sign font:SignFont];
    width = size.width;
    height = size.height;
    x = CGRectGetWidth(self.view.frame) - width - 15;
    y = CGRectGetMaxY(_userAvatarView.superview.frame) + 5;
    _userSignView.frame = CGRectMake(x, y, width, height);
    _userSignView.text = sign;
}




-(void) onClickUserAvatar:(id) sender
{
    [self onClickHeaderUserAvatar];
}


-(void)onClickHeaderUserAvatar
{
    
}



@end
