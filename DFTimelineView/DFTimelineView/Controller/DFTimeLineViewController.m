//
//  DFTimeLineViewController.m
//  DFTimelineView
//
//  Created by Allen Zhong on 15/9/27.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//

#import "DFTimeLineViewController.h"
#import "DFLineCellAdapterManager.h"

#import "DFTextImageLineCellAdapter.h"
#import "DFBaseLineCell.h"
#import "DFLineLikeItem.h"
#import "DFLineCommentItem.h"
#import "UIImageView+WebCache.h"
#import <MLLabel+Size.h>



#define TableHeaderHeight 270*([UIScreen mainScreen].bounds.size.width / 375.0)
#define CoverHeight 240*([UIScreen mainScreen].bounds.size.width / 375.0)


#define AvatarSize 70*([UIScreen mainScreen].bounds.size.width / 375.0)
#define AvatarRightMargin 15
#define AvatarPadding 2


#define NickFont [UIFont systemFontOfSize:20]

@interface DFTimeLineViewController ()<DFLineCellDelegate>

@property (nonatomic, strong) NSMutableArray *items;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIImageView *cover;

@property (nonatomic, strong) UIImageView *userAvatar;

@property (nonatomic, strong) MLLabel *userNick;

@property (strong, nonatomic) UIRefreshControl *refreshControl;

@property (nonatomic, strong) UIView *footer;

@property (nonatomic, assign) BOOL isLoadingMore;



@end

@implementation DFTimeLineViewController



- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _items = [NSMutableArray array];
        
        _isLoadingMore = NO;
        
        DFLineCellAdapterManager *manager = [DFLineCellAdapterManager sharedInstance];
        
        DFTextImageLineCellAdapter *textImageCellAdapter = [[DFTextImageLineCellAdapter alloc] init];
        [manager registerAdapter:LineItemTypeTextImage adapter:textImageCellAdapter];
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initTableView];
    
    [self initHeader];
    
    [self initFooter];
    
}


-(void) initTableView
{
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    //_tableView.backgroundColor = [UIColor darkGrayColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorInset = UIEdgeInsetsZero;
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        _tableView.layoutMargins = UIEdgeInsetsZero;
    }
    [self.view addSubview:_tableView];
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
    _cover = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    
    //这里可以根据scale来获取相应尺寸的图片 图片可能比较大 加载慢
    NSString *url = [self getCoverUrl:width*2 height:height*2];
    [_cover sd_setImageWithURL:[NSURL URLWithString:url]];
    [header addSubview:_cover];
    
    //用户头像
    x = self.view.frame.size.width - AvatarRightMargin - AvatarSize;
    y = header.frame.size.height - AvatarSize;
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
    _userAvatar = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    [avatarBg addSubview:_userAvatar];
    [_userAvatar sd_setImageWithURL:[NSURL URLWithString:[self getAvatarUrl:width*2 height:height*2]]];
    
    //用户昵称
    if (_userNick == nil) {
        NSString *nick = [self getUserNick];
        if (nick != nil) {
            CGSize size = [MLLabel getViewSizeByString:nick font:NickFont];
            width = size.width;
            height = size.height;
            x = CGRectGetMinX(avatarBg.frame) - width - 5;
            y = CGRectGetMidY(avatarBg.frame) - height - 2;
            _userNick = [[MLLabel alloc] initWithFrame:CGRectMake(x, y, width, height)];
            _userNick.textColor = [UIColor whiteColor];
            _userNick.text = nick;
            _userNick.font = NickFont;
            _userNick.numberOfLines = 1;
            _userNick.adjustsFontSizeToFitWidth = NO;
            _userNick.textInsets = UIEdgeInsetsZero;
            
            [header addSubview:_userNick];
        }
        
    }
    
    
    //下拉刷新
    if (_refreshControl == nil) {
        _refreshControl = [[UIRefreshControl alloc] init];
        [_refreshControl addTarget:self action:@selector(onPullDown:) forControlEvents:UIControlEventValueChanged];
        [_tableView addSubview:self.refreshControl];
    }
    
    
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _items.count;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DFBaseLineItem *item = [_items objectAtIndex:indexPath.row];
    DFBaseLineCellAdapter *adapter = [self getAdapter:item.itemType];
    return [adapter getCellHeight:item];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DFBaseLineItem *item = [_items objectAtIndex:indexPath.row];
    DFBaseLineCellAdapter *adapter = [self getAdapter:item.itemType];
    
    UITableViewCell *cell = [adapter getCell:tableView];
    
    ((DFBaseLineCell *)cell).delegate = self;
    
    cell.separatorInset = UIEdgeInsetsZero;
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        cell.layoutMargins = UIEdgeInsetsZero;
    }
    [adapter updateCell:cell message:item];
    
    return cell;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //点击所有cell空白地方 隐藏toolbar
    NSInteger rows =  [tableView numberOfRowsInSection:0];
    for (int row = 0; row < rows; row++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
        DFBaseLineCell *cell  = (DFBaseLineCell *)[tableView cellForRowAtIndexPath:indexPath];
        [cell hideLikeCommentToolbar];
    }
}


#pragma mark - Method

-(DFBaseLineCellAdapter *) getAdapter:(LineItemType)itemType
{
    DFLineCellAdapterManager *manager = [DFLineCellAdapterManager sharedInstance];
    return [manager getAdapter:itemType];
}

-(void)addItem:(DFBaseLineItem *)item
{
    [self genLikeAttrString:item];
    [self genCommentAttrString:item];
    
    [_items addObject:item];
    [_tableView reloadData];
}



-(void) onClickUserAvatar:(id) sender
{
    [self onClickUserAvatar];
}



#pragma mark - DFLineCellDelegate

-(void)onComment:(long long)itemId
{
    
}


-(void)onLike:(long long)itemId
{
    
}

-(void)onClickUser:(NSUInteger)userId
{
    
}


-(void)onClickUserAvatar
{
    
}




#pragma mark - PullMoreFooterDelegate


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
    [self hideFooter];
}

-(void)endRefresh
{
    [_refreshControl endRefreshing];
}



#pragma mark - Method




-(NSString *) getCoverUrl:(CGFloat) width height:(CGFloat) height
{
    return nil;
}


-(NSString *) getAvatarUrl:(CGFloat) width height:(CGFloat) height
{
    return nil;
}



-(NSString *) getUserNick
{
    return nil;
}


-(void) genLikeAttrString:(DFBaseLineItem *) item
{
    if (item.likes.count == 0) {
        return;
    }
    
    if (item.likesStr == nil) {
        NSMutableArray *likes = item.likes;
        NSString *result = @"";
        
        for (int i=0; i<likes.count;i++) {
            DFLineLikeItem *like = [likes objectAtIndex:i];
            if (i == 0) {
                result = [NSString stringWithFormat:@"%@",like.userNick];
            }else{
                result = [NSString stringWithFormat:@"%@, %@", result, like.userNick];
            }
        }
        
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:result];
        NSUInteger position = 0;
        for (int i=0; i<likes.count;i++) {
            DFLineLikeItem *like = [likes objectAtIndex:i];
            [attrStr addAttribute:NSLinkAttributeName value:[NSString stringWithFormat:@"%lu", (unsigned long)like.userId] range:NSMakeRange(position, like.userNick.length)];
            position += like.userNick.length+2;
        }
        
        item.likesStr = attrStr;
    }
    
}

-(void) genCommentAttrString:(DFBaseLineItem *)item
{
    NSMutableArray *comments = item.comments;
    
    for (int i=0; i<comments.count;i++) {
        DFLineCommentItem *comment = [comments objectAtIndex:i];
        
        NSString *resultStr;
        if (comment.replyUserId == 0) {
            resultStr = [NSString stringWithFormat:@"%@: %@",comment.userNick, comment.text];
        }else{
            resultStr = [NSString stringWithFormat:@"%@回复%@: %@",comment.userNick, comment.replyUserNick, comment.text];
        }
        
        NSMutableAttributedString *commentStr = [[NSMutableAttributedString alloc]initWithString:resultStr];
        if (comment.replyUserId == 0) {
            [commentStr addAttribute:NSLinkAttributeName value:[NSString stringWithFormat:@"%lu", (unsigned long)comment.userId] range:NSMakeRange(0, comment.userNick.length)];
        }else{
            NSUInteger localPos = 0;
            [commentStr addAttribute:NSLinkAttributeName value:[NSString stringWithFormat:@"%lu", (unsigned long)comment.userId] range:NSMakeRange(localPos, comment.userNick.length)];
            localPos += comment.userNick.length + 2;
            [commentStr addAttribute:NSLinkAttributeName value:[NSString stringWithFormat:@"%lu", (unsigned long)comment.replyUserId] range:NSMakeRange(localPos, comment.replyUserNick.length)];
        }
        
        NSLog(@"ffff: %@", resultStr);
        
        [item.commentStrArray addObject:commentStr];
    }
}



@end
