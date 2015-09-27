//
//  DFBaseLineItem.h
//  DFTimelineView
//
//  Created by Allen Zhong on 15/9/27.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//


typedef NS_ENUM(NSUInteger, LineItemType){
    LineItemTypeTextImage,
    LineItemTypeShare,
};


@interface DFBaseLineItem : NSObject

@property (nonatomic, assign) LineItemType itemType;

@property (nonatomic, assign) NSUInteger userId;
@property (nonatomic, strong) NSString *userNick;
@property (nonatomic, strong) NSString *userAvatar;

@property (nonatomic, strong) NSString *title;


@end
