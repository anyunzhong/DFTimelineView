//
//  DFBaseLineCell.m
//  DFTimelineView
//
//  Created by Allen Zhong on 15/9/27.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//





#define UserNickFont [UIFont systemFontOfSize:16]
#define TitleLabelFont [UIFont systemFontOfSize:13]

//#define UserNickLabelHeight 15
#define UserNickMaxWidth 150

#define UserNickLineHeight 1.0f


#import "DFBaseLineCell.h"
#import "MLLinkLabel.h"


@interface DFBaseLineCell()

@property (nonatomic, strong) UIImageView *userAvatarView;

@property (nonatomic, strong) MLLinkLabel *userNickLabel;

@property (nonatomic, strong) UILabel *titleLabel;

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
}



-(void)updateWithItem:(DFBaseLineItem *)item
{
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
    
    
    x = CGRectGetMaxX(_userNickLabel.frame) + 10;
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
}

+(CGFloat)getCellHeight:(DFBaseLineItem *)item
{
    return Margin*2 + UserAvatarSize;
}

@end
