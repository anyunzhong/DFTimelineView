//
//  DFBaseLineCell.m
//  DFTimelineView
//
//  Created by Allen Zhong on 15/9/27.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//





#define UserNickFont [UIFont systemFontOfSize:16]
#define TitleLabelFont [UIFont systemFontOfSize:13]

#define LocationLabelFont [UIFont systemFontOfSize:11]

#define TimeLabelFont [UIFont systemFontOfSize:12]

//#define UserNickLabelHeight 15
#define UserNickMaxWidth 150

#define LocationLabelHeight 15

#define TimeLabelHeight 15

#define UserNickLineHeight 1.0f


#import "DFBaseLineCell.h"
#import "MLLinkLabel.h"


@interface DFBaseLineCell()


@property (nonatomic, strong) DFBaseLineItem *item;

@property (nonatomic, strong) UIImageView *userAvatarView;

@property (nonatomic, strong) MLLinkLabel *userNickLabel;

@property (nonatomic, strong) UILabel *titleLabel;


@property (nonatomic, strong) UILabel *locationLabel;

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UIButton *likeCmtButton;

@end



@implementation DFBaseLineCell


#pragma mark - Lifecycle
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self initBaseCell];
    }
    return self;
}

-(void) initBaseCell
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    CGFloat x, y, width, height;
    
    if (_userAvatarView == nil ) {
        
        x = Margin;
        y = Margin;
        width = UserAvatarSize;
        height = width;
        _userAvatarView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height)];
        _userAvatarView.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_userAvatarView];
    }
    
    if (_userNickLabel == nil) {
        
        _userNickLabel =[[MLLinkLabel alloc] initWithFrame:CGRectZero];
        _userNickLabel.textColor = [UIColor colorWithRed:25/255.0 green:45/255.0 blue:47/255.0 alpha:1.0];
        _userNickLabel.font = UserNickFont;
        _userNickLabel.numberOfLines = 1;
        _userNickLabel.adjustsFontSizeToFitWidth = NO;
        _userNickLabel.textInsets = UIEdgeInsetsZero;
        
        _userNickLabel.dataDetectorTypes = MLDataDetectorTypeAll;
        _userNickLabel.allowLineBreakInsideLinks = NO;
        _userNickLabel.linkTextAttributes = nil;
        _userNickLabel.activeLinkTextAttributes = nil;
        _userNickLabel.lineHeightMultiple = UserNickLineHeight;
        //_userNickLabel.backgroundColor  = [UIColor darkGrayColor];
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
        //_bodyView.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:_bodyView];
    }
    
    
    
    if (_locationLabel == nil) {
        _locationLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _locationLabel.textColor = [UIColor lightGrayColor];
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
        //_likeCmtButton.backgroundColor = [UIColor darkGrayColor];
        _likeCmtButton.hidden = YES;
        [_likeCmtButton setImage:[UIImage imageNamed:@"AlbumOperateMore"] forState:UIControlStateNormal];
        [_likeCmtButton setImage:[UIImage imageNamed:@"AlbumOperateMoreHL"] forState:UIControlStateHighlighted];
        [self.contentView addSubview:_likeCmtButton];
    }



}



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
    CGFloat x, y, width, sumHeight=0.0;
    x = _bodyView.frame.origin.x;
    y = _bodyView.frame.origin.y;
    width = _bodyView.frame.size.width;
    height = height;
    _bodyView.frame = CGRectMake(x, y, width, height);
    
    
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
    _timeLabel.text = @"昨天";
    
    
    //点赞评论按钮
    width = 25;
    height = 25;
    x = CGRectGetMaxX(_bodyView.frame) - width;
    _likeCmtButton.hidden = NO;
    _likeCmtButton.frame = CGRectMake(x, y-5, width, height);

    
}

+(CGFloat)getCellHeight:(DFBaseLineItem *)item
{
    //基本
    CGFloat height = Margin + UserAvatarSize;
    
    //位置
    if (item.location != nil && ![item.location isEqualToString:@""]) {
        height+=LocationLabelHeight+Padding;
    }
    
    //时间
    height+= TimeLabelHeight + Padding;
    
    return height;
}

@end
