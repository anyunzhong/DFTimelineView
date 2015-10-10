//
//  DFLineCommentItem.h
//  DFTimelineView
//
//  Created by Allen Zhong on 15/9/29.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//


@interface DFLineCommentItem : NSObject

@property (nonatomic, assign) long long commentId;

@property (nonatomic, assign) NSUInteger userId;

@property (nonatomic, strong) NSString *userNick;

@property (nonatomic, assign) NSUInteger replyUserId;

@property (nonatomic, strong) NSString *replyUserNick;

@property (nonatomic, strong) NSString *text;

@end
