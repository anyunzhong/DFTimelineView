//
//  DFLikeCommentView.m
//  DFTimelineView
//
//  Created by Allen Zhong on 15/9/28.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//

#import "DFLikeCommentView.h"
#import "MLLinkLabel.h"


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


@interface DFLikeCommentView()


@property (nonatomic, strong) UIImageView *likeCmtBg;

@property (strong, nonatomic) UIImageView *likeIconView;

@property (strong, nonatomic) MLLinkLabel *likeLabel;

@property (strong, nonatomic) MLLinkLabel *commentLabel;

@end



@implementation DFLikeCommentView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
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
        
        
        [_likeLabel setDidClickLinkBlock:^(MLLink *link, NSString *linkText, MLLinkLabel *label) {
            NSString *tips = [NSString stringWithFormat:@"Click\nlinkType:%ld\nlinkText:%@\nlinkValue:%@",(unsigned long)link.linkType,linkText,link.linkValue];
            NSLog(@"%@", tips);
        }];
        
        
        [self addSubview:_likeLabel];
    }

    
    if (_commentLabel == nil) {
        
        _commentLabel =[[MLLinkLabel alloc] initWithFrame:CGRectZero];
        _commentLabel.font = CommentLabelFont;
        _commentLabel.numberOfLines = 0;
        _commentLabel.adjustsFontSizeToFitWidth = NO;
        _commentLabel.textInsets = UIEdgeInsetsZero;
        
        _commentLabel.dataDetectorTypes = MLDataDetectorTypeAll;
        _commentLabel.allowLineBreakInsideLinks = NO;
        _commentLabel.linkTextAttributes = nil;
        _commentLabel.activeLinkTextAttributes = nil;
        _commentLabel.lineHeightMultiple = CommentLabelLineHeight;
        
        
        [_commentLabel setDidClickLinkBlock:^(MLLink *link, NSString *linkText, MLLinkLabel *label) {
            NSString *tips = [NSString stringWithFormat:@"Click\nlinkType:%ld\nlinkText:%@\nlinkValue:%@",(unsigned long)link.linkType,linkText,link.linkValue];
            NSLog(@"%@", tips);
        }];
        
        [self addSubview:_commentLabel];
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
    CGFloat x, y, width;
    
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
        
        _commentLabel.hidden = NO;
        
        
        x = CommentLabelMargin;
        y = TopMargin;
        if (item.likes.count > 0) {
            y = CGRectGetMaxY(_likeLabel.frame) + LikeCommentSpace;
        }
        width = self.frame.size.width - 2*CommentLabelMargin;
        
        NSMutableAttributedString *commentsStr = item.commentsStr;
        
        _commentLabel.attributedText = commentsStr;
        
        [_commentLabel sizeToFit];
        
        CGSize textSize = [MLLinkLabel getViewSize:commentsStr maxWidth:width font:CommentLabelFont lineHeight:CommentLabelLineHeight lines:0];
        
        _commentLabel.frame = CGRectMake(x, y, width, textSize.height);
    }else{
        _commentLabel.hidden = YES;
    }

    
    
    
}




+(CGFloat)getHeight:(DFBaseLineItem *)item maxWidth:(CGFloat)maxWidth
{
    CGFloat height = TopMargin;
    
    if (item.likes.count > 0) {
        
        NSMutableAttributedString *likesStr = item.likesStr;
        
        if (likesStr == nil) {
            NSMutableArray *likes = item.likes;
            NSString *result = @"";
            
            for (int i=0; i<likes.count;i++) {
                NSString *like = [likes objectAtIndex:i];
                if (i == 0) {
                    result = [NSString stringWithFormat:@"%@",like];
                }else{
                    result = [NSString stringWithFormat:@"%@, %@", result, like];
                }
            }
            
            NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:result];
            NSUInteger position = 0;
            for (int i=0; i<likes.count;i++) {
                NSString *like = [likes objectAtIndex:i];
                [attrStr addAttribute:NSLinkAttributeName value:@"http://baidu.com" range:NSMakeRange(position, like.length)];
                position += like.length+2;
            }
            
            item.likesStr = attrStr;
            likesStr = attrStr;
        }

        CGFloat width = maxWidth -  LikeIconLeftMargin - LikeIconSize - LikeLabelIconSpace - LikeLabelRightMargin;
        
        CGSize textSize = [MLLinkLabel getViewSize:likesStr maxWidth:width font:LikeLabelFont lineHeight:LikeLabelLineHeight lines:0];
        
        height+= textSize.height;
    }

    
    if (item.comments.count > 0) {
        
        NSMutableAttributedString *commentStr = item.commentsStr;
        
        if (commentStr == nil) {
            NSMutableArray *comments = item.comments;
            NSString *result = @"";
            
            for (int i=0; i<comments.count;i++) {
                NSString *comment = [comments objectAtIndex:i];
                if (i == 0) {
                    result = [NSString stringWithFormat:@"%@",comment];
                }else{
                    result = [NSString stringWithFormat:@"%@\n%@", result, comment];
                }
            }
            
            NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:result];
//            NSUInteger position = 0;
//            for (int i=0; i<likes.count;i++) {
//                NSString *like = [likes objectAtIndex:i];
//                [attrStr addAttribute:NSLinkAttributeName value:@"http://baidu.com" range:NSMakeRange(position, like.length)];
//                position += like.length+2;
//            }
            
            item.commentsStr = attrStr;
            commentStr = attrStr;
        }
        
        CGFloat width = maxWidth - CommentLabelMargin*2;
        
        CGSize textSize = [MLLinkLabel getViewSize:commentStr maxWidth:width font:CommentLabelFont lineHeight:CommentLabelLineHeight lines:0];
        
        height+= textSize.height;
        
        if (item.likes.count > 0) {
            height+= LikeCommentSpace;
        }
    }

    
    
    
    height+=BottomMargin;
    return height;
}

@end
