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


#define TableHeaderHeight 270*([UIScreen mainScreen].bounds.size.width / 375.0)
#define CoverHeight 240*([UIScreen mainScreen].bounds.size.width / 375.0)


#define AvatarSize 70*([UIScreen mainScreen].bounds.size.width / 375.0)
#define AvatarRightMargin 15
#define AvatarPadding 2

@interface DFTimeLineViewController ()<DFLineCellDelegate>

@property (nonatomic, strong) NSMutableArray *items;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIImageView *cover;


@property (nonatomic, strong) UIImageView *userAvatar;


@end

@implementation DFTimeLineViewController



- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _items = [NSMutableArray array];
        
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
    
}


-(void) initTableView
{
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor darkGrayColor];
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





-(NSString *) getCoverUrl:(CGFloat) width height:(CGFloat) height
{
    return nil;
}


-(NSString *) getAvatarUrl:(CGFloat) width height:(CGFloat) height
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
    if (item.commentsStr== nil) {
        NSMutableArray *comments = item.comments;
        NSString *result = @"";
        
        for (int i=0; i<comments.count;i++) {
            DFLineCommentItem *comment = [comments objectAtIndex:i];
            if (comment.replyUserId == 0) {
                if (i == 0) {
                    result = [NSString stringWithFormat:@"%@: %@",comment.userNick, comment.text];
                }else{
                    result = [NSString stringWithFormat:@"%@\n%@: %@", result, comment.userNick,  comment.text];
                }
            }else{
                if (i == 0) {
                    result = [NSString stringWithFormat:@"%@回复%@: %@",comment.userNick, comment.replyUserNick, comment.text];
                }else{
                    result = [NSString stringWithFormat:@"%@\n%@回复%@: %@", result, comment.userNick, comment.replyUserNick,  comment.text];
                }
            }
            
            NSLog(@"result: %@", result);
            
        }
        
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:result];
        NSUInteger position = 0;
        for (int i=0; i<comments.count;i++) {
            DFLineCommentItem *comment = [comments objectAtIndex:i];
            if (comment.replyUserId == 0) {
                [attrStr addAttribute:NSLinkAttributeName value:[NSString stringWithFormat:@"%lu", (unsigned long)comment.userId] range:NSMakeRange(position, comment.userNick.length)];
                position += comment.userNick.length + comment.text.length + 3;
            }else{
                [attrStr addAttribute:NSLinkAttributeName value:[NSString stringWithFormat:@"%lu", (unsigned long)comment.userId] range:NSMakeRange(position, comment.userNick.length)];
                position += comment.userNick.length + 2;
                [attrStr addAttribute:NSLinkAttributeName value:[NSString stringWithFormat:@"%lu", (unsigned long)comment.replyUserId] range:NSMakeRange(position, comment.replyUserNick.length)];
                position += comment.text.length + comment.replyUserNick.length + 3;
            }
            
        }
        
        item.commentsStr = attrStr;
    }
    
}



@end
