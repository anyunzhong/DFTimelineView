//
//  DFBaseLineCell.m
//  DFTimelineView
//
//  Created by Allen Zhong on 15/9/27.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//





#define UserNickFont [UIFont systemFontOfSize:16]
#define TitleLabelFont [UIFont systemFontOfSize:13]

#define LocationLabelFont [UIFont systemFontOfSize:10]

#define TimeLabelFont [UIFont systemFontOfSize:12]

//#define UserNickLabelHeight 15
#define UserNickMaxWidth 150

#define LocationLabelHeight 15

#define TimeLabelHeight 15

#define UserNickLineHeight 1.0f


#define LikeLabelFont [UIFont systemFontOfSize:14]

#define LikeLabelLineHeight 1.1f

#define LikeCommentTimeSpace 3

#define ToolbarWidth 150
#define ToolbarHeight 30

#import "DFBaseLineCell.h"
#import "MLLabel+Size.h"
#import "DFLikeCommentView.h"
#import "DFLikeCommentToolbar.h"
#import "DFToolUtil.h"


@interface DFBaseLineCell()<DFLikeCommentToolbarDelegate, DFLikeCommentViewDelegate>


@property (nonatomic, strong) DFBaseLineItem *item;

@property (nonatomic, strong) UIImageView *userAvatarView;
@property (nonatomic, strong) UIButton *userAvatarButton;

@property (nonatomic, strong) MLLinkLabel *userNickLabel;

@property (nonatomic, strong) UILabel *titleLabel;


@property (nonatomic, strong) UILabel *locationLabel;

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UIButton *likeCmtButton;



@property (nonatomic, strong) DFLikeCommentView *likeCommentView;


@property (nonatomic, strong) DFLikeCommentToolbar *likeCommentToolbar;


@property (nonatomic, assign) BOOL isLikeCommentToolbarShow;

@end



@implementation DFBaseLineCell


#pragma mark - Lifecycle
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _isLikeCommentToolbarShow = NO;
        
        [self initBaseCell];
    }
    return self;
}

-(void) initBaseCell
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    CGFloat x = 0.0, y, width, height;
    
    if (_userAvatarView == nil ) {
        
        x = Margin;
        y = Margin;
        width = UserAvatarSize;
        height = width;
        _userAvatarView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height)];
        _userAvatarView.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_userAvatarView];
        
        _userAvatarButton = [[UIButton alloc] initWithFrame:_userAvatarView.frame];
        [_userAvatarButton addTarget:self action:@selector(onClickUserAvatar:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_userAvatarButton];
    }
    
    if (_userNickLabel == nil) {
        
        _userNickLabel =[[MLLinkLabel alloc] initWithFrame:CGRectZero];
        _userNickLabel.textColor = HighLightTextColor;
        _userNickLabel.font = UserNickFont;
        _userNickLabel.numberOfLines = 1;
        _userNickLabel.adjustsFontSizeToFitWidth = NO;
        _userNickLabel.textInsets = UIEdgeInsetsZero;
        
        _userNickLabel.dataDetectorTypes = MLDataDetectorTypeAll;
        _userNickLabel.allowLineBreakInsideLinks = NO;
        _userNickLabel.linkTextAttributes = nil;
        _userNickLabel.activeLinkTextAttributes = nil;
        _userNickLabel.lineHeightMultiple = UserNickLineHeight;
        [self.contentView addSubview:_userNickLabel];
    }
    
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.textColor = [UIColor lightGrayColor];
        _titleLabel.font = TitleLabelFont;
        [self.contentView addSubview:_titleLabel];
    }
    
    if (_bodyView == nil) {
        x = CGRectGetMaxX(_userAvatarView.frame) + Margin;
        y = 40;
        width = BodyMaxWidth;
        height = 1;
        _bodyView = [[UIView alloc] initWithFrame:CGRectMake(x, y, width, height)];
        [self.contentView addSubview:_bodyView];
    }
    
    
    
    if (_locationLabel == nil) {
        _locationLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _locationLabel.textColor = [UIColor colorWithRed:35/255.0 green:83/255.0 blue:120/255.0 alpha:1.0];
        _locationLabel.font = LocationLabelFont;
        _locationLabel.hidden = YES;
        [self.contentView addSubview:_locationLabel];
    }
    
    
    
    if (_timeLabel == nil) {
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _timeLabel.textColor = [UIColor lightGrayColor];
        _timeLabel.font = TimeLabelFont;
        _timeLabel.hidden = YES;
        [self.contentView addSubview:_timeLabel];
    }
    
    
    if (_likeCmtButton == nil) {
        _likeCmtButton = [[UIButton alloc] initWithFrame:CGRectZero];
        _likeCmtButton.hidden = YES;
        [_likeCmtButton setImage:[UIImage imageNamed:@"AlbumOperateMore"] forState:UIControlStateNormal];
        [_likeCmtButton setImage:[UIImage imageNamed:@"AlbumOperateMoreHL"] forState:UIControlStateHighlighted];
        [_likeCmtButton addTarget:self action:@selector(onClickLikeCommentBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_likeCmtButton];
    }
    
    
    if (_likeCommentView == nil) {
        y = 0;
        width = BodyMaxWidth;
        height = 10;
        _likeCommentView = [[DFLikeCommentView alloc] initWithFrame:CGRectMake(x, y, width, height)];
        _likeCommentView.delegate = self;
        [self.contentView addSubview:_likeCommentView];  
    }

    
    
    if (_likeCommentToolbar == nil) {
        y = 0;
        x = 0;
        width = ToolbarWidth;
        height = ToolbarHeight;
        _likeCommentToolbar = [[DFLikeCommentToolbar alloc] initWithFrame:CGRectMake(x, y, width, height)];
        _likeCommentToolbar.delegate = self;
        _likeCommentToolbar.hidden = YES;
        [self.contentView addSubview:_likeCommentToolbar];
    }

}




#pragma mark - Method

-(void)updateWithItem:(DFBaseLineItem *)item
{
    self.item = item;
    
    
    [_userAvatarView sd_setImageWithURL:[NSURL URLWithString:item.userAvatar]];
    
    NSAttributedString *userNick  = [[NSAttributedString alloc] initWithString:item.userNick];
    
    CGSize textSize = [MLLinkLabel getViewSize:userNick maxWidth:UserNickMaxWidth font:UserNickFont lineHeight:UserNickLineHeight lines:1];
    
    CGFloat x, y, width, height;
    x = CGRectGetMaxX(_userAvatarView.frame) + Margin;
    y = CGRectGetMinY(_userAvatarView.frame) +2;
    width = textSize.width;
    height = textSize.height;
    
    _userNickLabel.frame = CGRectMake(x, y, width, height);
    _userNickLabel.attributedText = userNick;
    
    
    x = CGRectGetMaxX(_userNickLabel.frame) + Padding;
    width = [UIScreen mainScreen].bounds.size.width - x - Margin;
    _titleLabel.frame = CGRectMake(x, y, width, height);
    _titleLabel.text = item.title;
    _titleLabel.hidden = item.title == nil || [item.title isEqualToString:@""];
}


-(void)updateBodyView:(CGFloat) height
{
    CGFloat x, y, width;
    x = _bodyView.frame.origin.x;
    y = _bodyView.frame.origin.y;
    width = _bodyView.frame.size.width;
    height = height;
    _bodyView.frame = CGRectMake(x, y, width, height);
    
    [self updateLocationLikeComment:height];
    
}


-(void) updateLocationLikeComment:(CGFloat)height
{
    
    CGFloat x, y, width, sumHeight=0.0;
    
    x = _bodyView.frame.origin.x;
    y = _bodyView.frame.origin.y;
    width = _bodyView.frame.size.width;
    
    //位置
    if (self.item.location != nil && ![self.item.location isEqualToString:@""]) {
        y = CGRectGetMaxY(_bodyView.frame) + Padding;
        height = LocationLabelHeight;
        _locationLabel.hidden = NO;
        _locationLabel.frame = CGRectMake(x, y, width, height);
        _locationLabel.text = self.item.location;
        
        sumHeight+=LocationLabelHeight+Padding;
        
    }else{
        _locationLabel.hidden = YES;
    }
    
    //时间
    y = CGRectGetMaxY(_bodyView.frame) + sumHeight + Padding;
    width = 100;
    height = TimeLabelHeight;
    _timeLabel.hidden = NO;
    _timeLabel.frame = CGRectMake(x, y, width, height);
    _timeLabel.text = [DFToolUtil preettyTime:self.item.ts];
    
    
    //点赞评论按钮
    width = 25;
    height = 25;
    x = CGRectGetMaxX(_bodyView.frame) - width;
    _likeCmtButton.hidden = NO;
    _likeCmtButton.frame = CGRectMake(x+2, y-7, width, height);
    
    
    //点赞和评论Toolbar
    width = _likeCommentToolbar.frame.size.width;
    height = _likeCommentToolbar.frame.size.height;
    x = CGRectGetMinX(_likeCmtButton.frame) - width - 10;
    y = CGRectGetMinY(_likeCmtButton.frame) - 1;
    _likeCommentToolbar.frame = CGRectMake(x, y, width, height);
    
    //点赞和评论
    if (self.item.likes.count ==0 && self.item.comments.count == 0) {
        
        _likeCommentView.hidden = YES;
    }else{
        _likeCommentView.hidden = NO;
        
        x = CGRectGetMinX(_timeLabel.frame);
        y = CGRectGetMaxY(_timeLabel.frame)+LikeCommentTimeSpace;
        width = _likeCommentView.frame.size.width;
        height = [DFLikeCommentView getHeight:self.item maxWidth:BodyMaxWidth];
        _likeCommentView.frame = CGRectMake(x, y, width, height);
        [_likeCommentView updateWithItem:self.item];
    }
    
    
    
}

-(CGFloat)getReuseableCellHeight:(DFBaseLineItem *)item
{
    if (item.cellHeight != 0) {
        NSLog(@"重用高度 %f", item.cellHeight);
        return item.cellHeight;
    }
    CGFloat height = [self getCellHeight:item];
    item.cellHeight = height;
    NSLog(@"计算高度 %f", item.cellHeight);
    
    return height;
}



-(CGFloat)getCellHeight:(DFBaseLineItem *)item
{
    //基本
    CGFloat height = Margin + UserAvatarSize;
    
    //位置
    if (item.location != nil && ![item.location isEqualToString:@""]) {
        height+=LocationLabelHeight+Padding;
    }
    
    //时间
    height+= TimeLabelHeight + Padding;
    
    //点赞和评论
    if (!(item.likes.count == 0 && item.comments.count == 0)) {
        height+=[DFLikeCommentView getHeight:item maxWidth:BodyMaxWidth]+LikeCommentTimeSpace;
    }
    
    return height;
}


-(DFBaseLineCell *)getCell:(UITableView *)tableView
{
    return nil;
}


-(UINavigationController *)getController
{
    UITableView *tableView = (UITableView *)self.superview.superview;
    UIViewController *controller = (UIViewController *)tableView.dataSource;
    return controller.navigationController;
}


-(void) onClickUserAvatar:(id)sender
{
    if (_delegate != nil && [_delegate respondsToSelector:@selector(onClickUser:)]) {
        [_delegate onClickUser:self.item.userId];
    }
}


-(void) onClickLikeCommentBtn:(id)sender
{
    _isLikeCommentToolbarShow = !_isLikeCommentToolbarShow;
    _likeCommentToolbar.hidden = !_isLikeCommentToolbarShow;
}



-(void)hideLikeCommentToolbar
{
    if (_isLikeCommentToolbarShow == NO) {
        return;
    }
    _isLikeCommentToolbarShow = NO;
    _likeCommentToolbar.hidden = YES;
}


#pragma mark - DFLikeCommentToolbarDelegate

-(void)onLike
{
   
    [self hideLikeCommentToolbar];
    
    if (_delegate != nil && [_delegate respondsToSelector:@selector(onLike:)]) {
        [_delegate onLike:self.item.itemId];
    }
}


-(void)onComment
{
    
    [self hideLikeCommentToolbar];
    
    if (_delegate != nil && [_delegate respondsToSelector:@selector(onComment:)]) {
        [_delegate onComment:self.item.itemId];
    }
}



#pragma mark - DFLikeCommentViewDelegate

-(void)onClickUser:(NSUInteger)userId
{
    if (_delegate != nil && [_delegate respondsToSelector:@selector(onClickUser:)]) {
        [_delegate onClickUser:userId];
    }

}

-(void)onClickComment:(long long)commentId
{
    if (_delegate != nil && [_delegate respondsToSelector:@selector(onClickComment:itemId:)]) {
        [_delegate onClickComment:commentId itemId:self.item.itemId];
    }
}
@end
