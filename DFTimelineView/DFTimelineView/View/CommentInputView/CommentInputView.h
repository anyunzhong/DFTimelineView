//
//  CommentInputView.h
//  DFTimelineView
//
//  Created by Allen Zhong on 15/10/10.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//



@protocol CommentInputViewDelegate <NSObject>

@required

-(void) onCommentCreate:(long long ) commentId text:(NSString *) text;


@end




@interface CommentInputView : UIView


@property (nonatomic, weak) id<CommentInputViewDelegate> delegate;

@property (nonatomic, assign) long long commentId;

-(void) addNotify;

-(void) removeNotify;

-(void) addObserver;

-(void) removeObserver;

-(void) show;

-(void) setPlaceHolder:(NSString *) text;

@end
