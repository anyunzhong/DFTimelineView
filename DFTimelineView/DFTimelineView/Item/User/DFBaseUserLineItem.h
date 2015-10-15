//
//  DFBaseUserLineItem.h
//  DFTimelineView
//
//  Created by Allen Zhong on 15/10/15.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//

typedef NS_ENUM(NSUInteger, UserLineItemType){
    UserLineItemTypeTextImage,
    UserLineItemTypeShare,
};



@interface DFBaseUserLineItem : NSObject

@property (nonatomic, assign) long long itemId;

@property (nonatomic, assign) UserLineItemType itemType;

@property (nonatomic, assign) long long ts;

@property (nonatomic, assign) NSUInteger year;

@property (nonatomic, assign) NSUInteger month;

@property (nonatomic, assign) NSUInteger day;

@property (nonatomic, assign) BOOL bShowTime;

@end
