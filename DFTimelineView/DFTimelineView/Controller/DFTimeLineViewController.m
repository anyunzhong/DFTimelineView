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


@interface DFTimeLineViewController ()<DFLineCellDelegate>

@property (nonatomic, strong) NSMutableArray *items;

@property (nonatomic, strong) UITableView *tableView;


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
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorInset = UIEdgeInsetsZero;
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        _tableView.layoutMargins = UIEdgeInsetsZero;
    }
    [self.view addSubview:_tableView];
    
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





-(void)onComment:(long long)itemId
{
    
}


-(void)onLike:(long long)itemId
{
    
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
