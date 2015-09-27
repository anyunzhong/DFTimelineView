//
//  DFBaseLineCell.h
//  DFTimelineView
//
//  Created by Allen Zhong on 15/9/27.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//

#import "UIImageView+WebCache.h"
#import "DFBaseLineItem.h"


#define Margin 15

#define UserAvatarSize 40

#define  BodyMaxWidth [UIScreen mainScreen].bounds.size.width - UserAvatarSize - 3*Margin

@interface DFBaseLineCell : UITableViewCell


@property (nonatomic, strong) UIView *bodyView;



-(void) updateWithItem:(DFBaseLineItem *) item;

+(CGFloat) getCellHeight:(DFBaseLineItem *) item;

-(void)updateBodyView:(CGFloat) height;

@end
