//
//  SubjectShowTableViewCell.h
//  DFTimelineView
//
//  Created by 刘一智 on 16/7/20.
//  Copyright © 2016年 Datafans, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DFPlainGridImageView.h"
#import "DFGridImageView.h"

@interface SubjectShowTableViewCell : UITableViewCell <DFPlainGridImageViewDelegate>

@property (nonatomic) UIView *backView;

@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UILabel *detailLabel;

@property (nonatomic) UIView *colorView;

@property (nonatomic) UIView *lineView;

@property (nonatomic) UILabel *stateLabel;

@property (nonatomic) UILabel *itemNumber;  //发布数量

@property (nonatomic) UILabel *likeNumber;  //点赞数量

@property (nonatomic) UILabel *moreLabel;  //更多label

@property (nonatomic) UILabel *imageContentTitle;

@property (nonatomic) DFGridImageView * gridView;

- (void)setData:(NSDictionary *)dictionary;

@end
