//
//  DFTextImageLineCell.h
//  DFTimelineView
//
//  Created by Allen Zhong on 15/9/27.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//

#import "DFBaseLineCell.h"
#import "DFBaseLineItem.h"
#import "DFGridImageView.h"


@interface DFTextImageLineCell : DFBaseLineCell
@property (strong, nonatomic) DFGridImageView *gridImageView;

-(NSInteger) getIndexFromPoint:(CGPoint) point;

@end
