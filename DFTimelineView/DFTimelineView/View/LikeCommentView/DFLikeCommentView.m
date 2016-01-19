//
//  DFLikeCommentView.m
//  DFTimelineView
//
//  Created by Allen Zhong on 15/9/28.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//

#import "DFLikeCommentView.h"
#import "MLLabel+Size.h"
#import "DFLineLikeItem.h"
#import "DFLineCommentItem.h"
#import "Const.h"

//#import <MLLinkClickLabel.h>

#import "MLClickColorLinkLabel.h"


#define TopMargin 10
#define BottomMargin 6


#define LikeLabelFont [UIFont systemFontOfSize:14]

#define LikeLabelLineHeight 1.1f

#define LikeIconLeftMargin 8
#define LikeIconTopMargin 14
#define LikeIconSize 15

#define LikeLabelIconSpace 5
#define LikeLabelRightMargin 10


#define CommentLabelFont [UIFont systemFontOfSize:14]

#define CommentLabelLineHeight 1.2f


#define CommentLabelMargin 10

#define LikeCommentSpace 5

#define LinkLabelTag 100


@interface DFLikeCommentView()<MLLinkClickLabelDelegate>


@property (nonatomic, strong) UIImageView *likeCmtBg;

@property (strong, nonatomic) UIImageView *likeIconView;

@property (strong, nonatomic) MLLinkLabel *likeLabel;

@property (strong, nonatomic) UIView *divider;


@property (strong, nonatomic) NSMutableArray *commentLabels;

@end



@implementation DFLikeCommentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _commentLabels = [NSMutableArray array];
        
        [self initView];
    }
    return self;
}


-(void) initView
{
    CGFloat x,y,width,height;
    
    if (_likeCmtBg == nil) {
        x = 0;
        y = 0;
        width = self.frame.size.width;
        height = self.frame.size.height;
        
        _likeCmtBg = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height)];
        UIImage *image = [UIImage imageNamed:@"LikeCmtBg"];
        image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(20, 30, 10, 10) resizingMode:UIImageResizingModeStretch];
        _likeCmtBg.image = image;
        [self addSubview:_likeCmtBg];
    }
    
    if (_likeIconView == nil) {
        x = LikeIconLeftMargin;
        y = LikeIconTopMargin;
        width = LikeIconSize;
        height = width;
        _likeIconView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height)];
        _likeIconView.image = [UIImage imageNamed:@"Like"];
        [self addSubview:_likeIconView];
    }
    
    
    if (_likeLabel == nil) {
        
        _likeLabel =[[MLLinkLabel alloc] initWithFrame:CGRectZero];
        _likeLabel.font = LikeLabelFont;
        _likeLabel.numberOfLines = 0;
        _likeLabel.adjustsFontSizeToFitWidth = NO;
        _likeLabel.textInsets = UIEdgeInsetsZero;
        
        _likeLabel.dataDetectorTypes = MLDataDetectorTypeAll;
        _likeLabel.allowLineBreakInsideLinks = NO;
        _likeLabel.linkTextAttributes = nil;
        _likeLabel.activeLinkTextAttributes = nil;
        _likeLabel.lineHeightMultiple = LikeLabelLineHeight;
        _likeLabel.linkTextAttributes = @{NSForegroundColorAttributeName: HighLightTextColor};
        
        __block DFLikeCommentView *likeCommentView = self;
        
        [_likeLabel setDidClickLinkBlock:^(MLLink *link, NSString *linkText, MLLinkLabel *label) {
            
            if (_delegate != nil && [_delegate respondsToSelector:@selector(onClickUser:)]) {
                
                NSUInteger userId = [link.linkValue integerValue];
                [likeCommentView.delegate onClickUser:userId];
            }
        }];
        
        
        
        [self addSubview:_likeLabel];
    }
    
    
    if (_divider == nil) {
        _divider = [[UIView alloc] initWithFrame:CGRectZero];
        _divider.backgroundColor = [UIColor colorWithWhite:225/255.0 alpha:1.0];
        [self addSubview:_divider];
    }
    
    
}


-(void)layoutSubviews
{
    CGFloat x,y,width,height;
    x = 0;
    y = 0;
    width = self.frame.size.width;
    height = self.frame.size.height;
    
    _likeCmtBg.frame = CGRectMake(x, y, width, height);
    
}


-(void)updateWithItem:(DFBaseLineItem *)item
{
    CGFloat x, y, width, height;
    
    
    _divider.hidden = YES;
    
    if (item.likes.count > 0) {
        
        _likeLabel.hidden = NO;
        _likeIconView.hidden = NO;
        
        
        x = CGRectGetMaxX(_likeIconView.frame)+LikeLabelIconSpace;
        y = TopMargin;
        width = self.frame.size.width - x - LikeLabelRightMargin;
        
        NSMutableAttributedString *likesStr = item.likesStr;
        
        _likeLabel.attributedText = likesStr;
        
        [_likeLabel sizeToFit];
        
        CGSize textSize = [MLLinkLabel getViewSize:likesStr maxWidth:width font:LikeLabelFont lineHeight:LikeLabelLineHeight lines:0];
        
        _likeLabel.frame = CGRectMake(x, y, width, textSize.height);
    }else{
        _likeLabel.hidden = YES;
        _likeIconView.hidden = YES;
    }
    
    
    
    if (item.comments.count > 0) {
        
        if (item.likes.count > 0) {
            //显示分割线
            y = CGRectGetMaxY(_likeLabel.frame) + LikeCommentSpace;
            _divider.hidden = NO;
            _divider.frame = CGRectMake(0, y, self.frame.size.width, 0.5);
        }
        
        CGFloat sumHeight = TopMargin;
        
        if (item.likes.count > 0) {
            sumHeight = CGRectGetMaxY(_likeLabel.frame) + LikeCommentSpace;
        }
        
        NSUInteger labelCount = _commentLabels.count;
        
        for (int i=0; i<labelCount; i++) {
            MLLinkClickLabel *label = [_commentLabels objectAtIndex:i];
            label.attributedText = nil;
            label.frame = CGRectZero;
            label.hidden = !(i<item.comments.count);
        }
        
        for (int i=0;i<item.comments.count;i++) {
            
            MLLinkClickLabel *label;
            
            if ( labelCount > 0 && i < labelCount) {
                label = [_commentLabels objectAtIndex:i];
            }else{
                label = [self createLinkLabel];
                [_commentLabels addObject:label];
                [self addSubview:label];
            }
            
            DFLineCommentItem *commentItem = [item.comments objectAtIndex:i];
            
            label.hidden = NO;
            NSAttributedString *str = [item.commentStrArray objectAtIndex:i];
            label.attributedText = str ;
            label.uniqueId = commentItem.commentId;
            [label sizeToFit];
            
            width = self.frame.size.width - 2*CommentLabelMargin;
            CGSize size = [MLLabel getViewSize:label.attributedText maxWidth:width font:CommentLabelFont lineHeight:CommentLabelLineHeight lines:0];
            
            
            x = CommentLabelMargin;
            y = sumHeight;
            height = size.height;
            
            sumHeight+=height;
            
            label.frame = CGRectMake(x, y, width, height);
        }
        
        
        
        
    }else{
        
        for (int i=0; i<_commentLabels.count; i++) {
            MLLinkClickLabel *label = [_commentLabels objectAtIndex:i];
            label.attributedText = nil;
            label.frame = CGRectZero;
            label.hidden = YES;
        }
        
    }
    
    
    
    
}



-(MLClickColorLinkLabel *) createLinkLabel
{
    
    MLClickColorLinkLabel *lable = [[MLClickColorLinkLabel alloc] initWithFrame:CGRectZero];
    lable.clickDelegate = self;
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    [lable addGestureRecognizer:longPress];
    
    lable.tag = LinkLabelTag;
    
    
    lable.font = LikeLabelFont;
    lable.numberOfLines = 0;
    lable.adjustsFontSizeToFitWidth = NO;
    lable.textInsets = UIEdgeInsetsZero;
    
    lable.dataDetectorTypes = MLDataDetectorTypeAll;
    lable.allowLineBreakInsideLinks = NO;
    lable.linkTextAttributes = nil;
    lable.activeLinkTextAttributes = nil;
    lable.lineHeightMultiple = CommentLabelLineHeight;
    lable.linkTextAttributes = @{NSForegroundColorAttributeName: HighLightTextColor};
    
    __block DFLikeCommentView *likeCommentView = self;
    
    [lable setDidClickLinkBlock:^(MLLink *link, NSString *linkText, MLLinkLabel *label) {
        
        if (_delegate != nil && [_delegate respondsToSelector:@selector(onClickUser:)]) {
            
            NSUInteger userId = [link.linkValue integerValue];
            [likeCommentView.delegate onClickUser:userId];
        }
    }];
    
    
    return lable;
    
}

-(void)longPress:(UITapGestureRecognizer*)recognizer
{
    NSLog(@"长按了Label");
}

-(void)onClickOutsideLink:(long long)uniqueId
{
    NSLog(@"单击了Label: %lld", uniqueId);
    if (_delegate && [_delegate respondsToSelector:@selector(onClickComment:)]) {
        [_delegate onClickComment:uniqueId];
    }
}


+(CGFloat)getHeight:(DFBaseLineItem *)item maxWidth:(CGFloat)maxWidth
{
    CGFloat height = TopMargin;
    
    if (item.likes.count > 0) {
        
        CGFloat width = maxWidth -  LikeIconLeftMargin - LikeIconSize - LikeLabelIconSpace - LikeLabelRightMargin;
        
        CGSize textSize = [MLLinkLabel getViewSize:item.likesStr maxWidth:width font:LikeLabelFont lineHeight:LikeLabelLineHeight lines:0];
        
        height+= textSize.height;
    }
    
    
    if (item.comments.count > 0) {
        
        CGFloat width = maxWidth - CommentLabelMargin*2;
        
        NSMutableArray *commentStrArray = item.commentStrArray;
        
        for (NSMutableAttributedString *str in commentStrArray) {
            CGSize textSize = [MLLinkLabel getViewSize:str maxWidth:width font:CommentLabelFont lineHeight:CommentLabelLineHeight lines:0];
            height+= textSize.height;
        }
        
        if (item.likes.count > 0) {
            height+= LikeCommentSpace;
        }
    }
    
    
    height+=BottomMargin;
    return height;
}

@end
