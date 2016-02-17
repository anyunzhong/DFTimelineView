//
//  DFLikeCommentView.h
//  DFTimelineView
//
//  Created by Allen Zhong on 15/9/28.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//

#import "DFBaseLineItem.h"

@protocol DFLikeCommentViewDelegate <NSObject>

@required
-(void) onClickUser:(NSUInteger) userId;
-(void) onClickComment:(long long) commentId;

@end



@interface DFLikeCommentView : UIView


@property (nonatomic, weak) id<DFLikeCommentViewDelegate> delegate;


-(void) updateWithItem:(DFBaseLineItem *) item;

+(CGFloat) getHeight:(DFBaseLineItem *) item maxWidth:(CGFloat)maxWidth;

@end
