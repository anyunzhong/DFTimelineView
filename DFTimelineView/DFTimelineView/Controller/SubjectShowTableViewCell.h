//
//  SubjectShowTableViewCell.h
//  DFTimelineView
//
//  Created by 刘一智 on 16/7/20.
//  Copyright © 2016年 Datafans, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DFPlainGridImageView.h"

@interface SubjectShowTableViewCell : UITableViewCell <DFPlainGridImageViewDelegate>

@property (nonatomic) UIView *backView;

@property (nonatomic) UILabel *titleLabel;

@property (nonatomic) UILabel *stateLabel;

@property (nonatomic) UILabel *itemNumber;

@property (nonatomic) UILabel *likeNumber;

@property (nonatomic) UILabel *imageContentTitle;

@property (nonatomic) DFPlainGridImageView * gridView;

- (void)setData:(NSDictionary *)dictionary;

@end
