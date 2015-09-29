//
//  DFGridImageView.h
//  DFTimelineView
//
//  Created by Allen Zhong on 15/9/27.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DFGridImageView : UIView

-(void) updateWithImages:(NSMutableArray *)images srcImages:(NSMutableArray *)srcImages oneImageWidth:(CGFloat)oneImageWidth oneImageHeight:(CGFloat)oneImageHeight;

+(CGFloat) getHeight:(NSMutableArray *) images maxWidth:(CGFloat)maxWidth oneImageWidth:(CGFloat)oneImageWidth oneImageHeight:(CGFloat)oneImageHeight;

@end
